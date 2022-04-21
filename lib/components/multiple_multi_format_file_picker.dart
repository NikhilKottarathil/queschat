import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;
import 'package:queschat/components/popups/show_loader.dart';
import 'package:queschat/components/video_player.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/file_types.dart';
import 'package:queschat/home/message/message_room/message_room_cubit.dart';
import 'package:queschat/models/message_model.dart';
import 'package:queschat/uicomponents/appbars.dart';
import 'package:queschat/uicomponents/custom_button.dart';

Future<void> multipleMultiFormatFilePicker(
    {@required BuildContext buildContext, @required String roomName}) async {
  try {
    List<File> files = [];
    showLoader(buildContext,0.9);

    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: true,

      allowCompression: true,

    );
    Navigator.of(buildContext).pop();

    if (result != null) {
      result.files.forEach((platformFile) {
        final File file = File(platformFile.path);
        files..add(file);
      });
      await selectFilesFromPicked(
          buildContext: buildContext, files: files, roomName: roomName);

    }
  } catch (e) {
    print(e);
  }
}

Future<void> selectFilesFromPicked(
    {@required BuildContext buildContext,
    @required List<File> files,
    @required roomName}) async {
  final CarouselController _controller = CarouselController();
  int _current = 0;
  showDialog(
    context: buildContext,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Scaffold(
            appBar: appBarWithBackButton(
                context: context,
                titleString: 'Send to $roomName',
                tailActions: [
                  files.length > 1
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              files.removeAt(_current);
                            });
                          },
                          icon: Icon(
                            Icons.delete,
                            color: AppColors.IconColor,
                          ))
                      : Container(),
                ]),
            body: Column(children: [
              Expanded(
                child: CarouselSlider(
                  items: files
                      .map((item) => ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          child: getFileTypeFromPath(item.path) == 'unknown'
                              ? Center(
                                  child: Text('This file is not supported'),
                                )
                              : getFileTypeFromPath(item.path) == 'image'
                                  ? Image.file(
                                      item,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    )
                                  : getFileTypeFromPath(item.path) == 'video' ||
                                          getFileTypeFromPath(item.path) == 'audio'
                                      ? CustomVideoPlayer(
                                          file: item,
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.picture_as_pdf,
                                              size: 50,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(path.basename(item.path))
                                          ],
                                        )))
                      .toList(),
                  carouselController: _controller,
                  options: CarouselOptions(
                      height: double.maxFinite,
                      viewportFraction: 1.0,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: files.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 12.0,
                        height: 12.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.PrimaryColor.withOpacity(
                                _current == entry.key ? 0.9 : 0.4)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: CustomButton(
                  text: 'Send',
                  action: () async {
                    try {
                      buildContext.read<MessageRoomCubit>().sendMessage(
                          files: files, messageType: MessageType.file);
                    }catch(e){

                    }
                    Navigator.of(context).pop();
                  },
                ),
              )
            ]),
          );
        },
      );
    },
  );

  return null;
}

