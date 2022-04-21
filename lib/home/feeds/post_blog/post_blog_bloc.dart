import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/constants/strings_and_urls.dart';
import 'package:queschat/function/api_calls.dart';
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

  List<String> mediaIds = [];
  String mediaIdsString='';


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

  setBlogData() async {
    state.heading = oldBlogModel.heading;
    state.content = oldBlogModel.content;
    state.mediaUrls = oldBlogModel.images;
    mediaIdsString=oldBlogModel.mediaIds!=null?oldBlogModel.mediaIds:'';
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
        await Future.forEach(controller.document.toDelta().toJson(),
            (element) async {
          if (element['insert'][0] == null) {
            if (element['insert']['image'] != null ||
                element['insert']['video']!=null) {
              String filePath = element['insert']['image']!=null?element['insert']['image']:element['insert']['video'];
              if (!filePath.contains('http')) {
                File file = File(filePath);
                Map<String, String> requestBody = {};
                // final appDocDir = await getApplicationDocumentsDirectory();

                // var result = await FlutterImageCompress.compressAndGetFile(
                //   file.absolute.path,
                //   '${appDocDir.path}/${basename(file.path)}',
                //   quality: 60,
                // );



                var body = await postImageDataRequest(
                    imageAddress: 'images',
                    address: 'media',
                    imageFile: file,
                    myBody: requestBody);

                if (body['url'] != null) {
                  mediaIds.add(body['media_id'].toString());
                  if (element['insert']['video'] != null) {
                    element['insert']['video'] =
                        Urls().serverAddress + body['url'];
                  }
                  if (element['insert']['image'] != null) {
                    element['insert']['image'] =
                        Urls().serverAddress + body['url'];
                  }
                }
              }
            }
          }
        });
        mediaIds.forEach((element) {
          if(mediaIdsString==''){
            mediaIdsString=element;
          }else{
            mediaIdsString=mediaIdsString+','+element;
          }
        });

        String id = await feedRepo.postBlog(messageRoomId: messageRoomCubit.chatRoomModel.id,
            content: jsonEncode(controller.document.toDelta().toJson()),
            media: state.media,mediaIds: mediaIdsString);
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
        await Future.forEach(controller.document.toDelta().toJson(),
                (element) async {
              if (element['insert'][0] == null) {
                if (element['insert']['image'] != null ||
                    element['insert']['video']!=null) {
                  String filePath = element['insert']['image']!=null?element['insert']['image']:element['insert']['video'];
                  if (!filePath.contains('http')) {
                    File file = File(filePath);
                    Map<String, String> requestBody = {};
                    // final appDocDir = await getApplicationDocumentsDirectory();

                    // var result = await FlutterImageCompress.compressAndGetFile(
                    //   file.absolute.path,
                    //   '${appDocDir.path}/${basename(file.path)}',
                    //   quality: 60,
                    // );



                    var body = await postImageDataRequest(
                        imageAddress: 'images',
                        address: 'media',
                        imageFile: file,
                        myBody: requestBody);

                    if (body['url'] != null) {
                      mediaIds.add(body['media_id'].toString());
                      if (element['insert']['video'] != null) {
                        element['insert']['video'] =
                            Urls().serverAddress + body['url'];
                      }
                      if (element['insert']['image'] != null) {
                        element['insert']['image'] =
                            Urls().serverAddress + body['url'];
                      }
                    }
                  }
                }
              }
            });
        mediaIds.forEach((element) {
          if(mediaIdsString==''){
            mediaIdsString=element;
          }else{
            mediaIdsString=mediaIdsString+','+element;
          }
        });

        await feedRepo.editBlog(
            heading: state.heading, content: state.content, feedId: feedId,mediaIds: mediaIdsString);
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
