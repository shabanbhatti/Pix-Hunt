import 'package:flutter/material.dart';

void openHalfBottomSheet(BuildContext context, {required Widget child}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(05)),
    ),
    builder: (context) {
      return FractionallySizedBox(heightFactor: 0.75, child: child);
    },
  );
}
