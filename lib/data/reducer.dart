import 'package:flutter/material.dart';
import 'package:tree/data/userData.dart';

class Reducer with ChangeNotifier {
  User user;

  Reducer(this.user);

  void increment() {
    notifyListeners();
  }
}
