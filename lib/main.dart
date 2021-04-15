import 'package:flutter/material.dart';
import 'package:function_test/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Image Pickker and Image Cropper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(
        title: 'Flutter Select Photo',
        itemCount: 4,
        height: 120.0,
      ),
    );
  }
}
