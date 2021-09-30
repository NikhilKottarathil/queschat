import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

selectImage({context, File imageFile, var aspectRatios}) async {
  try {
    await showModalBottomSheet(
        elevation: 10,
        useRootNavigator: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            )),
        context: context,

        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(
                      Icons.camera_enhance_sharp,
                      color: Colors.red,
                    ),
                    title: new Text(
                      'Camera',
                      style: TextStyle(
                          color: Colors.blue.shade800, fontSize: 18),
                    ),
                    onTap: () async {
                      imageFile = await getImageFromCamera();
                      imageFile = await cropImage(
                          image: imageFile, aspectRatios: aspectRatios);
                      print('imageFile');
                      print(imageFile);

                      Navigator.pop(bc);
                      return imageFile;
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo, color: Colors.red),
                  title: new Text(
                    'Gallery',
                    style: TextStyle(color: Colors.blue.shade800, fontSize: 18),
                  ),
                  onTap: () async {
                    imageFile = await getImageFromGallery();
                    imageFile = await cropImage(
                        image: imageFile, aspectRatios: aspectRatios);

                    print('imageFile');
                    print(imageFile);

                    Navigator.pop(bc);
                    return imageFile;
                  },
                ),
              ],
            ),
          );
        });

    return imageFile;
  }catch(e){

  }
}

getImageFromGallery() async {
  final _picker = ImagePicker();

  final pickedFile = await _picker.getImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    File _image = File(pickedFile.path);
    return _image;
  } else {
    return null;
  }
}

getImageFromCamera() async {
  final _picker = ImagePicker();
  final pickedFile = await _picker.getImage(source: ImageSource.camera);
  if (pickedFile != null) {
    File _image = File(pickedFile.path);
    return _image;
  } else {
    return null;
  }
}

Future cropImage({File image, var aspectRatios}) async {
  File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      compressQuality: 30,
      aspectRatioPresets: aspectRatios == null
          ? Platform.isAndroid
              ? [
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio16x9,
                ]
              : [
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio5x3,
                  CropAspectRatioPreset.ratio5x4,
                  CropAspectRatioPreset.ratio7x5,
                  CropAspectRatioPreset.ratio16x9,
                  CropAspectRatioPreset.ratio16x9
                ]
          : aspectRatios,
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        title: 'Cropper',
      ));
  return croppedFile;
}

// Upload(File imageFile) async {
//   var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
//   var length = await imageFile.length();
//
//   var uri = Uri.parse(uploadURL);
//
//   var request = new http.MultipartRequest("POST", uri);
//   var multipartFile = new http.MultipartFile('file', stream, length,
//       filename: basename(imageFile.path));
//   //contentType: new MediaType('image', 'png'));
//
//   request.files.add(multipartFile);
//   var response = await request.send();
//   print(response.statusCode);
//   response.stream.transform(utf8.decoder).listen((value) {
//     print(value);
//   });
// }

//use this ratio for specific size images

// Platform.isAndroid
// ? [
// CropAspectRatioPreset.square,
// CropAspectRatioPreset.ratio3x2,
// CropAspectRatioPreset.original,
// CropAspectRatioPreset.ratio4x3,
// CropAspectRatioPreset.ratio16x9,
// ]
// : [
// CropAspectRatioPreset.original,
// CropAspectRatioPreset.square,
// CropAspectRatioPreset.ratio3x2,
// CropAspectRatioPreset.ratio4x3,
// CropAspectRatioPreset.ratio5x3,
// CropAspectRatioPreset.ratio5x4,
// CropAspectRatioPreset.ratio7x5,
// CropAspectRatioPreset.ratio16x9,
// CropAspectRatioPreset.ratio16x9
// ],
