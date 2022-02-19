


import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/home/feeds/post_blog/post_blog_bloc.dart';
import 'package:queschat/uicomponents/appbars.dart';
import 'package:tuple/tuple.dart';

import 'package:flutter_bloc/flutter_bloc.dart';


class TextEditorView extends StatefulWidget {
  String incomingJSONText;
  TextEditorView({this.incomingJSONText});

  @override
  _TextEditorState createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditorView> {
  final FocusNode _focusNode = FocusNode();

  QuillController controller;
  @override
  void initState() {
    super.initState();
    try {
      var myJSON = jsonDecode(widget.incomingJSONText);
      controller = QuillController(
          document: Document.fromJson(myJSON),
          selection: TextSelection.collapsed(offset: 0));
    }catch(e){

    }
  }



  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return   Text(widget.incomingJSONText);
    }
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (event) {
        if (event.data.isControlPressed && event.character == 'b') {
          if (controller
              .getSelectionStyle()
              .attributes
              .keys
              .contains('bold')) {
            controller
                .formatSelection(Attribute.clone(Attribute.bold, null));
          } else {
            controller.formatSelection(Attribute.bold);
          }
        }
      },
      child: _buildWelcomeEditor(context),
    );

  }

  Widget _buildWelcomeEditor(BuildContext context) {
    var quillEditor = QuillEditor(
        controller: controller,
        scrollController: ScrollController(),
        scrollable: true,
        focusNode: _focusNode,
        autoFocus: false,
        readOnly: true,
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
      controller: controller,
      // provide a callback to enable picking images from device.
      // if omit, "image" button only allows adding images from url.
      // same goes for videos.
      onImagePickCallback: _onImagePickCallback,
      onVideoPickCallback: _onVideoPickCallback,
      // uncomment to provide a custom "pick from" dialog.
      // mediaPickSettingSelector: _selectMediaPickSetting,
      showAlignmentButtons: true,
    );
    if (kIsWeb) {
      toolbar = QuillToolbar.basic(
        controller: controller,
        onImagePickCallback: _onImagePickCallback,
        webImagePickImpl: _webImagePickImpl,
        showAlignmentButtons: true,
      );
    }

    return quillEditor;
  }

  bool _isDesktop() => !kIsWeb && !Platform.isAndroid && !Platform.isIOS;


  // Renders the image picked by imagePicker from local file storage
  // You can also upload the picked image to any server (eg : AWS s3
  // or Firebase) and then return the uploaded image URL.
  Future<String> _onImagePickCallback(File file) async {
    // Copies the picked file from temporary cache to applications directory
    final appDocDir = await getApplicationDocumentsDirectory();
    final copiedFile =
    await file.copy('${appDocDir.path}/${basename(file.path)}');
    return copiedFile.path.toString();
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
  Future<MediaPickSetting> _selectMediaPickSetting(BuildContext context) =>
      showDialog<MediaPickSetting>(
        context: context,
        builder: (ctx) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.collections),
                label: const Text('Gallery'),
                onPressed: () => Navigator.pop(ctx, MediaPickSetting.Gallery),
              ),
              TextButton.icon(
                icon: const Icon(Icons.link),
                label: const Text('Link'),
                onPressed: () => Navigator.pop(ctx, MediaPickSetting.Link),
              )
            ],
          ),
        ),
      );

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

