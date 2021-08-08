import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'ImageDisplay.dart';

class ImageCard extends StatelessWidget {
  ImageCard(this.asset, this.map);

  final AssetEntity asset;
  Map<String, dynamic> map;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: asset.thumbData,
      builder: (_, snapshot) {
        final bytes = snapshot.data;

        if (bytes == null) return CircularProgressIndicator();
        if (asset.type == AssetType.image) {
          return InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return ImageScreen(asset.file, getTag());
                  },
                ),
              );
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.memory(bytes, fit: BoxFit.cover),
                ),
              ],
            ),
          );
        } else {
          return Container(width: 0.0, height: 0.0);
        }
      },
    );
  }

  String getTag() {
    List<String> list = map[asset.id].split(",");
    for (int i = 0; i < list.length; i++) {
      list[i] = list[i].replaceAll(" ", "");
    }
    list = list.toSet().toList();
    String s = "";
    for (String j in list) {
      s += "$j,";
    }
    return s.substring(0, s.length - 1);
  }
}
