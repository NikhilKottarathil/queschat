import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:queschat/awsome_notifications.dart';
import 'package:queschat/components/app_exit_alert.dart';
import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/router/app_router.dart';



final AppRouter appRouter = AppRouter();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(androidNotificationChannel);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static final navigatorKey = new GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initializeNotifications(context);
  }

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.PrimaryColorLight,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));

    return WillPopScope(
      onWillPop: () {
        return appExitAlert(context);
      },
      child: MaterialApp(
        title: "Queschat",
        debugShowCheckedModeBanner: false,
        navigatorKey: MyApp.navigatorKey,


        theme: ThemeData(
            fontFamily: 'NunitoSans',
            appBarTheme: AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: AppColors.PrimaryColorLight,
                  statusBarIconBrightness: Brightness.light,
                  statusBarBrightness: Brightness.light,
                )),
            scaffoldBackgroundColor: AppColors.White),
        onGenerateRoute: appRouter.onGenerateRoute,
      ),
    );

    // return FutureBuilder(
    //   future: Firebase.initializeApp(),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasError) {
    //       return const MaterialApp(
    //         debugShowCheckedModeBanner: false,
    //         home: Scaffold(
    //           backgroundColor: Colors.grey,
    //           body: Center(child: Text("Error")),
    //         ),
    //       );
    //     }
    //     if (snapshot.connectionState == ConnectionState.done) {
    //     }
    //     return MaterialApp(
    //       debugShowCheckedModeBanner: false,
    //       home: Scaffold(
    //         body: CustomProgressIndicator(),
    //       ),
    //     );
    //   },
    // );
  }
}


