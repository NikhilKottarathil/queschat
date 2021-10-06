import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/function/select_image.dart';
import 'package:queschat/home/feeds/feeds_repo.dart';
import 'package:queschat/home/feeds/post_a_mcq/post_mcq_event.dart';
import 'package:queschat/home/feeds/post_a_mcq/post_mcq_state.dart';


class PostMcqBloc extends Bloc< PostMcqEvent, PostMcqState> {
  final FeedRepository feedRepo;

  PostMcqBloc({this.feedRepo}) : super(PostMcqState(questionImages: []));

  @override
  Stream<PostMcqState> mapEventToState(PostMcqEvent event) async* {
    if (event is QuestionChanged) {
      yield state.copyWith(question: event.question);

    }else if (event is SelectQuestionImages) {
      try {
        File  file;
        file = await selectImage(
            imageFile: file,
            context: event.context);
        if(file!=null) {
          state.questionImages.add(file);
        }
        yield state.copyWith( );
      } catch (e) {
        print(e);
      }

    }else if (event is ChooseOptionType) {
      yield state.copyWith(isImageOptions: !state.isImageOptions);

    }else if (event is OptionAChanged) {
      yield state.copyWith(optionA: event.optionA);

    } else if (event is OptionBChanged) {
      yield state.copyWith(optionB: event.optionB);
    }
    else if (event is OptionCChanged) {
      yield state.copyWith(optionC:event.optionC);

    }else if (event is OptionDChanged) {
      yield state.copyWith(optionD:event.optionD);
    }else if (event is SelectOptionAImage) {
      try {
        state.optionAImage = await selectImage(
            imageFile: state.optionAImage,
            context: event.context);
        yield state.copyWith();
      } catch (e) {
        print(e);
      }
   }else if (event is SelectOptionBImage) {
      try {
        state.optionBImage = await selectImage(
            imageFile: state.optionBImage,
            context: event.context);
        yield state.copyWith();
      } catch (e) {
        print(e);
      }
   }else if (event is SelectOptionCImage) {
      try {
        state.optionCImage = await selectImage(
            imageFile: state.optionCImage,
            context: event.context);
        yield state.copyWith();
      } catch (e) {
        print(e);
      }
   }else if (event is SelectOptionDImage) {
      try {
        state.optionDImage = await selectImage(
            imageFile: state.optionDImage,
            context: event.context);
        yield state.copyWith();
      } catch (e) {
        print(e);
      }
   }
    else if (event is CorrectOptionChanged) {
      yield state.copyWith(correctOption:event.correctOption);
    }
    else if (event is ClearAllFields) {
      yield state.copyWith(correctOption:'',optionD: '',optionC: '',optionB: '',optionA: '',question: '',formSubmissionStatus: InitialFormStatus());
    }
    else if (event is PostMcqSubmitted) {
      yield state.copyWith(formSubmissionStatus: FormSubmitting());

      try {
        if(state.isImageOptions){
          String id = await feedRepo.postMCQWithImage(question: state.question,
              questionImages:state.questionImages,
              optionA: state.optionAImage,
              optionB: state.optionBImage,
              optionC: state.optionCImage,
              optionD: state.optionDImage,
              correctOption: state.correctOption);
          yield state.copyWith(formSubmissionStatus: SubmissionSuccess(id: id));
        }else {
          String id = await feedRepo.postMCQWithText(question: state.question,
              questionImages:state.questionImages,
              optionA: state.optionA,
              optionB: state.optionB,
              optionC: state.optionC,
              optionD: state.optionD,
              correctOption: state.correctOption);
          yield state.copyWith(formSubmissionStatus: SubmissionSuccess(id: id));

        }
      } catch (e) {
        print(e);
        yield state.copyWith(formSubmissionStatus: SubmissionFailed(e));
        yield state.copyWith(formSubmissionStatus: InitialFormStatus());
      }
    }
  }
}