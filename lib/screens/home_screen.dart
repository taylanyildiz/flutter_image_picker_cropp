import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({Key key, this.title}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var imagesFile = <File>[];
  Future selectPhoto(index) async {
    final file = await UtilsImage.imagePicker(
      sourceCode: SourceCode.gallery,
      croppImage: croppImage,
    );
    if (file == null) return;
    if (imagesFile.length == (index + 1)) {
      imagesFile.removeAt(index);
      setState(() => imagesFile.insert(index, file));
    } else
      setState(() => imagesFile.add(file));
  }

  Future<File> croppImage(File imageFile) async {
    return await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      maxHeight: 100,
      maxWidth: 100,
      compressFormat: ImageCompressFormat.png,
      androidUiSettings: androidUiSettingsLock(),
      iosUiSettings: iosUiSettings(),
    );
  }

  AndroidUiSettings androidUiSettingsLock() {
    return AndroidUiSettings(
      lockAspectRatio: false,
      toolbarTitle: 'Image Cropper',
      toolbarColor: Colors.orange,
      toolbarWidgetColor: Colors.white,
      activeControlsWidgetColor: Colors.white,
      hideBottomControls: true,
    );
  }

  IOSUiSettings iosUiSettings() {
    return IOSUiSettings(
      minimumAspectRatio: 1.0,
    );
  }

  _controllerImageFile(contex, index) {
    if (imagesFile.isEmpty) return displayImageFile(context, index);
    return index == 0
        ? displayImageFile(context, index, img: imagesFile[0])
        : index == 1 && imagesFile.length > 1 && imagesFile[1] != null
            ? displayImageFile(context, index, img: imagesFile[1])
            : index == 2 && imagesFile.length > 2 && imagesFile[2] != null
                ? displayImageFile(context, index, img: imagesFile[2])
                : displayImageFile(context, index);
  }

  displayImageFile(context, index, {img}) {
    final child = img == null
        ? Icon(
            Icons.image,
            color: Colors.red,
            size: 35.0,
          )
        : Image.file(
            img,
            fit: BoxFit.cover,
          );
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(5.0),
          width: 100.0,
          height: double.infinity,
          color: Colors.blue.withOpacity(.6),
          child: child,
        ),
        Positioned(
          right: 0.0,
          bottom: 0.0,
          child: GestureDetector(
            onTap: () => selectPhoto(index),
            child: Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 150.0,
            color: Colors.orange,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) =>
                  _controllerImageFile(context, index),
            ),
          )
        ],
      ),
    );
  }
}

enum SourceCode {
  gallery,
  camera,
}

class UtilsImage {
  static Future<File> imagePicker({
    @required SourceCode sourceCode,
    @required Future<File> Function(File file) croppImage,
  }) async {
    final source = sourceCode == SourceCode.gallery
        ? ImageSource.gallery
        : ImageSource.camera;
    final pickerImage = await ImagePicker().getImage(source: source);
    if (pickerImage == null) return null;
    if (croppImage == null)
      return File(pickerImage.path);
    else
      return croppImage(File(pickerImage.path));
  }
}
