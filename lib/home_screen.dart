import 'package:flutter/material.dart';

import 'image_picker.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImagePicker(
            title: 'Flutter Select Photo',
            itemCount: 4,
            height: 120.0,
            selectionPhoto: (file) {
              print(file.length);
            },
            backgroundColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
