import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/constants/strings_and_urls.dart';
import 'package:queschat/function/time_conversions.dart';
import 'package:queschat/home/feeds/comment/comment_event.dart';
import 'package:queschat/home/feeds/comment/comment_model.dart';
import 'package:queschat/home/feeds/comment/connection_repo.dart';
import 'package:queschat/home/feeds/feeds_status.dart';

import 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  ConnectionRepository connectionRepository;
  String feedId;

  CommentBloc({this.connectionRepository, this.feedId})
      : super(CommentState(commentModelList: [], commentIds: [])) {
    getInitialData();
  }

  getInitialData() async {
    state.commentModelList.clear();
    state.commentIds.clear();
    state.page = 1;
    var comments =
        await connectionRepository.getComments(state.page, 10, feedId);

    convertDataToModel(comments);
  }

  getMoreData() async {
    state.page = state.page + 1;
    var comments =
        await connectionRepository.getComments(state.page, 3, feedId);
    convertDataToModel(comments);
  }

  insertItemToListTop(String id) async {
    var element = await connectionRepository.getSingleCommentDetails(id);

    state.commentModelList.insert(
        0,
        CommentModel(
          userName: element['user'],
          userId: element['user_id'].toString(),
          comment: element['name'],
          id: element['id'].toString(),
          replayCount: element['replies_count'].toString(),
          isShowReplay: false,
          replays: [],
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
        ));

    state.commentIds.insert(0, element['id'].toString());
    emit(state);
  }

  insertReplay(String replayId, int commentIndex) async {
    var element = await connectionRepository.getSingleCommentDetails(replayId);

    state.commentModelList[commentIndex].replayCount = (int.parse(state.commentModelList[commentIndex].replayCount) + 1).toString();
    state.commentModelList[commentIndex].isShowReplay=true;
    state.commentModelList[commentIndex].replays.add(CommentModel(
      userName: element['user'],
      userId: element['user_id'].toString(),

      comment: element['name'],
      id: element['id'].toString(),
      isShowReplay: false,
      isLiked: element['like'] != null,
      likeId: element['like'] != null ? element['like']['id'].toString() : null,
      likeCount: element['like_count'] != null
          ? element['like_count'].toString()
          : '0',
      profilePicUrl: element['profile_pic'] != null
          ? 'https://api.queschat.com/' + element['profile_pic']
          : null,
      uploadedTime: getTimeDifferenceFromNowString(element['create_date']),
    ));

    emit(state);
  }

  convertDataToModel(var comments) async {
    try {
      comments.forEach((element) async {
        if (!state.commentIds.contains(element['id'])) {
          List<CommentModel> replays = [];
          element['replies'].forEach((item) {
            replays.add(CommentModel(
              userName: item['user'],
              userId: item['user_id'].toString(),
              isShowReplay: false,
              comment: item['name'],
              id: item['id'].toString(),
              isLiked: item['like'] != null,
              likeId:
                  item['like'] != null ? item['like']['id'].toString() : null,
              likeCount: item['like_count'] != null
                  ? item['like_count'].toString()
                  : '0',
              profilePicUrl: item['profile_pic'] != null
                  ? 'https://api.queschat.com/' + item['profile_pic']
                  : null,
              uploadedTime: getTimeDifferenceFromNowString(item['create_date']),
            ));
          });
          state.commentModelList.add(CommentModel(
            userName: element['user'],
            comment: element['name'],
            id: element['id'].toString(),
            isShowReplay: false,
            replayCount: element['replies_count'].toString(),
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
            replays: replays,
            userId: element['user_id'].toString(),
            uploadedTime:
                getTimeDifferenceFromNowString(element['create_date']),
          ));
          state.commentIds.add(element['id'].toString());
        }
      });
      emit(state);
    } catch (e) {
      print('feed error');
      print(e);
    }
  }

  @override
  Stream<CommentState> mapEventToState(CommentEvent event) async* {
    if (event is FetchInitialData) {
      yield state.copyWith(isLoading: true);
      await getInitialData();
      yield state.copyWith(isLoading: false);
    } else if (event is FetchMoreData) {
      yield state.copyWith(isLoading: true);
      await getMoreData();
      yield state.copyWith(isLoading: false);
    } else if (event is AddNewComment) {
      if (state.indexOfSelectedComment == null) {
        // comment
        var id = await connectionRepository.AddNewComment(
            comment: state.comment, feedID: feedId);
        await insertItemToListTop(id);
        yield state.copyWith(
            isLoading: false, pageScrollStatus: ScrollToTop(), comment: '');
        yield state.copyWith(
            isLoading: false, pageScrollStatus: InitialStatus());
      } else {
        // Replay
        var id = await connectionRepository.AddNewReplay(
            replay: state.comment,
            feedID: feedId,
            commentId: state.commentModelList[state.indexOfSelectedComment].id);
        await insertReplay(id, state.indexOfSelectedComment);
        yield state.copyWith(
            isLoading: false, pageScrollStatus: InitialStatus(),comment: '');
      }
    } else if (event is CommentChanged) {
      yield state.copyWith(comment: event.comment);
    } else if (event is CommentSelectedForReplay) {
      print(event.index);
      yield state.copyWith(
          indexOfSelectedComment: event.index != null ? event.index : -1,
          comment: '');
    } else if (event is ConfirmDelete) {
      print('confirm delete');
      //delete comment
      print(state.indexOfSelectedCommentForDelete);
      print(state.indexOfSelectedCReplayForDelete);
      if (state.indexOfSelectedCReplayForDelete == null || state.indexOfSelectedCReplayForDelete == -1) {
        await connectionRepository.deleteCommentAndReplay(
            state.commentModelList[state.indexOfSelectedCommentForDelete].id);
        state.commentModelList.removeAt(state.indexOfSelectedCommentForDelete);
        yield state.copyWith(isShowDeleteAndReportAlert: false,indexOfSelectedCommentForDelete: -1,indexOfSelectedCReplayForDelete: -1);
      } else {
        print(state.commentModelList[0].replays[0].id);
        await connectionRepository.deleteCommentAndReplay(state
            .commentModelList[state.indexOfSelectedCommentForDelete]
            .replays[state.indexOfSelectedCReplayForDelete]
            .id);
        state.commentModelList[state.indexOfSelectedCommentForDelete].replays
            .removeAt(state.indexOfSelectedCReplayForDelete);
        yield state.copyWith(isShowDeleteAndReportAlert: false,indexOfSelectedCommentForDelete: -1,indexOfSelectedCReplayForDelete: -1);
      }
    } else if (event is ShowAndHideReplays) {
      await showAndHideReplays(event.index);
      yield state.copyWith();
    } else if (event is ShowDeleteAndReport) {
      yield state.copyWith(
          isShowDeleteAndReportAlert: true,
          indexOfSelectedComment: -1,
          indexOfSelectedCommentForDelete:
              event.commentIndex != null ? event.commentIndex : -1,
          indexOfSelectedCReplayForDelete:
              event.replayIndex != null ? event.replayIndex : -1);
    } else if (event is LikeAndUnLikeComment) {
      try {
        if (!state.commentModelList[event.index].isLiked) {
          await connectionRepository.likeComment(
              commentID: state.commentModelList[event.index].id);
          state.commentModelList[event.index].isLiked = true;
          state.commentModelList[event.index].likeCount =
              (int.parse(state.commentModelList[event.index].likeCount) + 1)
                  .toString();
          yield state.copyWith();
        } else {
          await connectionRepository.unLikeComment(
              commentId: state.commentModelList[event.index].likeId);
          state.commentModelList[event.index].isLiked = false;
          state.commentModelList[event.index].likeCount =
              (int.parse(state.commentModelList[event.index].likeCount) - 1)
                  .toString();
          yield state.copyWith();
        }
      } catch (e) {
        yield state.copyWith();
      }
    }
  }

  showAndHideReplays(int index) {
    state.commentModelList[index].isShowReplay =
        !state.commentModelList[index].isShowReplay;
  }
}

getRandomElement<T>(List<T> list) {
  final random = new Random();
  var i = random.nextInt(list.length);
  return list[i];
}

// else if (event is LikeAndUnLikeComment) {
// try {
// if (!state.commentModelList[event.index].isLiked) {
// await connectionRepository.likeComment(
// commentID: state.commentModelList[event.index].id);
// state.commentModelList[event.index].isLiked = true;
// state.commentModelList[event.index].likeCount =
// (int.parse(state.commentModelList[event.index].likeCount) + 1)
//     .toString();
// yield state.copyWith();
// } else {
// await connectionRepository.unLikeComment(
// commentId: state.commentModelList[event.index].likeId);
// state.commentModelList[event.index].isLiked = false;
// state.commentModelList[event.index].likeCount =
// (int.parse(state.commentModelList[event.index].likeCount) - 1)
//     .toString();
// yield state.copyWith();
// }
// } catch (e) {
// yield state.copyWith();
// }
// }
