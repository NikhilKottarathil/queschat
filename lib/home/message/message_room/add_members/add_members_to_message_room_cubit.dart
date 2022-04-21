import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:queschat/home/message/message_room/add_members/add_members_to_message_room_state.dart';
import 'package:queschat/models/user_contact_model.dart';
import 'package:queschat/router/app_router.dart';

class AddMembersToMessageRoomCubit extends Cubit<AddMembersToMessageRoomState> {
  String isGroupOrChannel;
  static List<UserContactModel> userContactModels = [];
   List<UserContactModel> existingUsers = [];
  DatabaseReference reference = FirebaseDatabase.instance.reference();

  List<String> userNames = [];

  String searchString = '', messageRoomId;

  AddMembersToMessageRoomCubit(
      {@required this.isGroupOrChannel, @required this.messageRoomId,@required this.existingUsers})
      : super(InitialState()) {
    getUserOnQuesChat();
  }

  Future<void> getUserOnQuesChat() async {
    userContactModels =
        await authRepository.getAllRegisteredUsersIcContactList(false);
    userContactModels.removeWhere((element) => existingUsers.map((e) => e.id).toList().contains(element.id));
    userContactModels.forEach((element) {
      userNames.add(element.name);
    });
    emit(LoadList().copyWith(items: userContactModels));
  }

  Future<void> searchUsers(String value) async {
    searchString = value;
    List<UserContactModel> tempUserContactModels = [];

    tempUserContactModels.clear();
    if (value == null || value.toString().trim().length == 0) {
      // tempUserContactModels=userContactModels;

      tempUserContactModels.addAll(userContactModels);
    } else {
      final fuse = Fuzzy(userNames);

      final result = fuse.search(value);
      // print(result);

      result.forEach((r) {
        // print('\nScore: ${r.score}\nTitle: ${r.item}');
        tempUserContactModels.add(userContactModels[userNames.indexOf(r.item)]);
      });
    }

    emit(LoadList().copyWith(items: tempUserContactModels));
  }

  Future<void> userSelected({String id}) async {
    userContactModels.forEach((element) {
      print('user 00');

      if (element.id.toString() == id.toString()) {
        print('user 01');

        if (element.isSelected) {
          element.isSelected = false;
          print('user 02');
        } else {
          print('user 03');

          element.isSelected = true;
        }
      }
    });

    searchUsers(searchString);
  }

  Future<void> addMembers() async {
    emit(LoadingState());
    try {
      Map<String, dynamic> memberMap = {};
      userContactModels.forEach((element) {
        if (element.isSelected) {
          memberMap.addAll({
            element.id: {
              'user_type': 'user',
              'joining_date': ServerValue.timestamp,
              'status': 'active'
            }
          });
        }
      });

      reference
          .child(isGroupOrChannel == 'group' ? 'ChatRooms' : 'ChannelRooms')
          .child(messageRoomId)
          .child('members')
          .update(memberMap);
      for (var mapEntry in memberMap.entries) {
        reference
            .child('Users')
            .child(mapEntry.key)
            .child(isGroupOrChannel == 'group' ? 'ChatRooms' : 'ChannelRooms')
            .child(messageRoomId)
            .set(messageRoomId);
      }

      emit(CreationSuccessful());
    } catch (e) {
      emit(ErrorMessage(e: e));
    }
  }
}
