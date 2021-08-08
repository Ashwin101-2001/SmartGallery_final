import 'dart:io';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'Firebase/Database.dart';
import 'package:smart_gallery/searchForm.dart';
import 'ImageCard.dart';
import 'Utilities/functions.dart';

class Gallery extends StatefulWidget {
  List<AssetEntity> assets;
  String search;

  bool backToGallery;

  Gallery.back(this.backToGallery);

  Gallery([this.search]);

  @override
  _GalleryState createState() {
    if (backToGallery != null)
      return _GalleryState.back(backToGallery);
    else
      return _GalleryState(search);
  }
}

class _GalleryState extends State<Gallery> {
  _GalleryState([this.search]);

  _GalleryState.back(this.backToGallery);

  bool backToGallery;
  String search;
  List<AssetEntity> assets;

  bool loading = true;
  ScrollController scrollController = ScrollController();
  int crossAxisCount = 3;
  double scale = 1;
  List<AssetEntity> temp;
  bool loading1 = true;
  SmartService s = SmartService();
  Map<String, dynamic> map;

  @override
  void initState() {
    _fetchAssets();
    super.initState();
  }

  _fetchAssets() async {
    final albums = await PhotoManager.getAssetPathList(onlyAll: true);
    final recentAlbum = albums.first;
    map = await s.getsmartCollection();

    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0,
      end: 100000,
    );

    if (backToGallery == true)

      ///Coming back to gallery from view image
      setState(() {
        assets = getImageAssets(recentAssets);
        loading = false;
      }); //back don't classify

    if (search != null)

      ///  Search
      setState(() {
        assets = getAssetsForSearch(getImageAssets(recentAssets));
        loading = false;
      }); //back

    else {
      assets = getImageAssets(recentAssets);
      loading = false;

      classifyimages(getImageAssets(recentAssets));
      setState(() {
        loading1 = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading != true)
      return WillPopScope(
        onWillPop: () {
          return _onWillPop(context);
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            actions: <Widget>[
              Expanded(flex: 2, child: Container()),
              Expanded(
                child: MyCustomForm(map),
                flex: 36,
              ),
              Expanded(flex: 2, child: Container()),
            ],
          ),
          body: GestureDetector(
            child: Container(
              margin: EdgeInsets.only(left: 7.0, right: 7.0),
              padding: EdgeInsets.only(top: 20.0),
              color: Colors.black,
              child: DraggableScrollbar.rrect(
                controller: scrollController,
                alwaysVisibleScrollThumb: true,
                heightScrollThumb: 70,
                backgroundColor: Colors.blue[800],
                child: GridView.builder(
                  controller: scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 5.0,
                    crossAxisSpacing: 5.0,
                  ),
                  itemCount: assets.length,
                  itemBuilder: (_, index) {
                    return ImageCard(assets[index], map);
                  },
                ),
              ),
            ),
          ),
        ),
      );
    else {
      return WillPopScope(
        onWillPop: () {
          return _onWillPop(context);
        },
        child: Container(
          color: Colors.blue,
          child: Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          ),
        ),
      );
    }
  }

  void classifyimages(List<AssetEntity> assets) async {

    File img;
    int i = 0;
    int count = 10;
    //if(!my.containsKey("First"))   //first time
    //count=cc;

    for (AssetEntity a in assets) {
      if (!map.containsKey(a.id)) {
        if (i > count)
          break;
        else {
          img = await a.file;
          print("$i");
          print("${a.id}");
          print("${a.title}    :  ${a.relativePath} ");
          await uploadImageToServer(img);
          print("");
        }
        i++;
      }
    }
  }

  //
  List<AssetEntity> getAssetsForSearch(assetlist) {
    List<AssetEntity> y = List<AssetEntity>();
    for (AssetEntity a in assetlist) {
      if (map.containsKey(a.id)) {
        List<String> s = map[a.id].split(",");
        for (int i = 0; i < s.length; i++) {
          s[i] = s[i].replaceAll(" ", "");
        }

        if (s.contains("$search")) y.add(a);
      }
    }

    return y;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _onWillPop(BuildContext context) {
    if (temp == null) {
      return showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.black,
              title: Text(
                'Are you sure?',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              content: Text(
                'Do you want to exit App ?',
                style: TextStyle(color: Colors.white70),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => exit(0),
                  /*Navigator.of(context).pop(true)*/
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          ) ??
          false;
    } else
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Gallery.back(true)));
  }
}
