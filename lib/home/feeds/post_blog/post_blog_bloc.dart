import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/home/feeds/feeds_event.dart';
import 'package:queschat/home/feeds/feeds_repo.dart';
import 'package:queschat/home/feeds/post_blog/post_blog_event.dart';
import 'package:queschat/home/feeds/post_blog/post_blog_state.dart';
import 'package:queschat/home/message/message_room/message_room_cubit.dart';
import 'package:queschat/models/blog_nodel.dart';
import 'package:queschat/models/message_model.dart';
import 'package:queschat/router/app_router.dart';

class PostBlogBloc extends Bloc<PostBlogEvent, PostBlogState> {
  final FeedRepository feedRepo;
  String parentPage, feedId;
  BlogModel oldBlogModel;
  MessageRoomCubit messageRoomCubit;
  QuillController controller = QuillController.basic();

  String oldBlogId;

  PostBlogBloc(
      {@required this.feedRepo,
      @required this.messageRoomCubit,
      @required this.parentPage,
      this.feedId,
      this.oldBlogModel})
      : super(PostBlogState(
          media: [],
          mediaUrls: [],
        )) {
    if (parentPage == 'myFeeds') {
      setBlogData();
    }
  }

  setBlogData() {
    state.heading = oldBlogModel.heading;
    state.content = oldBlogModel.content;
    state.mediaUrls = oldBlogModel.images;
    var myJSON = jsonDecode(state.content);
    controller = QuillController(
        document: Document.fromJson(myJSON),
        selection: TextSelection.collapsed(offset: 0));
  }

  @override
  Stream<PostBlogState> mapEventToState(PostBlogEvent event) async* {
    // if (event is HeadingChanged) {
    //   yield state.copyWith(heading: event.heading);
    // }
    // else
    //   if (event is ContentChanged) {
    //   yield state.copyWith(content: event.content);
    // } else
    if (event is SelectMedia) {
      try {
        FilePickerResult result = await FilePicker.platform.pickFiles(
          type: FileType.any,
          allowCompression: true,
        );
        if (result != null) {
          PlatformFile platformFile = result.files.first;
          final File file = File(platformFile.path);
          state.media..add(file);
          yield state.copyWith();
        }
      } catch (e) {
        print(e);
      }
    } else if (event is ClearAllFields) {
      yield state.copyWith(
          heading: '',
          content: '',
          media: [],
          formSubmissionStatus: InitialFormStatus());
    } else if (event is PostBlogSubmitted) {
      yield state.copyWith(formSubmissionStatus: FormSubmitting());

      try {
        String id = await feedRepo.postBlog(
            content: jsonEncode(controller.document.toDelta().toJson()),
            media: state.media);
        // heading: 'state.heading', content:'sonEncode(controller.document.toDelta().toJson()', media: state.media);
        if (messageRoomCubit != null) {
          messageRoomCubit.sendMessage(
              messageType: MessageType.feed, feedId: id);
        }
        yield state.copyWith(formSubmissionStatus: SubmissionSuccess(id: id));
      } catch (e) {
        yield state.copyWith(formSubmissionStatus: SubmissionFailed(e));
        yield state.copyWith(formSubmissionStatus: InitialFormStatus());
      }
    } else if (event is EditBlogSubmitted) {
      yield state.copyWith(formSubmissionStatus: FormSubmitting());

      try {
        await feedRepo.editBlog(
            heading: state.heading, content: state.content, feedId: feedId);
        if (homeFeedBloc.state.feedIds.contains(feedId)) {
          homeFeedBloc.add(EditedAFeed(feedId: feedId));
        }
        if (savedFeedBloc.state.feedIds.contains(feedId)) {
          savedFeedBloc.add(EditedAFeed(feedId: feedId));
        }
        if (myFeedsBloc.state.feedIds.contains(feedId)) {
          myFeedsBloc.add(EditedAFeed(feedId: feedId));
        }

        yield state.copyWith(formSubmissionStatus: SubmissionSuccess());
      } catch (e) {
        yield state.copyWith(formSubmissionStatus: SubmissionFailed(e));
        yield state.copyWith(formSubmissionStatus: InitialFormStatus());
      }
    }
  }
}
