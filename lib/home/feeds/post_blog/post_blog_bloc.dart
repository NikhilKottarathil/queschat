import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/function/select_image.dart';
import 'package:queschat/home/feeds/feeds_repo.dart';
import 'package:queschat/home/feeds/post_blog/post_blog_event.dart';
import 'package:queschat/home/feeds/post_blog/post_blog_state.dart';

class PostBlogBloc extends Bloc<PostBlogEvent, PostBlogState> {
  final FeedRepository feedRepo;

  PostBlogBloc({this.feedRepo}) : super(PostBlogState(media: []));

  @override
  Stream<PostBlogState> mapEventToState(PostBlogEvent event) async* {
    if (event is HeadingChanged) {
      yield state.copyWith(heading: event.heading);
    } else if (event is ContentChanged) {
      yield state.copyWith(content: event.content);
    } else if (event is SelectMedia) {
      try {
        FilePickerResult result = await FilePicker.platform.pickFiles(
          type: FileType.any,
          allowCompression: true,

        );
        print(result);
        if(result!=null){

          PlatformFile platformFile=result.files.first;
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
          media:[],
          formSubmissionStatus: InitialFormStatus());
    } else if (event is PostBlogSubmitted) {
      yield state.copyWith(formSubmissionStatus: FormSubmitting());

      try {
        String id= await feedRepo.postBlog(
            heading: state.heading, content: state.content, media: state.media);
        yield state.copyWith(formSubmissionStatus: SubmissionSuccess(id: id));
      } catch (e) {
        yield state.copyWith(formSubmissionStatus: SubmissionFailed(e));
        yield state.copyWith(formSubmissionStatus: InitialFormStatus());
      }
    }
  }
}
