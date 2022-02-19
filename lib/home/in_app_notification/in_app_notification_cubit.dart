import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/app_data.dart';
import 'package:queschat/home/in_app_notification/in_app_notification_model.dart';
import 'package:queschat/home/in_app_notification/in_app_notification_state.dart';
import 'package:queschat/models/user_contact_model.dart';

import 'package:queschat/repository/auth_repo.dart';
import 'package:queschat/router/app_router.dart';

class InAppNotificationCubit extends Cubit<InAppNotificationState> {
  List<InAppNotificationModel> models = [];
  List<String> ids = [];
  DatabaseReference reference = FirebaseDatabase.instance.reference();

  InAppNotificationModel prevNotificationModel;
  int initialCountLimit = 25;
  int newlyLoadedDataCount = 0;
  int loadMoreLimit = 20;

  int newNotificationCount = 0;

  InAppNotificationCubit() : super(InitialState()) {
    getInitialData();
    // setData();
    getNotificationCount();
  }

  Future<void> getNotificationCount() async {
    reference
        .child('Notification')
        .child(AppData().userId)
        .child('count')
        .onValue
        .listen((event) {
      print('NewNotificationCount ${event.snapshot.value}');
      if (event.snapshot != null && event.snapshot.value != null) {
        newNotificationCount = event.snapshot.value;
      }
      emit(NewNotificationCount(newNotificationCount));
    });
  }

  Future<void> getLiveNotifications() async {
    reference
        .child('Notification')
        .child(AppData().userId)
        .child('Data')
        .onChildAdded
        .listen((event) async {
      Map<dynamic, dynamic> map = event.snapshot.value;
      print('getLiveData $map');
      await convertDataIntoModel(map);
      print('getLiveData 2');
      updateList();
    });
  }

  Future<void> getInitialData() async {
    reference
        .child('Notification')
        .child(AppData().userId)
        .child('Data')
        .orderByChild('created_time')
        .limitToLast(initialCountLimit)
        .once()
        .then((value) async {
      Map<dynamic, dynamic> map = value.value;
      await convertDataIntoModel(map);
      updateList();

      print('getInitialData  ${models.length}');

      if (newlyLoadedDataCount < initialCountLimit - 1) {
        getMoreDate();
        print('getInitialData load more');
      }
    });
  }

  loadMoreData() {
    if (state is! LoadMoreState) {
      newlyLoadedDataCount = 0;
      emit(LoadMoreState());

      getMoreDate();
    }
  }

  Future<void> getMoreDate() async {
    reference
        .child('Notification')
        .child(AppData().userId)
        .child('Data')
        .orderByChild('created_time')
        .endAt(models.last.createdTime.millisecondsSinceEpoch)
        .limitToLast(loadMoreLimit)
        .once()
        .then((value) async {
      Map<dynamic, dynamic> map = value.value;

      if (value.value != null) {
        print('getLoadMoreData map length is  ${map.entries.length }');

        if (map.entries.length != 1) {
          print('getLoadMoreData $map');

          await convertDataIntoModel(map);
          print('getLoadMoreData 1 ${models.length}');
          updateList();

          if (newlyLoadedDataCount < loadMoreLimit - 1) {
            getMoreDate();
          }

        }else{

          print('getLoadMoreData map length is  1 ');
          updateList();


        }
      } else {
        print('getLoadMoreData map null');

        updateList();
      }
    });
  }

  void updateList() {
    models.sort((e1, e2) {
      return e2.createdTime.compareTo(e1.createdTime);
    });
    emit(LoadList(items: models));
  }

  Future<void> convertDataIntoModel(Map map) async {
    for (var mapEntry in map.entries) {
      if (!ids.contains(mapEntry.key)) {
      UserContactModel userContactModel = await authRepository
          .getDetailsOfSelectedUser(mapEntry.value['sender_id'], 'any');

      print('prevous $prevNotificationModel');

      if (prevNotificationModel != null) {
        print('prevous ${prevNotificationModel.associateId} == ${mapEntry.value['associated_id']}');
        if (prevNotificationModel.associateId ==
            mapEntry.value['associated_id']) {
          print('inside prev');
          models.last.userNames.add(userContactModel.name);
          models.last.userProfilePics.add(userContactModel.profilePic);
          models.last.userIds.add(userContactModel.id);
          DateTime newCreatedTime=DateTime.fromMillisecondsSinceEpoch(mapEntry.value['created_time']);
          if(newCreatedTime.compareTo(models.last.createdTime).isNegative){
            models.last.createdTime=newCreatedTime;
            models.last.id=mapEntry.key;
          }
        }
      }
      else
      {
        InAppNotificationModel model = InAppNotificationModel(
          id: mapEntry.key,
          content: mapEntry.value['content'],
          associateId: mapEntry.value['associated_id'],
          associateType: mapEntry.value['associated_type'],
          connectionId: mapEntry.value['connection_id'],
          connectionType: mapEntry.value['connection_type'],
          createdTime: DateTime.fromMillisecondsSinceEpoch(
              mapEntry.value['created_time']),
          userIds: [userContactModel.id],
          userNames: [userContactModel.name],
          userProfilePics: [userContactModel.profilePic],
        );
        models.add(model);
        newlyLoadedDataCount = newlyLoadedDataCount + 1;
      }
      prevNotificationModel = models.last;
      }

      ids.add(mapEntry.key);
    }
  }

  Future<void> setData() async {
    for (int i = 0; i < 100; i++) {
      String key = reference.push().key;
      await Future.delayed(Duration(milliseconds: 1));
      Map<String, dynamic> map = {
        'id': key,
        'associated_id': '22021600172',
        'associated_type': 'blog',
        'connection_type': 'like',
        'sender_id': AppData().userId,
        'content': '$i liked your photo',
        'created_time': DateTime.now().millisecondsSinceEpoch
      };
      reference
          .child('Notification')
          .child(AppData().userId)
          .child('Data')
          .child(key)
          .set(map);
      reference
          .child('Notification')
          .child(AppData().userId)
          .child('count')
          .once()
          .then((value) {
        reference
            .child('Notification')
            .child(AppData().userId)
            .child('count')
            .set(value.value + 1);
      });
    }
  }
}
