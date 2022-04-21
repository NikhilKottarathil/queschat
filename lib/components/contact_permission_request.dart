import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/home/message/new_chat/new_chat_cubit.dart';
import 'package:queschat/home/message/new_chat/new_chat_view.dart';
import 'package:queschat/router/app_router.dart';

showContactPermissionRequest(BuildContext context) async {
  await showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) => AlertDialog(
            insetPadding: EdgeInsets.all(20),
            titlePadding: EdgeInsets.all(0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: EdgeInsets.all(0),
            actionsPadding: EdgeInsets.all(0),
            backgroundColor: AppColors.White,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                    color: AppColors.PrimaryColorLight,
                  ),
                  padding: EdgeInsets.all(20),
                  child: Icon(
                    Icons.contacts,
                    color: AppColors.White,
                    size: 32,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'QuesChat needs access to  your contacts so that you can connect with your friends',
                    style: TextStyles.bodyTextPrimary,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: Text(
                            "CANCEL",
                            style: TextStyles.buttonPrimary,
                          )),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        bool isPermanentlyDenied =
                            await Permission.contacts.isPermanentlyDenied;

                        if (!isPermanentlyDenied) {
                          await openAppSettings().then((value) => print('openAppSettings then')).whenComplete(() => print('openAppSettings then')).onError((error, stackTrace) => print('openAppSettings then'));
                          await openAppSettings().whenComplete(() async {
                            bool isGranted =
                                await Permission.contacts.isGranted;
                            if (isGranted) {
                              await resetRepositoryAndBloc();
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider(
                                      create: (context) => NewChatCubit(
                                          authRepo: authRepository),
                                      child: NewChatView(),
                                    ),
                                  ));
                            }
                          });
                        } else {
                          await [Permission.contacts].request();
                          bool isGranted = await Permission.contacts.isGranted;
                          if (isGranted) {
                            await resetRepositoryAndBloc();
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider(
                                    create: (context) =>
                                        NewChatCubit(authRepo: authRepository),
                                    child: NewChatView(),
                                  ),
                                ));
                          }
                        }
                      },
                      child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: Text(
                            "CONTINUE",
                            style: TextStyles.buttonPrimary,
                          )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ));
  return false;
}
