import 'package:flutter/material.dart';

class HelperFunction {
  static Color? getColor(String value) {
    if (value == "Green") {
      return Colors.green;
    } else if (value == "Green") {
      return Colors.green;
    }else if (value == "Red") {
      return Colors.red;
    }else if (value == "Blue") {
      return Colors.blue;
    }else if (value == "Pink") {
      return Colors.pink;
    }else if (value == "Grey") {
      return Colors.grey;
    }else if (value == "Purple") {
      return Colors.purple;
    }else if (value == "Black") {
      return Colors.black;
    }else if (value == "Whit") {
      return Colors.white;
    }else if (value == "Yellow") {
      return Colors.yellow;
    }else if (value == "Orange") {
      return Colors.orange;
    }else if (value == "Brown") {
      return Colors.brown;
    }else if (value == "Teal") {
      return Colors.teal;
    }
    return null;
  }
}
