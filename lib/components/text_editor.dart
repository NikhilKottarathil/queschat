// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart';
// import 'package:queschat/uicomponents/custom_button.dart';
//
// class TextEditor extends StatefulWidget {
//   var text;
//    TextEditor({Key key,this.text}) : super(key: key);
//
//   @override
//   State<TextEditor> createState() => _TextEditorState();
// }
//
// class _TextEditorState extends State<TextEditor> {
//   QuillController widget.controller = QuillController.basic();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     if(widget.text!=null){
//
//       var myJSON = jsonDecode(widget.text);
//       widget.controller = QuillController(
//           document: Document.fromJson(myJSON),
//           selection: TextSelection.collapsed(offset: 0));    }
//
//   }
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       body: Column(
//         children: [
//           QuillToolbar.basic(controller: widget.controller),
//           Expanded(
//
//             child: Container(
//               child: QuillEditor(
//
//
//                 controller: widget.controller,
//                 readOnly: false, // true for view only mode
//               ),
//             ),
//           ),
//           // Expanded(
//           //
//           //   child: Container(
//           //     child: Text(widget.controller.document.toPlainText()),
//           //   ),
//           // ),
//           CustomButton(text: 'next',action: (){
//             var json = jsonEncode(widget.controller.document.toDelta().toJson());
//
//             print(json);
//             Navigator.push(context, MaterialPageRoute(builder: (context)=>TextEditor( text: json,)));
//
//           },),
//         ],
//       ),
//     );
//   }
// }










import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:queschat/constants/styles.dart';
import 'package:tuple/tuple.dart';


class TextEditor extends StatefulWidget {
  QuillController controller;
  BuildContext postBlogBlocContext;
  TextEditor({this.controller,this.postBlogBlocContext});

  @override
  _TextEditorState createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    if (widget.controller == null) {

      return const Scaffold(body: Center(child: Text('Loading...')));
    }

    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (event) {
        if (event.data.isControlPressed && event.character == 'b') {
          if (widget.controller
              .getSelectionStyle()
              .attributes
              .keys
              .contains('bold')) {
            widget.controller
                .formatSelection(Attribute.clone(Attribute.bold, null));
          } else {
            widget.controller.formatSelection(Attribute.bold);
          }

        }
      },
      child: _buildWelcomeEditor(context),
    );

  }

  Widget _buildWelcomeEditor(BuildContext context) {
    var quillEditor = QuillEditor(

      
        controller: widget.controller,
        scrollController: ScrollController(),
        scrollable: true,
        focusNode: _focusNode,
        autoFocus: false,

        readOnly: false,
        placeholder: 'Enter your content',
        expands: false,
        padding: EdgeInsets.zero,
        customStyles: DefaultStyles(
          h1: DefaultTextBlockStyle(
              const TextStyle(
                fontSize: 32,
                color: Colors.black,
                height: 1.15,
                fontWeight: FontWeight.w300,
              ),
              const Tuple2(16, 0),
              const Tuple2(0, 0),
              null),
          sizeSmall: const TextStyle(fontSize: 9),
        ));


    var toolbar = QuillToolbar.basic(
      controller: widget.controller,

      // provide a callback to enable picking images from device.
      // if omit, "image" button only allows adding images from url.
      // same goes for videos.
      onImagePickCallback: _onImagePickCallback,


      showCameraButton: false,
      // showVideoButton: false,

      showVideoButton: true,


      onVideoPickCallback: _onVideoPickCallback,
      // uncomment to provide a custom "pick from" dialog.
      mediaPickSettingSelector: _selectMediaPickSetting,
      showAlignmentButtons: true,
    );
    if (kIsWeb) {
      toolbar = QuillToolbar.basic(
        controller: widget.controller,
        onImagePickCallback: _onImagePickCallback,
        webImagePickImpl: _webImagePickImpl,
        showAlignmentButtons: true,
      );
    }

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          kIsWeb
              ? Expanded(
              child: Container(
                padding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: toolbar,
              ))
              : Container(child: toolbar,color: AppColors.PrimaryColorLight, padding:
          const EdgeInsets.symmetric(vertical: 8, horizontal: 4),),
          Expanded(
            flex: 15,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 16, right: 16,top: 8,bottom: 8),
              child: quillEditor,
            ),
          ),


        ],
      ),
    );
  }

  bool _isDesktop() => !kIsWeb && !Platform.isAndroid && !Platform.isIOS;


  // Renders the image picked by imagePicker from local file storage
  // You can also upload the picked image to any server (eg : AWS s3
  // or Firebase) and then return the uploaded image URL.
  Future<String> _onImagePickCallback(File file) async {
    // // Copies the picked file from temporary cache to applications directory
    final appDocDir = await getApplicationDocumentsDirectory();
    final copiedFile =
    await file.copy('${appDocDir.path}/${basename(file.path)}');
    return file.path.toString();



  }

  Future<String> _webImagePickImpl(
      OnImagePickCallback onImagePickCallback) async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return null;
    }

    // Take first, because we don't allow picking multiple files.
    final fileName = result.files.first.name;
    final file = File(fileName);

    return onImagePickCallback(file);
  }

  // Renders the video picked by imagePicker from local file storage
  // You can also upload the picked video to any server (eg : AWS s3
  // or Firebase) and then return the uploaded video URL.
  Future<String> _onVideoPickCallback(File file) async {
    // Copies the picked file from temporary cache to applications directory
    final appDocDir = await getApplicationDocumentsDirectory();
    final copiedFile =
    await file.copy('${appDocDir.path}/${basename(file.path)}');
    return copiedFile.path.toString();
  }

  // ignore: unused_element
  Future<MediaPickSetting> _selectMediaPickSetting(BuildContext context) async {
    return await MediaPickSetting.Gallery;
  }
      // showDialog<MediaPickSetting>(
      //   context: context,
        // builder: (ctx) => AlertDialog(
        //   contentPadding: EdgeInsets.all(10),
        //   backgroundColor: AppColors.White,
        //   content: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       TextButton.icon(
        //         icon: const Icon(Icons.collections),
        //         label: const Text('Gallery'),
        //
        //         style: TextButton.styleFrom(backgroundColor: AppColors.White),
        //         onPressed: () => Navigator.pop(ctx, MediaPickSetting.Gallery),
        //       ),
        //       TextButton.icon(
        //         icon: const Icon(Icons.link),
        //         label: const Text('Link'),
        //         onPressed: () => Navigator.pop(ctx, MediaPickSetting.Link),
        //       )
        //     ],
        //   ),
        // ),
      // );

  Widget _buildMenuBar(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const itemStyle = TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Divider(
          thickness: 2,
          color: Colors.white,
          indent: size.width * 0.1,
          endIndent: size.width * 0.1,
        ),
        ListTile(
          title: const Center(child: Text('Read only demo', style: itemStyle)),
          dense: true,
          visualDensity: VisualDensity.compact,
          // onTap: _readOnly,
        ),
        Divider(
          thickness: 2,
          color: Colors.white,
          indent: size.width * 0.1,
          endIndent: size.width * 0.1,
        ),
      ],
    );
  }

}





