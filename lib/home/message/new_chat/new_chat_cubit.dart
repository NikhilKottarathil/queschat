import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:queschat/home/message/new_chat/new_chat_state.dart';
import 'package:queschat/models/chat_room_model.dart';
import 'package:queschat/models/user_contact_model.dart';
import 'package:queschat/repository/auth_repo.dart';


class NewChatCubit extends Cubit<NewChatState> {
  AuthRepository authRepo;


  List<String> userNames = [];
  List<UserContactModel> userContactModels = [];


  NewChatCubit({@required this.authRepo}) : super(InitialState()) {
    getUserOnQuesChat();
  }

  Future<void> getUserOnQuesChat() async {
    print('calledddddd');
    userContactModels = await authRepo.getAllRegisteredUsersIcContactList(true);
    userContactModels.forEach((element) {
      userNames.add(element.name);
    });
    emit(LoadList(items: userContactModels));
  }

  Future<void> searchPressed() async {
    emit(SearchPressed());
  }

  Future<void> searchCleared() async {
    emit(SearchCleared());
  }

  Future<void> searchUsers(String value) async {
    List<UserContactModel> tempUserContactModels = [];

    if (value == null || value.toString().trim().length == 0) {
      tempUserContactModels = userContactModels;
    } else {
      final fuse = Fuzzy(userNames);

      final result = fuse.search(value);
      print(result);

      result.forEach((r) {
        // print('\nScore: ${r.score}\nTitle: ${r.item}');
        tempUserContactModels.add(userContactModels[userNames.indexOf(r.item)]);
      });
    }

    emit(LoadList(items: tempUserContactModels));
  }
}
