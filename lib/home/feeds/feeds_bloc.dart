import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/constants/strings_and_urls.dart';
import 'package:queschat/function/time_conversions.dart';
import 'package:queschat/home/feeds/feeds_event.dart';
import 'package:queschat/home/feeds/feeds_repo.dart';
import 'package:queschat/home/feeds/feeds_state.dart';
import 'package:queschat/home/feeds/feeds_status.dart';
import 'package:queschat/models/blog_nodel.dart';
import 'package:queschat/models/feed_model.dart';
import 'package:queschat/models/mcq_model.dart';
import 'package:queschat/models/quiz_model.dart';

class FeedsBloc extends Bloc<FeedEvent, FeedsState> {
  FeedRepository feedRepository;
  String parentPage;

  String feedId;

  FeedsBloc(
      {@required this.feedRepository, @required this.parentPage, this.feedId})
      : super(FeedsState(feedModelList: [], feedIds: [])) {
    state.parentPage = parentPage;
    if (parentPage == 'home' || parentPage=='myFeeds' || parentPage=='savedFeeds') {
      getInitialFeeds();
    } else if (parentPage == 'messageRoomView' || parentPage== 'dynamicLink' || parentPage=='feedAdapter') {

      print('messageRoomView feed bloc $feedId');

      getInitialSingleFeeds(feedId);
    }
  }

  getInitialSingleFeeds(String feedId) async {
    state.feedModelList.clear();
    state.feedIds.clear();
    state.page = 1;
    try {
       var element = await feedRepository.getSingleFeedDetails(feedId);
       List feeds = [element];
       // print('inital $feeds');

       convertFeeds(feeds);
    }catch(e){
      add(UpdateFeeds());
    }

  }

  getInitialFeeds() async {
    state.feedModelList.clear();
    state.feedIds.clear();
    state.page = 1;
    var feeds = await feedRepository.getFeeds(state.page, 10, parentPage);
    // print('inital $feeds');

    convertFeeds(feeds);
  }

  getMoreFeeds() async {
    state.page = state.page + 1;
    var feeds = await feedRepository.getFeeds(state.page, 10, parentPage);
    // print('norw $feeds');

    convertFeeds(feeds);
  }

  insertFeedToTop(
    String id,
  ) async {
    var element = await feedRepository.getSingleFeedDetails(id);
    var contentModel = await getContentModel(element);

    state.feedModelList.insert(
        0,
        FeedModel(
            userName: element['user'],
            userId: element['user_id'].toString(),
            id: element['id'].toString(),
            feedType: element['feed_type'],
            savedId: element['saved_feed_id'] != null
                ? element['saved_feed_id'].toString()
                : null,
            commentCount: element['comment_count'] != null
                ? element['comment_count']
                : '0',
            likeCount:
                element['like_count'] != null ? element['like_count'] : '0',
            profilePicUrl: element['profile_pic'] != null
                ? 'https://api.queschat.com/' + element['profile_pic']
                : Urls().personUrl,
            uploadedTime:
                getTimeDifferenceFromNowString(element['create_date']),
            contentModel: contentModel));

    // var tempFeedIDs=state.feedIds;
    state.feedIds.insert(0, element['id'].toString());
    emit(state);
  }

  updateSingleFeedData(
    String id,
  ) async {
    var element = await feedRepository.getSingleFeedDetails(id);
    var contentModel = await getContentModel(element);

    state.feedModelList[state.feedIds.indexOf(id)] = FeedModel(
        userName: element['user'],
        userId: element['user_id'].toString(),
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
        contentModel: contentModel);
    emit(state);
  }

  convertFeeds(var feeds) async {
    try {
      // print('conver feed');
      feeds.forEach((element) async {
        // print('fedd $element');
        if (!state.feedIds.contains(element['id'])) {
          var contentModel = await getContentModel(element);

          state.feedModelList.add(FeedModel(
              userName: element['user'],
              userId: element['user_id'].toString(),
              id: element['id'].toString(),
              feedType: element['feed_type'],
              savedId: element['saved_feed_id'] != null
                  ? element['saved_feed_id'].toString()
                  : null,
              commentCount: element['comment_count'] != null
                  ? element['comment_count'].toString()
                  : '0',
              isLiked: element['like'] != null,
              likeId: element['like'] != null
                  ? element['like']['id'].toString()
                  : null,
              likeCount: element['like_count'] != null
                  ? element['like_count'].toString()
                  : '0',
              profilePicUrl: element['profile_pic'] != null
                  ? 'https://api.queschat.com/' + element['profile_pic']
                  : Urls().personUrl,
              uploadedTime:
                  getTimeDifferenceFromNowString(element['create_date']),
              contentModel: contentModel));
          state.feedIds.add(element['id'].toString());
          // for(int i=0;i<1;i++){
          //   deleteDataRequest(address: 'feed/${state.feedIds[i]}');
          //   deleteDataRequest(address: 'feed/${state.feedIds[state.feedIds.length-1]}');
          // }
        }
      });
      emit(state);
    } catch (e) {
      print('feed error');
      print(e);
    }
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
          optionType: element['option_type'],
          selectedAnswer: selectedAnswer,
          optionC: optionC,
          media: media,
          optionD: optionD,
          correctAnswer: correctAnswer,
          optionAPercentage:optionACount==0?0.0:optionACount/allAnswersCount,
          optionBPercentage:optionBCount==0?0.0: optionBCount/allAnswersCount,
          optionCPercentage:optionCCount==0?0.0: optionCCount/allAnswersCount,
          optionDPercentage:optionDCount==0?0.0: optionDCount/allAnswersCount,
        );

