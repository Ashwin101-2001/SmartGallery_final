import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SmartService {
  SmartService();

  // collection reference
  final CollectionReference smartCollection =
      FirebaseFirestore.instance.collection('Real');

  Future<void> updateData(Map<String, dynamic> map) async {
    bool x = await Check("r1");
    if (x)
      await smartCollection.doc("r1").update(map);
    else
      await smartCollection.doc("r1").set(map);
  }

  Future<void> setData(String id, Map<String, dynamic> map) async {
    await smartCollection.doc("r1").set(map);
  }

  Future<bool> Check(String id) async {
    print("a");
    QuerySnapshot x = await smartCollection.get();
    print("a");

    for (DocumentSnapshot a in x.docs) {
      if (a.id == id) return true;
    }

    return false;
  }

  Future<Map<String, dynamic>> getsmartCollection() async {
    DocumentSnapshot x = await smartCollection.doc("r1").get();
    Map<String, dynamic> map = Map<String, dynamic>();

    map = x.data();

    return map;
  }
}
