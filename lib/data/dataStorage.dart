// import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataStorage {
  final prefsKey = "carUser";

  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // var carUser = prefs.get(prefsKey);
  // if (carUser != null) {
  //   print("carUSer: " + carUser);
  // }

  saveUser(user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(prefsKey, user.toJson().toString());
  }

  // Future<Map<String, dynamic>>
  getUser() async {
    final prefs = await SharedPreferences.getInstance();
    var obj = await prefs.get(prefsKey);
    return obj;
  }
}
