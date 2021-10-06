import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/function/select_image.dart';
import 'package:queschat/home/feeds/feeds_repo.dart';
import 'package:queschat/home/feeds/quiz/post_quiz_event.dart';
import 'package:queschat/home/feeds/quiz/post_quiz_state.dart';
import 'package:queschat/home/feeds/quiz/quiz_mcq/quiz_mcq_state.dart';

class PostQuizBloc extends Bloc<PostQuizEvent, PostQuizState> {
  final FeedRepository feedRepo;


  PostQuizBloc({@required this.feedRepo})
      : super(PostQuizState(mcqList: [],images: []));


  @override
  Stream<PostQuizState> mapEventToState(PostQuizEvent event) async* {
    if (event is HeadingChanged) {
      yield state.copyWith(heading: event.heading);
    } else if (event is ContentChanged) {
      yield state.copyWith(content: event.content);
    }else if (event is SelectMedia) {
      try {
        File  file;
        file = await selectImage(
            imageFile: file,
            context: event.context);
        if(file!=null){
        state.images.add(file);
        }
        yield state.copyWith( );
      } catch (e) {
        print(e);
      }

    } else if (event is ClearAllFields) {
      yield state.copyWith(
          heading: '',
          content: '',
          mcqList: [],
          formSubmissionStatus: InitialFormStatus());
    } else if (event is CreateQuizSubmitted) {
      state.mcqList.add(new QuizMcqState(questionImages: [],isImageOptions: false));
      try{
        yield state.copyWith(formSubmissionStatus: SubmissionSuccess(id:'id'));
        yield state.copyWith(formSubmissionStatus: InitialFormStatus());

      }catch(e){
        yield state.copyWith(formSubmissionStatus: SubmissionFailed(e));
        yield state.copyWith(formSubmissionStatus: InitialFormStatus());

      }
    }
    else if (event is AddNewMCQ) {
      state.mcqList[state.currentIndex]=event.quizMcqState;
      state.mcqList.add(new QuizMcqState(questionImages: [],isImageOptions: false,optionA: ''));

      print(state.currentIndex);
      print(state.mcqList.length);
      yield state.copyWith(currentIndex: state.currentIndex+1);
    }else if (event is ShowPreviousMCQ) {
      state.mcqList[state.currentIndex]=event.quizMcqState;
      yield state.copyWith(currentIndex: state.currentIndex-1);
    }else if (event is ShowNextMCQ) {
      state.mcqList[state.currentIndex]=event.quizMcqState;
      yield state.copyWith(currentIndex: state.currentIndex+1);
    }else if (event is PostQuizSubmitted) {
      state.mcqList[state.currentIndex]=event.quizMcqState;

      try{
        String id=await feedRepo.postQuiz(media: state.images,content: state.content,heading: state.heading,mcqList: state.mcqList);
        yield state.copyWith(formSubmissionStatus: SubmissionSuccess(id:id));

      }catch(e){
        yield state.copyWith(formSubmissionStatus: SubmissionFailed(e));
        yield state.copyWith(formSubmissionStatus: InitialFormStatus());

      }
    }

  }
}
