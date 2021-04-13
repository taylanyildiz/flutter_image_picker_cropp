import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({
    Key key,
    this.title,
  }) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var imageFiles;

  Future _selectPhoto() async {
    final file = await Utils.pickMedia(
      isGallery: true,
      cropImage: cropSquareImage,
    );
    if (file == null) return;

    setState(() {
      imageFiles = file;
    });
  }

  Future<File> cropSquareImage(File imageFile) async {
    return await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      aspectRatioPresets: [CropAspectRatioPreset.square],
      compressQuality: 70,
      compressFormat: ImageCompressFormat.jpg,
      androidUiSettings: androidUiSettingsLock(),
      iosUiSettings: iosUiSettingsLock(),
    );
  }

  IOSUiSettings iosUiSettingsLock() {
    return IOSUiSettings(
      aspectRatioLockEnabled: true,
      rotateButtonsHidden: false,
      rectX: 1.0,
      rectY: 1.0,
      rotateClockwiseButtonHidden: false,
    );
  }

  AndroidUiSettings androidUiSettingsLock() {
    return AndroidUiSettings(
      toolbarColor: Colors.white,
      toolbarTitle: 'Cropp Image',
      toolbarWidgetColor: Colors.white,
      hideBottomControls: true,
    );
  }

  _imageContainer(context, index) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(5.0),
          width: 120,
          height: double.infinity,
          color: Colors.white,
          child: imageFiles != null
              ? Image.file(
                  imageFiles,
                  fit: BoxFit.cover,
                )
              : Icon(
                  Icons.image,
                  color: Colors.black,
                ),
        ),
        Positioned(
          bottom: 0.0,
          right: 0.0,
          child: GestureDetector(
            onTap: () => _selectPhoto(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(Icons.add),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(20.0, 200.0, 20.0, 40.0),
                child: Text(
                  'Select Profile Photo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 150.0,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 20.0),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, index) =>
                      _imageContainer(context, index),
                ),
              )
            ],
          ),
          Positioned(
            bottom: 40.0,
            child: SizedBox(
              width: 200.0,
              child: MaterialButton(
                onPressed: () => print('selected'),
                color: Colors.red,
                child: Text(
                  'Contiune',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Utils {
  static Future<File> pickMedia({
    @required bool isGallery,
    Future<File> Function(File file) cropImage,
  }) async {
    final source = isGallery ? ImageSource.gallery : ImageSource.camera;
    final pickedFile = await ImagePicker().getImage(source: source);
    if (pickedFile == null) return null;
    if (cropImage == null) {
      return File(pickedFile.path);
    } else {
      final file = File(pickedFile.path);
      return cropImage(file);
    }
  }
}