//
// showTextEditor(BuildContext context) async {
//   QuillController widget.controller;
//   final FocusNode _focusNode = FocusNode();
//
//   bool _isDesktop() => !kIsWeb && !Platform.isAndroid && !Platform.isIOS;
//
//
//   // Renders the image picked by imagePicker from local file storage
//   // You can also upload the picked image to any server (eg : AWS s3
//   // or Firebase) and then return the uploaded image URL.
//   Future<String> _onImagePickCallback(File file) async {
//     // Copies the picked file from temporary cache to applications directory
//     final appDocDir = await getApplicationDocumentsDirectory();
//     final copiedFile =
//     await file.copy('${appDocDir.path}/${basename(file.path)}');
//     return copiedFile.path.toString();
//   }
//
//   Future<String> _webImagePickImpl(
//       OnImagePickCallback onImagePickCallback) async {
//     final result = await FilePicker.platform.pickFiles();
//     if (result == null) {
//       return null;
//     }
//
//     // Take first, because we don't allow picking multiple files.
//     final fileName = result.files.first.name;
//     final file = File(fileName);
//
//     return onImagePickCallback(file);
//   }
//
//   // Renders the video picked by imagePicker from local file storage
//   // You can also upload the picked video to any server (eg : AWS s3
//   // or Firebase) and then return the uploaded video URL.
//   Future<String> _onVideoPickCallback(File file) async {
//     // Copies the picked file from temporary cache to applications directory
//     final appDocDir = await getApplicationDocumentsDirectory();
//     final copiedFile =
//     await file.copy('${appDocDir.path}/${basename(file.path)}');
//     return copiedFile.path.toString();
//   }
//
//   // ignore: unused_element
//   Future<MediaPickSetting> _selectMediaPickSetting(BuildContext context) =>
//       showDialog<MediaPickSetting>(
//         context: context,
//         builder: (ctx) => AlertDialog(
//           contentPadding: EdgeInsets.zero,
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextButton.icon(
//                 icon: const Icon(Icons.collections),
//                 label: const Text('Gallery'),
//                 onPressed: () => Navigator.pop(ctx, MediaPickSetting.Gallery),
//               ),
//               TextButton.icon(
//                 icon: const Icon(Icons.link),
//                 label: const Text('Link'),
//                 onPressed: () => Navigator.pop(ctx, MediaPickSetting.Link),
//               )
//             ],
//           ),
//         ),
//       );
//
//   Widget _buildMenuBar(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     const itemStyle = TextStyle(
//       color: Colors.white,
//       fontSize: 18,
//       fontWeight: FontWeight.bold,
//     );
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Divider(
//           thickness: 2,
//           color: Colors.white,
//           indent: size.width * 0.1,
//           endIndent: size.width * 0.1,
//         ),
//         ListTile(
//           title: const Center(child: Text('Read only demo', style: itemStyle)),
//           dense: true,
//           visualDensity: VisualDensity.compact,
//           // onTap: _readOnly,
//         ),
//         Divider(
//           thickness: 2,
//           color: Colors.white,
//           indent: size.width * 0.1,
//           endIndent: size.width * 0.1,
//         ),
//       ],
//     );
//   }
//   Widget _buildWelcomeEditor(BuildContext context) {
//     var quillEditor = QuillEditor(
//         controller: widget.controller,
//         scrollController: ScrollController(),
//         scrollable: true,
//         focusNode: _focusNode,
//         autoFocus: false,
//         readOnly: false,
//         placeholder: 'Add content',
//         expands: false,
//         padding: EdgeInsets.zero,
//         customStyles: DefaultStyles(
//           h1: DefaultTextBlockStyle(
//               const TextStyle(
//                 fontSize: 32,
//                 color: Colors.black,
//                 height: 1.15,
//                 fontWeight: FontWeight.w300,
//               ),
//               const Tuple2(16, 0),
//               const Tuple2(0, 0),
//               null),
//           sizeSmall: const TextStyle(fontSize: 9),
//         ));
//
//
//     var toolbar = QuillToolbar.basic(
//       controller: widget.controller,
//       // provide a callback to enable picking images from device.
//       // if omit, "image" button only allows adding images from url.
//       // same goes for videos.
//       onImagePickCallback: _onImagePickCallback,
//       onVideoPickCallback: _onVideoPickCallback,
//       // uncomment to provide a custom "pick from" dialog.
//       // mediaPickSettingSelector: _selectMediaPickSetting,
//       showAlignmentButtons: true,
//     );
//     if (kIsWeb) {
//       toolbar = QuillToolbar.basic(
//         controller: widget.controller,
//         onImagePickCallback: _onImagePickCallback,
//         webImagePickImpl: _webImagePickImpl,
//         showAlignmentButtons: true,
//       );
//     }
//
//     return SafeArea(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Expanded(
//             flex: 15,
//             child: Container(
//               color: Colors.white,
//               padding: const EdgeInsets.only(left: 16, right: 16),
//               child: quillEditor,
//             ),
//           ),
//           kIsWeb
//               ? Expanded(
//               child: Container(
//                 padding:
//                 const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
//                 child: toolbar,
//               ))
//               : Container(child: toolbar)
//         ],
//       ),
//     );
//   }
//
//   await showDialog(
//       context: context,
//       useSafeArea: true,
//       useRootNavigator: true,
//       builder: (context) {
//         return Scaffold(
//           appBar:appBarWithBackButton(titleString: 'Post',context: context,),
//           body: RawKeyboardListener(
//             focusNode: FocusNode(),
//             onKey: (event) {
//               if (event.data.isControlPressed && event.character == 'b') {
//                 if (widget.controller
//                     .getSelectionStyle()
//                     .attributes
//                     .keys
//                     .contains('bold')) {
//                   widget.controller
//                       .formatSelection(Attribute.clone(Attribute.bold, null));
//                 } else {
//                   widget.controller.formatSelection(Attribute.bold);
//                 }
//               }
//             },
//             child: _buildWelcomeEditor(context),
//           ),
//         );
//
//   }
//
//
// );
//
//
//   return widget.controller.document.toDelta().toJson();
//
// }
