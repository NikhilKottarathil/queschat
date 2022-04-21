import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/components/popups/show_loader.dart';
import 'package:queschat/function/time_conversions.dart';
import 'package:queschat/home/feeds/feeds_repo.dart';
import 'package:queschat/home/feeds/quiz/quiz_play/quiz_play_event.dart';
import 'package:queschat/home/feeds/quiz/quiz_play/quiz_play_state.dart';
import 'package:queschat/main.dart';
import 'package:queschat/models/feed_model.dart';
import 'package:queschat/models/mcq_model.dart';

class QuizPlayBloc extends Bloc<QuizPlayEvent, QuizPlayState> {
  List<String> mcqIDs;
  String quizId;
  FeedRepository feedRepository;
  Timer _timer;

  int totalDuration;
  String point;

  QuizPlayBloc({@required this.mcqIDs, @required this.feedRepository,@required this.quizId, @required this.totalDuration,@required this.point})
      : super(QuizPlayState(
          mcqIds: mcqIDs,
          totalMCQ: mcqIDs.length,
          feedModels: [],
          currentIndex: 0,
          attendedMCQ: 0,
          correctMCQ: 0,
    duration: Duration(minutes: 1).inMilliseconds,
        )) {
    state.duration=totalDuration;
    getMCQs();


  }

  getMCQs() {
    mcqIDs.forEach((element) {
      insertFeedToTop(element);
    });

    startTimer();
  }
  startTimer() {
    const oneSec = const Duration(milliseconds: 1000);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (state.duration <= 1000) {
          add(TimerChanged(duration: 0));
          add(Finished());
        } else {
          // state.pendingTimeInMills = state.pendingTimeInMills - 1000;
          add(TimerChanged(
              duration: state.duration - 1000));
        }
      },
    );
  }


  insertFeedToTop(
    String id,
  ) async {
    var element = await feedRepository.getSingleFeedDetails(id);
    var contentModel = await getContentModel(element);

    state.feedModels.add(FeedModel(
        userName: element['user'],
        // userId: element['user_id'],
        id: element['id'].toString(),
        feedType: element['feed_type'],
        savedId: element['saved_feed_id'] != null
            ? element['saved_feed_id'].toString()
            : null,
        commentCount:
            element['comment_count'] != null ? element['comment_count'] : '0',
        likeCount: element['like_count'] != null ? element['like_count'] : '0',
        profilePicUrl: element['profile_pic'] != null
            ? 'https://api.queschat.com/' + element['profile_pic']
            : null,
        uploadedTime: getTimeDifferenceFromNowString(element['create_date']),
        contentModel: contentModel));

    // var tempFeedIDs=state.feedIds;
    emit(state);
  }

  Future getContentModel(var element) async {
    if (element['feed_type'] == 'mcq') {
      try {
        String optionA, optionB, optionC, optionD, correctAnswer;
        int optionACount = 0,
            optionBCount = 0,
            optionCCount = 0,
            optionDCount = 0,
            allAnswersCount = 0;
        var selectedAnswer;
        var myAnswer = element['my_answer'] != null
            ? element['my_answer']['name'] != null
                ? element['my_answer']['name']
                : null
            : null;
        correctAnswer = element['answer'];

        if(myAnswer!=null){
          state.attendedMCQ=state.attendedMCQ+1;
          if(myAnswer==correctAnswer){
            state.correctMCQ=state.correctMCQ+1;

          }
        }
        optionA = element['option_a'];
        optionB = element['option_b'];
        optionC = element['option_c'];
        optionD = element['option_d'];
        if (myAnswer == optionA) {
          selectedAnswer = 'A';
        }
        if (myAnswer == optionB) {
          selectedAnswer = 'B';
        }
        if (myAnswer == optionC) {
          selectedAnswer = 'C';
        }
        if (myAnswer == optionD) {
          selectedAnswer = 'D';
        }
        List<String> media = [];
        element['media'].forEach((value) {
          media.add('https://api.queschat.com/' + value['url']);
        });
        if (element['all_answers'] != null) {
          element['all_answers'].forEach((entry) {
            if (entry['name'] == optionA) {
              optionACount = entry['count'];
            }
            if (entry['name'] == optionB) {
              optionBCount = entry['count'];
            }
            if (entry['name'] == optionC) {
              optionCCount = entry['count'];
            }
            if (entry['name'] == optionD) {
              optionDCount = entry['count'];
            }
          });
        }
        allAnswersCount =
            optionACount + optionBCount + optionCCount + optionDCount;

        MCQModel mcqModel = MCQModel(
            question: element['name'],
            optionA: optionA,
            optionB: optionB,
            media: media,
            optionType: element['option_type'],
            selectedAnswer: selectedAnswer,
            optionC: optionC,
            optionD: optionD,
            correctAnswer: correctAnswer,
          optionAPercentage:optionACount==0?0.0:optionACount/allAnswersCount,
          optionBPercentage:optionBCount==0?0.0: optionBCount/allAnswersCount,
          optionCPercentage:optionCCount==0?0.0: optionCCount/allAnswersCount,
          optionDPercentage:optionDCount==0?0.0: optionDCount/allAnswersCount,
        );

        return mcqModel;
      } catch (e) {}
    }
  }

  @override
  Stream<QuizPlayState> mapEventToState(QuizPlayEvent event) async* {
    if (event is McqAnswered) {

      showLoader(MyApp.navigatorKey.currentContext, .5);
      try {

      String answerStatus='wrong';
        if (state.feedModels[event.feedIndex].contentModel.correctAnswer ==
            event.option) {
          state.correctMCQ=state.correctMCQ+1;
          answerStatus='correct';
        }
        state.attendedMCQ=state.attendedMCQ+1;
        await feedRepository.answerMcq(
            feedId: state.feedModels[event.feedIndex].id, answer: event.answer);
        await feedRepository.answerQuizMcq( point: point,answer: event.answer,answerStatus: answerStatus,completionTime: totalDuration-state.duration,mcqId: state.feedModels[event.feedIndex].id,quizId: quizId);
        state.feedModels[event.feedIndex].contentModel.selectedAnswer = event.option;


        yield state.copyWith();
      } catch (e) {}
     Navigator.pop( MyApp.navigatorKey.currentContext);
    }else if(event is ShowNextMCQ){
      state.currentIndex=state.currentIndex+1;
      yield state.copyWith( );
    }else if(event is ShowPreviousMCQ){
      state.currentIndex=state.currentIndex-1;
      yield state.copyWith();
    }else if(event is TimerChanged){
      yield state.copyWith(duration: event.duration);
    }else if(event is Finished){
      _timer.cancel();
      yield state.copyWith(formSubmissionStatus: SubmissionSuccess());
      yield state.copyWith(formSubmissionStatus: InitialFormStatus());
    }
  }
}
