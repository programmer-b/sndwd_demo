import 'package:flutter/material.dart';

class MyProvider extends ChangeNotifier {
  dynamic _data;
  dynamic get data => _data;

  void updateData(data) {
    _data = data;
    notifyListeners();
  }
}
