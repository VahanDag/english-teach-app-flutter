import 'package:flutter/material.dart';
import 'package:teach_app/core/extensions.dart';
import 'package:teach_app/core/paddings_borders.dart';

dynamic customBottomSheet(
    {required BuildContext context, required Widget widget, required String text, required double size}) {
  return showModalBottomSheet(
    shape: const RoundedRectangleBorder(borderRadius: BorderRadiusConstant.borderRadiusSheet),
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
            margin: PaddingConstant.paddingAllLow,
            height: context.deviceHeight * size,
            child: Column(
              children: [
                Divider(indent: context.deviceWidth * 0.35, endIndent: context.deviceWidth * 0.35, thickness: 3),
                const SizedBox(height: 10),
                Text(
                  text.toUpperCase(),
                  style: context.textTheme.headlineSmall
                      ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: widget,
                ),
              ],
            )),
      );
    },
  );
}
