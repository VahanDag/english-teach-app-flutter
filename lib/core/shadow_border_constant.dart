import 'package:flutter/material.dart';

class ShadowAndBorderConstant {
  static List<BoxShadow> getShadows() {
    return [BoxShadow(offset: const Offset(2, 2), color: Colors.grey.shade700)];
  }

  static BoxBorder getBorder() {
    return Border.all(width: 2, color: Colors.grey.shade700);
  }

  // static BorderSide getBorderSide() {
  //   return const BorderSide(color: Colors.black);
  // }
}
