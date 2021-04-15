import 'dart:io';

import 'package:flutter/material.dart';

class PofileScreen extends StatefulWidget {
  final List<File> imageFile;

  const PofileScreen({
    Key key,
    this.imageFile,
  }) : super(key: key);

  @override
  _PofileScreenState createState() => _PofileScreenState();
}

class _PofileScreenState extends State<PofileScreen> {
  PageController controller;
  _displayPhoto(index) {
    return Image.file(
      widget.imageFile[index],
      fit: BoxFit.cover,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.red,
              height: 250,
              width: 300,
              child: PageView.builder(
                controller: controller,
                itemCount: widget.imageFile.length,
                itemBuilder: (context, index) => _displayPhoto(index),
              ),
            )
          ],
        ),
      ),
    );
  }
}
