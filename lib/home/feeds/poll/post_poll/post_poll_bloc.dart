import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/function/select_image.dart';
import 'package:queschat/home/feeds/feeds_repo.dart';
import 'package:queschat/home/feeds/poll/post_poll/post_poll_event.dart';
import 'package:queschat/home/feeds/poll/post_poll/post_poll_state.dart';
import 'package:queschat/home/message/message_room/message_room_cubit.dart';
import 'package:queschat/models/message_model.dart';


class PostPollBloc extends Bloc< PostPollEvent, PostPollState> {
  final FeedRepository feedRepo;
  MessageRoomCubit messageRoomCubit;
  String parentPage;

  PostPollBloc({this.feedRepo,this.messageRoomCubit,this.parentPage}) : super(PostPollState(questionImages: []));

  @override
  Stream<PostPollState> mapEventToState(PostPollEvent event) async* {
    if (event is NumberOfOptionChanged) {
     
      yield state.copyWith(numberOfOption: state.numberOfOption+1);

    }
    else if (event is QuestionChanged) {
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

    else if (event is ClearAllFields) {
      yield state.copyWith(numberOfOption:2,optionD: '',optionC: '',optionB: '',optionA: '',question: '',formSubmissionStatus: InitialFormStatus());
    }
    else if (event is PostPollSubmitted) {
      yield state.copyWith(formSubmissionStatus: FormSubmitting());

      try {
        if(state.isImageOptions){

        }else {
          String id = await feedRepo.postPollWithText(question: state.question,
              questionImages:state.questionImages,
              optionA: state.optionA,
              optionB: state.optionB,
              optionC: state.optionC,
              optionD: state.optionD,);
          if(messageRoomCubit!=null){
            messageRoomCubit.sendMessage(messageType: MessageType.feed,feedId: id);
          }
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