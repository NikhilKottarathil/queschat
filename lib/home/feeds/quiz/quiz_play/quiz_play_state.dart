import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/models/feed_model.dart';

class QuizPlayState {
  int currentIndex;
  List<FeedModel> feedModels;
  List<String> mcqIds;
  int totalMCQ, attendedMCQ, correctMCQ;
  bool isLoading;
int duration;
  FormSubmissionStatus formSubmissionStatus;


  QuizPlayState({
    this.currentIndex,this.duration=60000 ,this.attendedMCQ, this.correctMCQ, this.mcqIds, this.feedModels, this.totalMCQ,this.isLoading,this.formSubmissionStatus});

  QuizPlayState copyWith({
    int currentIndex,
    List<FeedModel> feedModels,
    List<String> mcqIds,
    int totalMCQ, attendedMCQ, correctMCQ,
    bool isLoading =false,
    FormSubmissionStatus formSubmissionStatus,
    int duration,
  }) {
    return QuizPlayState(
      currentIndex: currentIndex ?? this.currentIndex,
      attendedMCQ: attendedMCQ ?? this.attendedMCQ,
      correctMCQ: correctMCQ ?? this.correctMCQ,
      mcqIds: mcqIds ?? this.mcqIds,
      feedModels: feedModels ?? this.feedModels,
      totalMCQ: totalMCQ ?? this.totalMCQ,
      isLoading: isLoading ?? this.isLoading,
      duration: duration ?? this.duration,
      formSubmissionStatus: formSubmissionStatus ?? this.formSubmissionStatus,
    );
  }


}
