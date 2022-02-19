import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:queschat/authentication/app_data.dart';
import 'package:queschat/constants/strings_and_urls.dart';
import 'package:queschat/function/api_calls.dart';
import 'package:queschat/function/select_image.dart';
import 'package:queschat/home/message/new_group_and_channel/new_group_state.dart';
import 'package:queschat/models/user_contact_model.dart';
import 'package:queschat/repository/auth_repo.dart';

class NewGroupCubit extends Cubit<NewGroupState> {
  String isGroupOrChannel;
  AuthRepository authRepo;
  static List<UserContactModel> userContactModels = [];
  DatabaseReference reference = FirebaseDatabase.instance.reference();

  List<String> userNames = [];
  String groupName = '';
  File groupIcon;
  String searchString = '';
  String description='';

  NewGroupCubit({@required this.authRepo, @required this.isGroupOrChannel})
      : super(InitialState()) {
    getUserOnQuesChat();
  }

  Future<void> getUserOnQuesChat() async {
    userContactModels =
        await authRepo.getAllRegisteredUsersIcContactList(false);
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

  Future<void> groupNameChanged(String value) async {
    groupName = value;
    print('group name changed $value');
    emit(GroupNameChanged(groupName: value));
  }

  Future<void> descriptionChanged(String value) async {
    description = value;
    print('group name changed $value');
  }

  Future<void> uploadGroupImage() async {
    if (groupIcon != null) {
      try {
        Map<String, String> requestBody = {};
        var body = await postImageDataRequest(
            imageAddress: 'images',
            address: 'media',
            imageFile: groupIcon,
            myBody: requestBody);
        if (body['url'] != null) {
          createGroup(
              groupIconId: body['id'].toString(),
              groupIconUrl: body['url'].toString());
        } else {
          throw Exception('Image Uploading  Failed');
        }
      } catch (e) {
        emit(ErrorMessage(e: e));
      }
    } else {
      createGroup();
    }
  }

  Future<void> createGroup({String groupIconUrl, groupIconId}) async {
    try {
      Map<String, dynamic> memberMap = {};
      Map<String, dynamic> unSeenMessageCountMap = {};
      List<String> memberIds = [];
      memberMap.addAll({AppData().userId: {'user_type':'owner','joining_date':DateTime.now().millisecondsSinceEpoch,'status':'active'}});
      unSeenMessageCountMap.addAll({AppData().userId: 0});
      memberIds.add(AppData().userId);
      userContactModels.forEach((element) {
        if (element.isSelected) {
          if(element.id!=AppData().userId) {
            unSeenMessageCountMap.addAll({element.id: 0});
            memberMap.addAll(
                {element.id: {'user_type': 'user', 'joining_date': DateTime
                    .now()
                    .millisecondsSinceEpoch, 'status': 'active'}});
            memberIds.add(element.id);
          }
        }
      });

      Map<String, dynamic> infoMap = {
        'created_time': DateTime.now().millisecondsSinceEpoch,
        'is_single_chat': 'False',
        'created_by':AppData().userId,
        'message_room_type':isGroupOrChannel,
        'status':'active',
        'name': groupName,
      };

      if (description != null) {
        infoMap.addAll({
          'description': description,
        });
      }
      if (groupIconUrl != null) {
        infoMap.addAll({
          'icon_url': groupIconUrl,
          'icon_id': groupIconId,
        });
      }
      Map<String, dynamic> chatRoomMap = {
        'info':infoMap,
        'un_seen_message_count': unSeenMessageCountMap,
        'members': memberMap,
      };


      String chatRoomId = reference.push().key;
      reference
          .child(isGroupOrChannel == 'group' ? 'ChatRooms' : 'ChannelRooms')
          .child(chatRoomId)
          .set(chatRoomMap);
      memberIds.forEach((element) {
        reference
            .child('Users')
            .child(element)
            .child(isGroupOrChannel == 'group' ? 'ChatRooms' : 'ChannelRooms')
            .child(chatRoomId)
            .set(chatRoomId);
      });

      emit(CreationSuccessful(
          id: chatRoomId,
          description: description,
          groupIconUrl:
              groupIconUrl != null ? Urls().serverAddress + groupIconUrl : null,
          memberIds: memberIds));
    } catch (e) {
      emit(ErrorMessage(e: e));
    }
  }

  Future<void> selectGroupIcon(BuildContext context) async {
    // groupName=value;
    try {
      groupIcon = await selectImage(imageFile: groupIcon, context: context);
      emit(GroupIconChanged(groupIcon: groupIcon));
    } catch (e) {
      emit(ErrorMessage(e: e));
      print(e);
    }
  }
}
