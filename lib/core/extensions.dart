import 'package:flutter/material.dart';
import 'package:teach_app/core/enums.dart';

extension ContextExtension on BuildContext {
  double get deviceWidth => MediaQuery.of(this).size.width;
  double get deviceHeight => MediaQuery.of(this).size.height;
  TextTheme get textTheme => Theme.of(this).textTheme;
}

extension TopicsImageExtension on TopicsImage {
  String get image => 'assets/images/topics/$name.png';
}
