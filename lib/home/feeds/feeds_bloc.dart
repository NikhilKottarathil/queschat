import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/constants/strings_and_urls.dart';
import 'package:queschat/function/api_calls.dart';
import 'package:queschat/function/time_conversions.dart';
import 'package:queschat/home/feeds/feeds_event.dart';
import 'package:queschat/home/feeds/feeds_repo.dart';
import 'package:queschat/home/feeds/feeds_state.dart';
import 'package:queschat/home/feeds/feeds_status.dart';
import 'package:queschat/models/blog_nodel.dart';
import 'package:queschat/models/feed_model.dart';
import 'package:queschat/models/mcq_model.dart';

class FeedsBloc extends Bloc<FeedEvent, FeedsState> {
  FeedRepository feedRepository;


  FeedsBloc({@required this.feedRepository})
      : super(FeedsState(feedModelList: [], feedIds: [])) {
    getInitialFeeds();
  }

  getInitialFeeds() async {
    state.feedModelList.clear();
    state.feedIds.clear();
    state.page = 1;
    var feeds = await feedRepository.getFeeds(state.page, 3);
    convertFeeds(feeds);
    print('inital $feeds');
  }

  getMoreFeeds() async {
    state.page = state.page + 1;
    var feeds = await feedRepository.getFeeds(state.page, 3);
    convertFeeds(feeds);
    print('norw $feeds');
  }

  insertFeedToTop(String id) async {
    var element = await feedRepository.getSingleFeedDetails(id);
    var contentModel = await getContentModel(element);

    state.feedModelList.insert(
        0,
        FeedModel(
            userName: element['user'],
            id: element['id'].toString(),
            feedType: element['feed_type'],
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

  convertFeeds(var feeds) async {
    try {
      feeds.forEach((element) async {
        if (!state.feedIds.contains(element['id'])) {
          var contentModel = await getContentModel(element);

          state.feedModelList.add(FeedModel(
              userName: element['user'],
              id: element['id'].toString(),
              feedType: element['feed_type'],
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
      String optionA, optionB, optionC, optionD, correctAnswer;

      final List optionStrings = ['A', 'B', 'C', 'D'];
      var options = element['options'];
      var selectedAnswer;

      try {
        for (int i = 0; i <= 3; i++) {
          String randomItem = getRandomElement(optionStrings);

          if (randomItem == 'A') {
            optionA = options[i]['option'];
            if (options[i]['Is_answer'] == 1) {
              correctAnswer = 'A';
            }
            if(element['my_answer']['name']==options[i]['option']){
              selectedAnswer='A';
            }
          }
          if (randomItem == 'B') {
            optionB = options[i]['option'];
            if (options[i]['Is_answer'] == 1) {
              correctAnswer = 'B';
            }
            if(element['my_answer']['name']==options[i]['option']){
              selectedAnswer='B';
            }
          }
          if (randomItem == 'C') {
            optionC = options[i]['option'];
            if (options[i]['Is_answer'] == 1) {
              correctAnswer = 'C';
            }
            if(element['my_answer']['name']==options[i]['option']){
              selectedAnswer='C';
            }
          }
          if (randomItem == 'D') {
            optionD = options[i]['option'];
            if (options[i]['Is_answer'] == 1) {
              correctAnswer = 'D';
            }
            if(element['my_answer']['name']==options[i]['option']){
              selectedAnswer='D';
            }
          }
          optionStrings.remove(randomItem);
        }

        MCQModel mcqModel = MCQModel(
            question: element['name'],
            optionA: optionA,
            optionB: optionB,
            selectedAnswer: selectedAnswer,
            optionC: optionC,
            optionD: optionD,
            correctAnswer: correctAnswer);

        return mcqModel;
      } catch (e) {
        print('option error');
        print(e);
      }
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
    }
  }

  @override
  Stream<FeedsState> mapEventToState(FeedEvent event) async* {
    if (event is FetchInitialData) {
      yield state.copyWith(isLoading: true);
      await getInitialFeeds();
      yield state.copyWith(isLoading: false);
    } else if (event is FetchMoreData) {
      yield state.copyWith(isLoading: true);
      await getMoreFeeds();
      yield state.copyWith(isLoading: false);
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
    }
  }
}

getRandomElement<T>(List<T> list) {
  final random = new Random();
  var i = random.nextInt(list.length);
  return list[i];
}
