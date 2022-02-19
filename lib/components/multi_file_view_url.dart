import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:queschat/components/custom_web_view.dart';
import 'package:queschat/components/video_player.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/file_types.dart';

class MultiFileViewUrl extends StatefulWidget {
  List<String> mediaUrl;

  MultiFileViewUrl({Key key, this.mediaUrl}) : super(key: key);

  @override
  _MultiFileViewUrlState createState() => _MultiFileViewUrlState();
}

class _MultiFileViewUrlState extends State<MultiFileViewUrl> {
  List<String> media;
  final CarouselController _controller = CarouselController();
  int _current = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    media = widget.mediaUrl;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Stack(children: [
        CarouselSlider(
          items: media
              .map((item) => Container(
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        child: getFileTypeFromPath(item) == 'unknown'
                            ? Center(
                                child: Text('This file is not supported'),
                              )
                            : getFileTypeFromPath(item) == 'image'
                                ? Image.network(
                                    item,
                                    fit: BoxFit.fitWidth,
                                    width: double.infinity,
                                  )
                                : getFileTypeFromPath(item) == 'video' ||
                                        getFileTypeFromPath(item) == 'audio'
                                    ? CustomVideoPlayer(
                                        url: item,
                                      )
                                    : InkWell(
                                        onTap: () {
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             CustomWebView(
                                          //               file: item,
                                          //             )));
                                        },
                                        child: Column(
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
                                            Text(item)
                                          ],
                                        ),
                                      )),
                  ))
              .toList(),
          carouselController: _controller,
          options: CarouselOptions(
              height: 300,
              viewportFraction: 1.0,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        Visibility(
          visible: media.length != 1,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: media.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.PrimaryColor.withOpacity(
                              _current == entry.key ? 0.9 : 0.4)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}


