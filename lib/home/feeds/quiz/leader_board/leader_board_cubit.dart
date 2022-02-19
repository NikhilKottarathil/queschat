import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/home/feeds/quiz/leader_board/leader_board_model.dart';
import 'package:queschat/home/feeds/quiz/leader_board/leader_board_state.dart';
import 'package:queschat/router/app_router.dart';

class LeaderBoardCubit extends Cubit<LeaderBoardState> {
  List<LeaderBoardModel> models = [];
  List<String> ids = [];
  DatabaseReference reference = FirebaseDatabase.instance.reference();

  int initialEntryCount = 25;
  int loadMoreEntryCount = 20;
  int pageNumber = 1;
  int entryCount = 0;
  String quizId;


  LeaderBoardCubit({@required this.quizId}) : super(InitialState()) {
    getInitialData();
  }

  Future<void> getInitialData() async {
    pageNumber = 1;
    entryCount = initialEntryCount;
    models.clear();
    getData();
  }

  loadMoreData() {
    if (state is! LoadMoreState) {
      pageNumber = pageNumber + 1;
      entryCount = loadMoreEntryCount;
      getData();
    }
  }

  Future<void> getData() async {

    List<LeaderBoardModel> tempModels=await feedRepository.getLeaderBoardData(quizId: quizId);
    updateList(tempModels);
  }

  void updateList(List<LeaderBoardModel> tempModels) {
    models.addAll(tempModels);
    models.sort((e1, e2) {
      return e1.score.compareTo(e2.score);
    });
    emit(LoadList(items: models));
  }
}
