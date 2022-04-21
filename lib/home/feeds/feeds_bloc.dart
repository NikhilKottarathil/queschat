import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/function/time_conversions.dart';
import 'package:queschat/home/feeds/feed_actions.dart';
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
  String userProfileId;
  FeedsBloc parentFeedBloc;
  DatabaseReference reference = FirebaseDatabase.instance.reference();

  FeedsBloc(
      {@required this.feedRepository,
      @required this.parentPage,
      this.feedId,
      this.parentFeedBloc,
      this.userProfileId})
      : super(FeedsState(feedModelList: [], feedIds: [])) {
    state.parentPage = parentPage;
    print('parent feed Bloc ${parentFeedBloc!=null}');
    if (parentPage == 'home' ||
        parentPage == 'myFeeds' ||
        parentPage == 'savedFeeds' ||
        parentPage == 'userProfileFeed') {
      getInitialFeeds();
    } else if (parentPage == 'messageRoomView' ||
        parentPage == 'dynamicLink' ||
        parentPage == 'feedAdapter' ||
        parentPage == 'notification') {
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

      convertFeeds(feeds);
    } catch (e) {
      add(UpdateFeeds());
    }
  }

  getInitialFeeds() async {
    state.feedModelList.clear();
    state.feedIds.clear();
    state.page = 1;
    var feeds = await feedRepository.getFeeds(
        page: state.page,
        rowsPerPage: 10,
        parentPage: parentPage,
        userId: userProfileId);

    convertFeeds(feeds);
  }

  getMoreFeeds() async {
    state.page = state.page + 1;
    var feeds = await feedRepository.getFeeds(
        page: state.page,
        rowsPerPage: 10,
        parentPage: parentPage,
        userId: userProfileId);

    convertFeeds(feeds);
  }

  insertFeedToTop(
    String id,
  ) async {
    var element = await feedRepository.getSingleFeedDetails(id);

    state.feedModelList.insert(0, await convertDataInToFeedModel(element));

    state.feedIds.insert(0, element['id'].toString());

    add(UpdateFeeds());
  }

  updateSingleFeedData(
    String id,
  ) async {
    var element = await feedRepository.getSingleFeedDetails(id);

    state.feedModelList[state.feedIds.indexOf(id)] =
        await convertDataInToFeedModel(element);
    add(UpdateFeeds());
  }

  convertFeeds(var feeds) async {
    await Future.forEach(feeds, (element) async {
      if (!state.feedIds.contains(element['id'])) {
        state.feedModelList.add(await convertDataInToFeedModel(element));
        state.feedIds.add(element['id'].toString());
      }
    });

    add(UpdateFeeds());
  }

  Future<FeedModel> convertDataInToFeedModel(var element) async {
    String channelName, channelImageUrl;
    var contentModel = await getContentModel(element);

    FeedModel feedModel;
    if (element['channel_id'] != null) {
      await reference
          .child('ChannelRooms')
          .child(element['channel_id'])
          .child('info')
          .once()
          .then((value) async {
        Map<dynamic, dynamic> map = value.value;
        print('channel in feed $map');
        channelName = map['name'] ?? null;

        channelImageUrl = map['icon_url'] ?? null;

        feedModel = FeedModel(
            userName: element['user'],
            userId: element['user_id'].toString(),
            id: element['id'].toString(),
            feedType: element['feed_type'],
            messageRoomId: element['channel_id'] != null
                ? element['channel_id'].toString()
                : null,
            messageRoomImageUrl: channelImageUrl,
            messageRoomName: channelName,
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
                : null,
            uploadedTime:
                getTimeDifferenceFromNowString(element['create_date']),
            contentModel: contentModel);
      });
    } else {
      feedModel = FeedModel(
          userName: element['user'],
          userId: element['user_id'].toString(),
          id: element['id'].toString(),
          feedType: element['feed_type'],
          messageRoomId: element['channel_id'] != null
              ? element['channel_id'].toString()
              : null,
          savedId: element['saved_feed_id'] != null
              ? element['saved_feed_id'].toString()
              : null,
          commentCount: element['comment_count'] != null
              ? element['comment_count'].toString()
              : '0',
          isLiked: element['like'] != null,
          likeId:
              element['like'] != null ? element['like']['id'].toString() : null,
          likeCount: element['like_count'] != null
              ? element['like_count'].toString()
              : '0',
          profilePicUrl: element['profile_pic'] != null
              ? 'https://api.queschat.com/' + element['profile_pic']
              : null,
          uploadedTime: getTimeDifferenceFromNowString(element['create_date']),
          contentModel: contentModel);
    }
    return feedModel;
  }

  Future getContentModel(var element) async {
    if (element['feed_type'] == 'poll') {
      try {
        String optionA, optionB, optionC, optionD;
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
        // correctAnswer = element['answer'];
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
          correctAnswer: 'poll',
          optionAPercentage:
              optionACount == 0 ? 0.0 : optionACount / allAnswersCount,
          optionBPercentage:
              optionBCount == 0 ? 0.0 : optionBCount / allAnswersCount,
          optionCPercentage:
              optionCCount == 0 ? 0.0 : optionCCount / allAnswersCount,
          optionDPercentage:
              optionDCount == 0 ? 0.0 : optionDCount / allAnswersCount,
        );

        return mcqModel;
      } catch (e) {}
    } else if (element['feed_type'] == 'mcq') {
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
          optionAPercentage:
              optionACount == 0 ? 0.0 : optionACount / allAnswersCount,
          optionBPercentage:
              optionBCount == 0 ? 0.0 : optionBCount / allAnswersCount,
          optionCPercentage:
              optionCCount == 0 ? 0.0 : optionCCount / allAnswersCount,
          optionDPercentage:
              optionDCount == 0 ? 0.0 : optionDCount / allAnswersCount,
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
          mediaIds: element['media_ids'] ?? null,
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
      QuizModel quizModel = QuizModel(
          content: element['description'],
          isQuizAttended: element['is_quiz_attended'],
          point: element['quiz_point'] == null
              ? '0'
              : element['quiz_point'].toString(),
          duration: element['quiz_time'] == null ? 0 : element['quiz_time'],
          images: media,
          mcqIDs: mcqList,
          noOfQuestions: mcqList.length.toString(),
          heading: element['name']);
      return quizModel;
    }
  }

  @override
  Stream<FeedsState> mapEventToState(FeedEvent event) async* {


    if (event is UpdateFeeds) {
      yield state.copyWith(isLoadMore: false, isLoading: false);
    } else if (event is FetchInitialData) {
      yield state.copyWith(isLoadMore: true);
      await getInitialFeeds();
      yield state.copyWith(isLoadMore: false);
    } else if (event is FetchMoreData) {
      // if (parentPage == 'home') {
      yield state.copyWith(isLoadMore: true);
      await getMoreFeeds();
      yield state.copyWith(isLoadMore: false);
      // }
    } else if (event is UserAddedNewFeed) {
      await insertFeedToTop(event.id);
      yield state.copyWith(isLoadMore: false, pageScrollStatus: ScrollToTop());
      yield state.copyWith(
          isLoadMore: false, pageScrollStatus: InitialStatus());
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
        updateFeedInAll(state.feedModelList[event.feedIndex].id);
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
        state.feedModelList.removeAt(state.feedIds.indexOf(event.feedId));
        state.feedIds.removeAt(state.feedIds.indexOf(event.feedId));
        yield state.copyWith();
      } catch (e) {
        yield state.copyWith(actionErrorMessage: e);
        Exception e1 = Exception(['']);
        yield state.copyWith(actionErrorMessage: e1);
      }
    } else if (event is SaveAndUnSaveFeed) {
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

    if (parentFeedBloc != null) {
      parentFeedBloc.add(EditedAFeed(feedId: feedId));
    }
  }
}

getRandomElement<T>(List<T> list) {
  final random = new Random();
  var i = random.nextInt(list.length);
  return list[i];
}
