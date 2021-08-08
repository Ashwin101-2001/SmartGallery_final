

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


import 'Gallery.dart';

import 'Utilities/Loading.dart';


void main() {
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loading=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }
  void init ()async{
    await Firebase.initializeApp();
    setState(() {
      loading=false;
    });

  }
  @override
  Widget build(BuildContext context) {
    return loading==false?MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Gallery()
    ):Loader();
  }
}






