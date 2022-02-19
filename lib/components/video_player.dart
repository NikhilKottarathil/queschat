
import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class CustomVideoPlayer extends StatefulWidget {
  File file;
  String url;
  CustomVideoPlayer({Key key,this.file,this.url}) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BetterPlayerDataSource betterPlayerDataSource;
    if(widget.file!=null){
      betterPlayerDataSource= BetterPlayerDataSource(
          BetterPlayerDataSourceType.file,widget.file.path);
    }else{
      betterPlayerDataSource= BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,widget.url);
    }
   print( "betterPlayerDataSource");;
    BetterPlayerConfiguration configuration
    =BetterPlayerConfiguration(
      autoDispose: true,
      fit: BoxFit.contain,

      controlsConfiguration: BetterPlayerControlsConfiguration(
          enablePip:true,
      ),
      autoDetectFullscreenDeviceOrientation: true,
      looping: false,
    );
    _betterPlayerController = BetterPlayerController(
       configuration,
        betterPlayerDataSource: betterPlayerDataSource);
    _betterPlayerController.addEventsListener((BetterPlayerEvent event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
        _betterPlayerController.setOverriddenAspectRatio(
            _betterPlayerController.videoPlayerController.value.aspectRatio);
        setState(() {});
      }
    });
  }
  @override
  void deactivate() {
    // TODO: implement deactivate
    _betterPlayerController.pause();

    _betterPlayerController.dispose(forceDispose: true);
    super.deactivate();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _betterPlayerController.pause();

    _betterPlayerController.dispose(forceDispose: true);
  }
  @override
  Widget build(BuildContext context) {

    return BetterPlayer(
      controller: _betterPlayerController,
    );
  }
}


