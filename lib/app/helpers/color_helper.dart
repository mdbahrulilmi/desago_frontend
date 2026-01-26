import 'package:flutter/material.dart';

class ColorHelper {
  static Color colorFromCategoryId(int id) {
    final colors = Colors.primaries;
    return colors[id % colors.length].shade400;
  }
}
