import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/constants/strings_and_urls.dart';
import 'package:queschat/function/time_conversions.dart';
import 'package:queschat/home/feeds/feeds_repo.dart';
import 'package:queschat/home/feeds/quiz/quiz_play/quiz_play_event.dart';
import 'package:queschat/home/feeds/quiz/quiz_play/quiz_play_state.dart';
import 'package:queschat/models/feed_model.dart';
import 'package:queschat/models/mcq_model.dart';

class QuizPlayBloc extends Bloc<QuizPlayEvent, QuizPlayState> {
  List<String> mcqIDs;
  FeedRepository feedRepository;

  QuizPlayBloc({@required this.mcqIDs, @required this.feedRepository})
      : super(QuizPlayState(
          mcqIds: mcqIDs,
          totalMCQ: mcqIDs.length,
          feedModels: [],
          currentIndex: 0,
          attendedMCQ: 0,
          correctMCQ: 0,
        )) {
    getMCQs();
  }

  getMCQs() {
    mcqIDs.forEach((element) {
      insertFeedToTop(element);
    });
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
            : Urls().personUrl,
        uploadedTime: getTimeDifferenceFromNowString(element['create_date']),
        contentModel: contentModel));

    // var tempFeedIDs=state.feedIds;
    emit(state);
  }

  Future getContentModel(var element) async {
    if (element['feed_type'] == 'mcq') {
      try {
        String optionA, optionB, optionC, optionD, correctAnswer;
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
        MCQModel mcqModel = MCQModel(
            question: element['name'],
            optionA: optionA,
            optionB: optionB,
            media: media,
            optionType: element['option_type'],
            selectedAnswer: selectedAnswer,
            optionC: optionC,
            optionD: optionD,
            correctAnswer: correctAnswer);

        return mcqModel;
      } catch (e) {}
    }
  }

  @override
  Stream<QuizPlayState> mapEventToState(QuizPlayEvent event) async* {
    if (event is McqAnswered) {
      try {
        await feedRepository.answerMcq(
            feedId: state.feedModels[event.feedIndex].id, answer: event.answer);
        state.feedModels[event.feedIndex].contentModel.selectedAnswer = event.option;
        if (state.feedModels[event.feedIndex].contentModel.correctAnswer ==
            event.option) {
          state.correctMCQ=state.correctMCQ+1;
        }
        state.attendedMCQ=state.attendedMCQ+1;

        yield state.copyWith();
      } catch (e) {}
    }else if(event is ShowNextMCQ){
      state.currentIndex=state.currentIndex+1;
      yield state.copyWith( );
    }else if(event is ShowPreviousMCQ){
      state.currentIndex=state.currentIndex-1;
      yield state.copyWith();
    }
  }
}
