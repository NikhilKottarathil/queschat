import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/home/feeds/feeds_repo.dart';
import 'package:queschat/home/feeds/post_a_mcq/post_mcq_event.dart';
import 'package:queschat/home/feeds/post_a_mcq/post_mcq_state.dart';


class PostMcqBloc extends Bloc< PostMcqEvent, PostMcqState> {
  final FeedRepository feedRepo;

  PostMcqBloc({this.feedRepo}) : super(PostMcqState());

  @override
  Stream<PostMcqState> mapEventToState(PostMcqEvent event) async* {
    if (event is QuestionChanged) {
      yield state.copyWith(question: event.question);

    }else if (event is OptionAChanged) {
      yield state.copyWith(optionA: event.optionA);

    } else if (event is OptionBChanged) {
      yield state.copyWith(optionB: event.optionB);
    }
    else if (event is OptionCChanged) {
      yield state.copyWith(optionC:event.optionC);

    }else if (event is OptionDChanged) {
      yield state.copyWith(optionD:event.optionD);
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
       String id= await feedRepo.postMCQ( question:state.question,optionA:state.optionA,optionB: state.optionB, optionC: state.optionC,optionD: state.optionD,correctOption: state.correctOption );
        yield state.copyWith(formSubmissionStatus: SubmissionSuccess(id: id));
      } catch (e) {
        print(e);
        yield state.copyWith(formSubmissionStatus: SubmissionFailed(e));
        yield state.copyWith(formSubmissionStatus: InitialFormStatus());
      }
    }
  }
}