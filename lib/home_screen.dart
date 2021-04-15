import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:function_test/utils_image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  final String title;
  bool isGallery;
  IconData iconAdd;
  IconData iconEdit;
  Color backgroundColor;
  Color buttonColor;
  Color iconColor;
  double height;
  double width;
  final int itemCount;
  final Function selectionPhoto;
  AndroidUiSettings androidUiSettingsLock;
  IOSUiSettings iosUiSettings;
  HomeScreen({
    Key key,
    @required this.selectionPhoto,
    bool isGallery,
    this.title,
    IconData iconAdd,
    IconData iconEdit,
    Color backgroundColor,
    Color buttonColor,
    Color iconColor,
    double height,
    double width,
    this.itemCount,
    AndroidUiSettings androidUiSettingsLock,
    IOSUiSettings iosUiSettings,
  })  : backgroundColor = backgroundColor ?? Colors.white,
        buttonColor = buttonColor ?? Colors.blue,
        iconColor = iconColor ?? Colors.white,
        iconAdd = iconAdd ?? Icons.add,
        iconEdit = iconEdit ?? Icons.edit,
        height = height ?? 200.0,
        width = width ?? 100.0,
        isGallery = isGallery ?? true,
        androidUiSettingsLock = androidUiSettingsLock ??
            AndroidUiSettings(
              lockAspectRatio: false,
              toolbarTitle: 'Image Cropper',
              toolbarColor: Colors.orange,
              toolbarWidgetColor: Colors.white,
              activeControlsWidgetColor: Colors.white,
              hideBottomControls: true,
            ),
        iosUiSettings = iosUiSettings ??
            IOSUiSettings(
              minimumAspectRatio: 1.0,
            ),
        assert(itemCount >= 3),
        super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final imageFiles = <File>[];
  Future selectPhoto(index) async {
    final file = await UtilsImage.mediaPicker(
      isGallery: widget.isGallery,
      croppImage: croppImage,
    );
    if (file == null) return;
    if (imageFiles.length >= index) {
      imageFiles.removeAt(index - 1);
      setState(() => imageFiles.insert(index - 1, file));
    } else
      setState(() => imageFiles.add(file));
  }

  Future<File> croppImage(File file) async => await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        maxHeight: 100,
        maxWidth: 100,
        compressFormat: ImageCompressFormat.png,
        androidUiSettings: widget.androidUiSettingsLock,
        iosUiSettings: widget.iosUiSettings,
      );

  Future<List<Widget>> dispLayWidget() async {
    final displaylist = <Widget>[];
    Widget child;
    for (var index = 1; index <= widget.itemCount; index++) {
      if (imageFiles.length >= index) {
        child = Image.file(
          imageFiles[index - 1],
          fit: BoxFit.cover,
        );
      } else {
        child = Icon(
          Icons.image,
          color: Colors.red,
          size: 35.0,
        );
      }
      displaylist.add(
        Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              width: widget.width,
              height: widget.height,
              color: widget.backgroundColor,
              child: child,
            ),
            Positioned(
              right: 0.0,
              bottom: 0.0,
              child: GestureDetector(
                onTap: () => selectPhoto(index),
                child: Container(
                  padding: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    color: widget.buttonColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.iconAdd,
                    color: widget.iconColor,
                    size: 25.0,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
    return displaylist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 40.0, left: 20.0),
            child: widget.title != null
                ? Text(
                    widget.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : SizedBox.shrink(),
          ),
          FutureBuilder<List<Widget>>(
            future: dispLayWidget(),
            builder: (context, constraint) {
              if (constraint.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Wrap(
                    spacing: 10.0,
                    direction: Axis.horizontal,
                    children: constraint.data,
                  ),
                );
              } else {
                return Text('Error');
              }
            },
          ),
        ],
      ),
    );
  }
}
