import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/app_data.dart';
import 'package:queschat/constants/strings_and_urls.dart';
import 'package:queschat/home/in_app_notification/in_app_notification_model.dart';
import 'package:queschat/home/in_app_notification/in_app_notification_state.dart';

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
    print('inap init');
    getInitialData();
    // setData();
    getNotificationCount();
  }

  Future<void> getNotificationCount() async {
    reference
        .child('Connection')
        .child(AppData().userId)
        .child('count')
        .onValue
        .listen((event) {
      print('NewNotificationCount ${event.snapshot.value}');
      if ( event.snapshot.value != null) {
        newNotificationCount = event.snapshot.value;
        emit(NewNotificationCount(newNotificationCount));

      }
      emit(NewNotificationCount(newNotificationCount));
    });
  }

  Future<void> getLiveNotifications() async {
    reference
        .child('Connection')
        .child(AppData().userId)
        .child('data')
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
    print('getInitialData 0  ${models.length}');

    reference
        .child('Connection')
        .child(AppData().userId)
        .child('data')
        .orderByChild('create_date')
        .limitToLast(initialCountLimit)
        .once()
        .then((value) async {
      Map<dynamic, dynamic> map = value.value;
      if (map != null) {
        await convertDataIntoModel(map);
        updateList();
      } else {
        updateList();
      }
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
        .child('Connection')
        .child(AppData().userId)
        .child('data')
        .orderByChild('create_date')
        .endAt(models.isEmpty
            ? ServerValue.timestamp
            : models.last.createdTime.millisecondsSinceEpoch)
        .limitToLast(loadMoreLimit)
        .once()
        .then((value) async {
      Map<dynamic, dynamic> map = value.value;

      if (map != null) {
        print('getLoadMoreData map length is  ${map.entries.length}');

        if (map.entries.length != 1) {
          print('getLoadMoreData $map');

          await convertDataIntoModel(map);
          print('getLoadMoreData 1 ${models.length}');
          updateList();

          if (newlyLoadedDataCount < loadMoreLimit - 1) {
            getMoreDate();
          }
        } else {
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
        print('prevous $prevNotificationModel');

        if (prevNotificationModel != null &&
            prevNotificationModel.associateId == mapEntry.value['feed_id'] &&
            prevNotificationModel.connectionType ==
                mapEntry.value['connection_type']) {
          print(
              'prevous ${prevNotificationModel.associateId} == ${mapEntry.value['feed_id'].toString()}');
          print('inside prev');
          models.last.userNames.add(mapEntry.value['user_name']);
          models.last.userProfilePics.add(mapEntry.value['profile_pic'] != null
              ? Urls().serverAddress + mapEntry.value['profile_pic']
              : null);
          models.last.userIds.add(mapEntry.value['user_id'].toString());
          DateTime newCreatedTime = DateTime.fromMillisecondsSinceEpoch(
              mapEntry.value['create_date']);
          if (newCreatedTime.compareTo(models.last.createdTime).isNegative) {
            models.last.createdTime = newCreatedTime;
            models.last.id = mapEntry.key;
          }
        } else {
          InAppNotificationModel model = InAppNotificationModel(
            id: mapEntry.key,
            associateId: mapEntry.value['feed_id'].toString(),
            associateType: mapEntry.value['feed_type'],
            connectionId: mapEntry.value['id'].toString(),
            connectionType: mapEntry.value['connection_type'],
            createdTime: DateTime.fromMillisecondsSinceEpoch(
                mapEntry.value['create_date']),
            userIds: [mapEntry.value['user_id'].toString()],
            userNames: [mapEntry.value['user_name']],
            userProfilePics: [
              mapEntry.value['profile_pic'] != null
                  ? Urls().serverAddress + mapEntry.value['profile_pic']
                  : null
            ],
          );
          models.add(model);
          newlyLoadedDataCount = newlyLoadedDataCount + 1;
        }
        prevNotificationModel = models.last;
      }

      ids.add(mapEntry.key);
    }
  }

// Future<void> setData() async {
//   for (int i = 0; i < 100; i++) {
//     String key = reference.push().key;
//     await Future.delayed(Duration(milliseconds: 1));
//     Map<String, dynamic> map = {
//       'id': key,
//       'associated_id': '22021600172',
//       'associated_type': 'blog',
//       'connection_type': 'like',
//       'sender_id': AppData().userId,
//       'content': '$i liked your photo',
//       'create_date': ServerValue.timestamp
//     };
//     reference
//         .child('Connection')
//         .child(AppData().userId)
//         .child('data')
//         .child(key)
//         .set(map);
//     reference
//         .child('Connection')
//         .child(AppData().userId)
//         .child('count')
//         .once()
//         .then((value) {
//       reference
//           .child('Connection')
//           .child(AppData().userId)
//           .child('count')
//           .set(value.value + 1);
//     });
//   }
// }
}
