import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';

class ReadDoc {
  static Map<String, dynamic> products ;
  static bool databaseIsNull = false;
  static bool error = false;

  static Future<bool> getData() async{
    print("@@hello");
    if (products == null){
      if(!(await refresh("category1"))||databaseIsNull){
        print("@@@false");
        return false;
      }
      else{
        print("@@@true");
        return true;
      }
    }
    return true;
  }
  static Future<bool> refresh(String category) async {
    print("@@refresh");
    try{
      await FirebaseFirestore.instance
          .collection('products')
          .doc(category)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          products = documentSnapshot.data();
          print('@@Document data: $products');
        } else {
          print('@@Document does not exist on the database');
          databaseIsNull = true;
        }
      });
      return true;
    }
    catch(e){
      print(e);
      error = true;
      return false;
    }
  }
}
