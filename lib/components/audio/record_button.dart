import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:queschat/components/audio/flow_shader.dart';
import 'package:queschat/components/audio/globals.dart';
import 'package:queschat/components/audio/lottie_animation.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/home/message/message_room/message_room_cubit.dart';
import 'package:queschat/models/message_model.dart';
import 'package:record/record.dart';

class RecordButton extends StatefulWidget {
  RecordButton({
    Key key,
    // @required this.controller,
    @required this.parentContext,
  }) : super(key: key);

  // final AnimationController controller;
  BuildContext parentContext;

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> with SingleTickerProviderStateMixin {
  static const double size = 60;
  static const double buttonSize = 40;

  final double lockerHeight = 200;
  double timerWidth = 0;

  Animation<double> buttonScaleAnimation;
  Animation<double> timerAnimation;
  Animation<double> lockerAnimation;

  DateTime startTime;
  Timer timer;
  String recordDuration = "00:00";
  Record record;

  bool isLocked = false;
  bool showLottie = false;
   AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    buttonScaleAnimation = Tween<double>(begin: 1, end: 2).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticInOut),
      ),
    );
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    timerWidth =
        MediaQuery.of(context).size.width - 2 * Globals.defaultPadding - 4;
    timerAnimation =
        Tween<double>(begin: MediaQuery.of(context).size.width + 10, end: 0)
            .animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.2, 1, curve: Curves.easeIn),
      ),
    );
    lockerAnimation =
        Tween<double>(begin: lockerHeight + Globals.defaultPadding, end: 0)
            .animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.2, 1, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    record.dispose();
    controller.dispose();
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        lockSlider(),
        cancelSlider(),
        audioButton(),
        if (isLocked) timerLocked(),
      ],
    );
  }

  Widget lockSlider() {
    return Positioned(
      bottom: -lockerAnimation.value,
      child: Container(
        height: lockerHeight,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Globals.borderRadius),
          color: AppColors.White,
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.lock, size: 20),
            const SizedBox(height: 8),
            FlowShader(
              direction: Axis.vertical,
              child: Column(
                children: const [
                  Icon(Icons.keyboard_arrow_up),
                  Icon(Icons.keyboard_arrow_up),
                  Icon(Icons.keyboard_arrow_up),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cancelSlider() {
    return Positioned(
      right: -timerAnimation.value,
      bottom: -8,
      child: Material(
        color: Colors.white,
        child: Container(
          height: size,
          width: MediaQuery.of(context).size.width - 10,
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(Globals.borderRadius),
            color: AppColors.White,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                showLottie ? const LottieAnimation() : Text(recordDuration),
                const SizedBox(width: size),
                FlowShader(
                  child: Row(
                    children: const [
                      Icon(Icons.keyboard_arrow_left),
                      Text("Slide to cancel")
                    ],
                  ),
                  duration: const Duration(seconds: 3),
                  flowColors: const [Colors.white, Colors.grey],
                ),
                const SizedBox(width: size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget timerLocked() {
    return Material(
      color: AppColors.White,
      child: Container(
        height: size,
        width: MediaQuery.of(context).size.width - 10,
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(Globals.borderRadius),
          color: AppColors.White,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15,),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(recordDuration),
              InkWell(
                radius: 10,
                splashColor: Colors.transparent,
                onTap: (){
                  cancelRecording();
                },
                child: FlowShader(
                  child: const Text("Tap  to cancel"),
                  duration: const Duration(seconds: 3),
                  flowColors: const [Colors.white, Colors.grey],
                ),
              ),
              InkWell(
                onTap: () async {
                  Vibrate.feedback(FeedbackType.success);
                  timer?.cancel();
                  timer = null;
                  startTime = null;
                  recordDuration = "00:00";

                  var filePath = await Record().stop();
                  widget.parentContext.read<MessageRoomCubit>().sendMessage(
                      messageType: MessageType.voice_note,
                      files: [File(filePath)]);

                  debugPrint(filePath);
                  setState(() {
                    isLocked = false;
                  });
                },
                child:  Container(
                  child: const Icon(
                    Icons.send,
                    color: AppColors.White,
                  ),
                  height: 42,
                  width: 42,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.PrimaryColorLight,

                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget audioButton() {
    return GestureDetector(
      child: Transform.scale(
        scale: buttonScaleAnimation.value,
        child: Container(
          child: const Icon(
            Icons.mic,
            color: AppColors.White,
          ),
          height: buttonSize,
          width: buttonSize,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.PrimaryColorLight,
          ),
        ),
      ),
      onLongPressDown: (_) {
        debugPrint("onLongPressDown");
        controller.forward();
      },
      onLongPressEnd: (details) async {
        debugPrint("onLongPressEnd");

        if (isCancelled(details.localPosition, context)) {

          cancelRecording();
        } else if (checkIsLocked(details.localPosition)) {
         await controller.reverse();

          Vibrate.feedback(FeedbackType.heavy);
          debugPrint("Locked recording");
          debugPrint(details.localPosition.dy.toString());
          setState(() {
            isLocked = true;
          });
        } else {
          controller.reverse();

          Vibrate.feedback(FeedbackType.success);

          timer?.cancel();
          timer = null;
          startTime = null;
          recordDuration = "00:00";

          var filePath = await Record().stop();

          widget.parentContext.read<MessageRoomCubit>().sendMessage(
              messageType: MessageType.voice_note, files: [File(filePath)]);
          debugPrint(filePath);
        }
      },
      onLongPressCancel: () {
        debugPrint("onLongPressCancel");
        controller.reverse();
      },
      onLongPress: () async {
        debugPrint("onLongPress");
        Vibrate.feedback(FeedbackType.success);
        if (await Permission.storage.isGranted) {
          if (await Permission.manageExternalStorage.isGranted) {
            if (await Record().hasPermission()) {
              record = Record();
              Directory tempDir = await getTemporaryDirectory();
              String tempPath = tempDir.path;

              Directory appDocDir = await getApplicationDocumentsDirectory();
              String appDocPath = appDocDir.path;
              await record.start(
                path: appDocPath +
                    "audio_${DateTime.now().millisecondsSinceEpoch}.m4a",
                encoder: AudioEncoder.AAC,
                bitRate: 128000,
                samplingRate: 44100,
              );
              startTime = DateTime.now();
              timer = Timer.periodic(const Duration(seconds: 1), (_) {
                final minDur = DateTime.now().difference(startTime).inMinutes;
                final secDur =
                    DateTime.now().difference(startTime).inSeconds % 60;
                String min = minDur < 10 ? "0$minDur" : minDur.toString();
                String sec = secDur < 10 ? "0$secDur" : secDur.toString();
                setState(() {
                  recordDuration = "$min:$sec";
                });
              });
            }
          } else {
            await [Permission.manageExternalStorage].request();
          }
        } else {
          await [Permission.storage].request();
        }
      },
    );
  }

  bool checkIsLocked(Offset offset) {
    return (offset.dy < -35);
  }

  bool isCancelled(Offset offset, BuildContext context) {
    return (offset.dx < -(MediaQuery.of(context).size.width * 0.2));
  }
  cancelRecording(){
    Vibrate.feedback(FeedbackType.heavy);

    timer?.cancel();
    timer = null;
    startTime = null;
    recordDuration = "00:00";

    setState(() {
      isLocked=false;
      showLottie = true;
    });

    Timer(const Duration(milliseconds: 1440), () async {
      controller.reverse();
      debugPrint("Cancelled recording");
      var filePath = await record.stop();
      debugPrint(filePath);
      File(filePath).delete();
      debugPrint("Deleted $filePath");
      showLottie = false;
    });
  }
}
