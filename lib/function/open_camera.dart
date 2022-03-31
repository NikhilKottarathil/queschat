import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:queschat/home/message/message_room/message_room_cubit.dart';
import 'package:queschat/models/message_model.dart';


getMediaFromCamera(BuildContext context) async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera,);
  if (pickedFile != null) {
    File _image = File(pickedFile.path);
    context.read<MessageRoomCubit>().sendMessage(
        files: [_image], messageType: MessageType.file);
  }
}

