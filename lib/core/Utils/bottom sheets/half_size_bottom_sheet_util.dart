import 'package:flutter/material.dart';

void openHalfBottomSheet(
  BuildContext context, {
  required Widget child,
  double? size,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    enableDrag: false,
    isDismissible: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(05)),
    ),
    builder: (context) {
      return FractionallySizedBox(heightFactor: size ?? 0.75, child: child);
    },
  );
}
