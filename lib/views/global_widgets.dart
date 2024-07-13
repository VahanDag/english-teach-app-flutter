import 'package:flutter/material.dart';
import 'package:teach_app/core/extensions.dart';

Card userHasNoLearnWord({required BuildContext context, required String text, String? text2, IconData? icon}) {
  return Card(
    child: SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            icon ?? Icons.satellite_alt_rounded,
            size: 40,
          ),
          Text(
            text,
            style: context.textTheme.titleMedium,
          ),
          Text(text2 ?? "çok garip..")
        ],
      ),
    ),
  );
}
