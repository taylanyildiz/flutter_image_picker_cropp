import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker_crop/image_picker.dart';
import 'package:image_picker_crop/pfoile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var imagesFile = <File>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImagePicker(
            title: 'Flutter Select Photo',
            itemCount: 4,
            height: 120.0,
            backgroundColor: Colors.white,
            backgroundImage: Colors.orange,
            iconColor: Colors.white,
            iconEditColor: Colors.red,
            iconAddColor: Colors.white,
            selectionPhoto: (file) {
              imagesFile = file;
            },
          ),
          SizedBox(height: 20.0),
          SizedBox(
            width: 200.0,
            child: MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: Text(
                'Next Page',
                style: TextStyle(color: Colors.white, fontSize: 17.0),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PofileScreen(
                    imageFile: imagesFile,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
