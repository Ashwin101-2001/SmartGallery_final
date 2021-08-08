import 'dart:io';

import 'package:flutter/material.dart';

import 'Gallery.dart';

class ImageScreen extends StatelessWidget {
  ImageScreen(this.imageFile, this.x);

  final Future<File> imageFile;
  String x;

  Future<bool> _onWillPop(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => Gallery.back(true)));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return _onWillPop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text(
            x == null ? "Tags yet to be assigned" : x,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          )),
        ),
        body: Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: FutureBuilder<File>(
            future: imageFile,
            builder: (_, snapshot) {
              final file = snapshot.data;
              if (file == null) return Container();
              return Image.file(file);
            },
          ),
        ),
      ),
    );
  }
}