        return mcqModel;
      } catch (e) {}
    } else if (element['feed_type'] == 'blog') {
      List<String> media = [];
      element['media'].forEach((value) {
        media.add('https://api.queschat.com/' + value['url']);
      });
      BlogModel blogModel = BlogModel(
          content: element['description'],
          images: media,
          heading: element['name']);
      return blogModel;
    } else if (element['feed_type'] == 'quiz') {
      List<String> media = [];
      element['media'].forEach((value) {
        media.add('https://api.queschat.com/' + value['url']);
      });
      List<String> mcqList = [];
      String mcq = element['mcq'].toString();
      if (mcq != null) {
        mcqList = mcq.split(',');
      }
      // print('mcqList$mcqList');
      QuizModel blogModel = QuizModel(
          content: element['description'],
          isQuizAttended:element['is_quiz_attended'],
          point: element['quiz_point']==null?'0':element['quiz_point'].toString(),
          duration: element['quiz_time']==null?0:element['quiz_time'],
          images: media,
          mcqIDs: mcqList,
          noOfQuestions: mcqList.length.toString(),
          heading: element['name']);
      return blogModel;
    }
  }

  @override
  Stream<FeedsState> mapEventToState(FeedEvent event) async* {
    if (event is FetchInitialData) {
      yield state.copyWith(isLoading: true);
      await getInitialFeeds();
      yield state.copyWith(isLoading: false);
    } else if (event is FetchMoreData) {
      // if (parentPage == 'home') {
        yield state.copyWith(isLoading: true);
        await getMoreFeeds();
        yield state.copyWith(isLoading: false);
      // }
    } else if (event is UserAddedNewFeed) {
      await insertFeedToTop(event.id);
      yield state.copyWith(isLoading: false, pageScrollStatus: ScrollToTop());
      yield state.copyWith(isLoading: false, pageScrollStatus: InitialStatus());
    } else if (event is LikeAndUnLikeFeed) {
      try {
        if (!state.feedModelList[event.feedIndex].isLiked) {
          await feedRepository.likeFeed(
              feedId: state.feedModelList[event.feedIndex].id);
          state.feedModelList[event.feedIndex].isLiked = true;
          state.feedModelList[event.feedIndex].likeCount =
              (int.parse(state.feedModelList[event.feedIndex].likeCount) + 1)
                  .toString();
          yield state.copyWith();
        } else {
          await feedRepository.unLikeFeed(
              connectionId: state.feedModelList[event.feedIndex].likeId);
          state.feedModelList[event.feedIndex].isLiked = false;
          state.feedModelList[event.feedIndex].likeCount =
              (int.parse(state.feedModelList[event.feedIndex].likeCount) - 1)
                  .toString();
          yield state.copyWith();
        }
      } catch (e) {
        yield state.copyWith();
      }
    } else if (event is McqAnswered) {
      try {
        await feedRepository.answerMcq(
            feedId: state.feedModelList[event.feedIndex].id,
            answer: event.answer);
        state.feedModelList[event.feedIndex].contentModel.selectedAnswer =
            event.option;
        yield state.copyWith();
      } catch (e) {}
    } else if (event is DeleteFeed) {
      try {
        await feedRepository.deleteFeed(
          feedId:event.feedId,
        );
        state.feedModelList.removeAt(state.feedIds.indexOf(event.feedId));
        state.feedIds.removeAt(state.feedIds.indexOf(event.feedId));
        yield state.copyWith();
      } catch (e) {
        yield state.copyWith(actionErrorMessage: e);
        Exception e1 = Exception(['']);
        yield state.copyWith(actionErrorMessage: e1);
      }
    }  else if (event is SaveAndUnSaveFeed) {
      try {
        if (state.feedModelList[event.feedIndex].savedId == null) {
          var savedId = await feedRepository.saveFeed(
              feedId: state.feedModelList[event.feedIndex].id);
          state.feedModelList[event.feedIndex].savedId = savedId;
          yield state.copyWith();
        } else {
          await feedRepository.deleteFromSaved(
              savedId: state.feedModelList[event.feedIndex].savedId);
          state.feedModelList[event.feedIndex].savedId = null;
          if (parentPage == 'savedFeeds') {
            state.feedModelList.removeAt(event.feedIndex);
          }
          yield state.copyWith();
        }
        yield state.copyWith();
      } catch (e) {
        yield state.copyWith(actionErrorMessage: e);
        Exception e1 = Exception(['']);
        yield state.copyWith(actionErrorMessage: e1);
      }
    } else if (event is EditedAFeed) {
      await updateSingleFeedData(event.feedId);
      yield state.copyWith();
    }
  }
}

getRandomElement<T>(List<T> list) {
  final random = new Random();
  var i = random.nextInt(list.length);
  return list[i];
}