//
//
//
//
// // import 'dart:io';
// //
// // import 'package:file_picker/file_picker.dart';
// // import 'package:flutter/gestures.dart';
// // import 'package:flutter/material.dart';
// // import 'package:video_player/video_player.dart';
// //
// // class SamMediaAdapter extends StatefulWidget {
// //   PlatformFile platformFile;
// //
// //   SamMediaAdapter({this.platformFile});
// //
// //   @override
// //   _SamMediaAdapterState createState() => _SamMediaAdapterState();
// // }
// //
// // class _SamMediaAdapterState extends State<SamMediaAdapter> {
// //   VideoPlayerController _controller;
// //
// //   double range = 0;
// //   double minRange = 0;
// //   double maxRange = 0;
// //   video_player: ^2.0.2
// //   @override
// //   void initState() {
// //     super.initState();
// //
// //     if(widget.platformFile!=null) {
// //       _controller =
// //       VideoPlayerController.file(new File(widget.platformFile.path))
// //         ..initialize().then((_) {
// //           setState(() {
// //             maxRange = _controller.value.duration.inSeconds.toDouble();
// //             // _controller.setLooping(true);
// //
// //             // _controller.play();
// //
// //           });
// //           // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
// //         })
// //         ..addListener(() {
// //           setState(() {
// //             print('is playing ');
// //             print(_controller.value.isPlaying);
// //             _controller.value.isPlaying
// //                 ? _controller.pause()
// //                 : _controller.play();
// //             range = _controller.value.position.inSeconds.toDouble();
// //           });
// //         });
// //     }
// //     // TODO: implement initState
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //
// //     return Container(
// //       width: MediaQuery.of(context).size.width,
// //       height: MediaQuery.of(context).size.height*.3,
// //       padding: EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(4),
// //         boxShadow: [
// //
// //           BoxShadow(
// //             color: Colors.grey.shade200,
// //             offset: Offset(0.0, 1.0), //(x,y)
// //
// //             spreadRadius: 1,blurRadius: 2,
// //           )
// //         ],
// //       ),
// //       margin: EdgeInsets.all(20),
// //
// //       child: Center(
// //         child: Stack(
// //           children: [
// //             Visibility(
// //               visible: getMediaType(widget.platformFile) == 'image',
// //               child: Image.file(new File(widget.platformFile.path)),
// //             ),
// //             Visibility(
// //               visible: getMediaType(widget.platformFile) == 'video',
// //               child: Column(
// //                 children: [
// //
// //                   Flexible(
// //                     child: AspectRatio(
// //                       aspectRatio: _controller.value.aspectRatio,
// //                       child: Stack(
// //                         children: [
// //
// //                           VideoPlayer(_controller),
// //
// //                           Align(
// //                             alignment: Alignment.centerLeft,
// //                             child: GestureDetector(
// //                               child:Container(
// //                                 color: Colors.transparent,
// //                                 height:  double.infinity,
// //                                 width:  MediaQuery.of(context).size.width*.2*_controller.value.aspectRatio,
// //                               ),
// //                               onDoubleTap: (){
// //                                 setState(() {
// //                                   // range = _controller.value.position.inSeconds.toDouble()-3;
// //                                   _controller.seekTo(Duration(seconds: _controller.value.position.inSeconds-5));
// //
// //                                 });
// //                               },
// //
// //                             ),
// //                           ),
// //                           Align(
// //                             alignment: Alignment.centerRight,
// //                             child: GestureDetector(
// //
// //
// //                               child:Container(
// //                                 color: Colors.transparent,
// //                                 width: MediaQuery.of(context).size.width*.2*_controller.value.aspectRatio,
// //                                 height:  double.infinity,
// //                               ),
// //                               // behavior: HitTestBehavior.,
// //                               onDoubleTap: (){
// //                                 setState(() {
// //                                   // range = _controller.value.position.inSeconds.toDouble()+3;
// //                                   // if(_controller.value.)
// //                                   _controller.seekTo(Duration(seconds: _controller.value.position.inSeconds+5));
// //
// //                                 });
// //                               },
// //
// //
// //                             ),
// //                           ),
// //                           Align(
// //                             alignment: Alignment.center,
// //                             child:  MaterialButton(
// //                               splashColor: Colors.transparent,
// //                               highlightColor: Colors.transparent,
// //                               // enableFeedback: false,
// //                               onPressed: () {
// //                                 print(_controller.value.aspectRatio);
// //
// //                                 setState(() {
// //                                   _controller.value.isPlaying
// //                                       ? _controller.pause()
// //                                       : _controller.play();
// //                                 });
// //                               },
// //                               child: Icon(
// //                                 _controller.value.isPlaying
// //                                     ? Icons.pause
// //                                     : Icons.play_arrow,size: 50,
// //                               ),
// //                             ),
// //                           ),
// //
// //                         ],
// //                       ),
// //
// //                     ),
// //                   ),
// //
// //
// //                   // Slider(min: 0,max: 100,value: range,divisions: 50,)
// //                   Slider(
// //                     value: range,
// //                     min: minRange,
// //                     max: maxRange,
// //                     activeColor: Colors.pink,
// //                     onChanged: (double value) {
// //                       setState(() {
// //                         range = value;
// //                         _controller.seekTo(Duration(seconds: range.toInt()));
// //                       });
// //                     },
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //
// //   }
// // }
// //
// // String getMediaType(PlatformFile platformFile) {
// //   List<String> imageExtensions = [
// //     'jpg',
// //     'png',
// //     'gif',
// //     'webp',
// //     'tiff',
// //     'tif',
// //     'psd',
// //     'raw',
// //     'arw',
// //     'cr2',
// //     'nrw',
// //     'k25',
// //     'bmp',
// //     'heif',
// //     'indd',
// //     'ind',
// //     'indt',
// //     'jp2',
// //     'j2k',
// //     'jpf',
// //     'jpx',
// //     'jpm',
// //     'mj2'
// //         'svg',
// //     'svgz',
// //     'ai',
// //     'eps'
// //   ];
// //   List<String> videoExtensions = [
// //     'webm',
// //     'mpg',
// //     'mp2',
// //     'mpeg',
// //     'mpe',
// //     'mpv',
// //     'ogg',
// //     'mp4',
// //     'm4p',
// //     'm4v',
// //     'avi',
// //     'mwv',
// //     'mov',
// //     'qt',
// //     'flv',
// //     'swf',
// //     'avchd'
// //   ];
// //
// //   if (imageExtensions.contains(platformFile.extension)) {
// //     return 'image';
// //   }
// //   if (videoExtensions.contains(platformFile.extension)) {
// //     return 'video';
// //   }
// //   // if(platformFile.extension)
// // }
