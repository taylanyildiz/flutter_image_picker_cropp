import 'dart:io';

import 'package:flutter/cupertino.dart';
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
  var imageFiles = <File>[];
  bool isGallery = false;

  Future _selectPhoto(index) async {
    final file = await Utils.pickMedia(
      isGallery: isGallery,
      cropImage: cropSquareImage,
    );
    if (file == null) return;
    if (imageFiles.length < 3)
      setState(() => imageFiles.add(file));
    else
      setState(() {
        imageFiles.removeAt(index);
        imageFiles.insert(index, file);
      });
  }

  Future<File> cropSquareImage(File imageFile) async {
    return await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 0.5, ratioY: .5),
      aspectRatioPresets: [CropAspectRatioPreset.square],
      compressQuality: 70,
      compressFormat: ImageCompressFormat.png,
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
      toolbarWidgetColor: Colors.red,
      hideBottomControls: true,
      cropFrameColor: Colors.red,
      activeControlsWidgetColor: Colors.red,
      lockAspectRatio: true,
    );
  }

  _displayPhoto(context, index) {
    if (imageFiles.isEmpty) return _imageContainer(context, index);
    if (imageFiles[0] != null) {
      return index == 0
          ? _imageContainer(context, index, images: imageFiles[0])
          : index == 1 && imageFiles.length > 1 && imageFiles[1] != null
              ? _imageContainer(context, index, images: imageFiles[1])
              : index == 2 && imageFiles.length > 2 && imageFiles[2] != null
                  ? _imageContainer(context, index, images: imageFiles[2])
                  : _imageContainer(context, index);
    }
  }

  _imageContainer(context, index, {File images}) {
    return Stack(
      children: [
        images == null
            ? Container(
                margin: EdgeInsets.all(5.0),
                width: 120,
                height: double.infinity,
                color: Colors.white,
                child: images != null
                    ? Image.file(
                        images,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.image,
                        color: Colors.red,
                      ),
              )
            : Container(
                margin: EdgeInsets.all(5.0),
                width: 120,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: images != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.file(
                          images,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.image,
                        color: Colors.red,
                      ),
              ),
        Positioned(
          bottom: 0.0,
          right: 0.0,
          child: GestureDetector(
            onTap: () async {
              await showCupertinoModalPopup(
                context: context,
                builder: (context) => CupertinoActionSheet(
                    actions: [
                      CupertinoActionSheetAction(
                        onPressed: () {
                          isGallery = true;
                          Navigator.pop(context);
                          _selectPhoto(index);
                        },
                        child: Text('Select a Photo'),
                        isDestructiveAction: true,
                      ),
                      CupertinoActionSheetAction(
                        onPressed: () {
                          isGallery = false;
                          Navigator.pop(context);
                          _selectPhoto(index);
                        },
                        child: Text('Take a Photo'),
                        isDestructiveAction: false,
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      child: Text('Çık'),
                      onPressed: () => Navigator.pop(context),
                    )),
              );
            },
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  images == null ? Icons.add : Icons.edit,
                  size: 20.0,
                  color: Colors.white,
                ),
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
                      _displayPhoto(context, index),
                ),
              ),
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
