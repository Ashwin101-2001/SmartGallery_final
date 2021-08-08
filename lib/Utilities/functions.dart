


import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:path/path.dart';

import 'package:photo_manager/photo_manager.dart';


List<AssetEntity> getImageAssets(List<AssetEntity> a) {
  List<AssetEntity> x = List<AssetEntity>();
  for (AssetEntity asset in a) {
    if (asset.type == AssetType.image) x.add(asset);
  }
  return x;
}

uploadImageToServer(File imageFile) async {
  var stream =
      new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  var length = await imageFile.length();
  print(length);

  var uri = Uri.parse('http://192.168.43.230:5000');

  var request = new http.MultipartRequest("POST", uri);
  var multipartFile = new http.MultipartFile('file', stream, length,
      filename: basename(imageFile.path));

  request.files.add(multipartFile);
  var response = await request.send();
  print(response.statusCode);
}