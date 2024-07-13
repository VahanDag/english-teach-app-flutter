// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:teach_app/core/shadow_border_constant.dart';

Widget customContainer({
  required Widget child,
  Color? color,
  BorderRadius? borderRadius,
  double? height,
  double? width,
  EdgeInsetsGeometry? margin,
  AlignmentGeometry? alignmentGeometry,
  Gradient? gradient,
  Clip? clipBehavior,
  EdgeInsets? padding,
  BoxShape? shape,
  required BuildContext context,
}) {
  return Container(
    alignment: alignmentGeometry,
    margin: margin,
    height: height,
    padding: padding,
    width: width,
    clipBehavior: clipBehavior ?? Clip.none,
    decoration: BoxDecoration(
        gradient: gradient,
        shape: shape ?? BoxShape.rectangle,
        color: color ?? Colors.white,
        borderRadius: borderRadius,
        border: ShadowAndBorderConstant.getBorder(),
        boxShadow: ShadowAndBorderConstant.getShadows()),
    child: child,
  );
}
