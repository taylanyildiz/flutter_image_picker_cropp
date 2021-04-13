import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

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
  List<File> imageFiles = [];

  Future _selectPhoto(context, index) async {
    final file = await Utils.pickMedia(
      isGallery: true,
      croppImage: cropContainImage,
    );
    if (file == null) return;
    setState(() {
      imageFiles.add(file);
    });
  }

  Future<File> cropContainImage(File imageFile) async {
    return await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 70,
      maxWidth: 100,
      maxHeight: 100,
      compressFormat: ImageCompressFormat.jpg,
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Movie Match',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: false,
      ),
    );
  }

  _imageContainer(context, index) {
    print(index);
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(10.0),
          width: 100,
          height: 200.0,
          color: Colors.red,
          child: imageFiles.isNotEmpty
              ? Image.file(
                  imageFiles[index],
                  fit: BoxFit.cover,
                )
              : Icon(Icons.image),
        ),
        Positioned(
          bottom: 0.0,
          right: 0.0,
          child: GestureDetector(
            onTap: () => _selectPhoto(context, index),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: Colors.black,
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) => _imageContainer(context, index),
            ),
          ),
        ],
      ),
    );
  }
}

class Utils {
  static Future<File> pickMedia({
    @required bool isGallery,
    Future<File> Function(File file) croppImage,
  }) async {
    final source = isGallery ? ImageSource.gallery : ImageSource.camera;
    final pickedFile = await ImagePicker().getImage(source: source);
    if (pickedFile == null) return null;
    if (croppImage == null)
      return File(pickedFile.path);
    else {
      final file = File(pickedFile.path);
      return croppImage(file);
    }
  }
}
