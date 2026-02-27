import 'package:flutter/material.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';
import 'package:pix_hunt_project/core/typedefs/typedefs.dart';

class CustomListTileWidget extends StatelessWidget {
  const CustomListTileWidget({
    super.key,
    required this.leading,
    required this.onTap,
    required this.title,
    this.color,
    this.disableTrailing,
  });
  final IconData leading;
  final String title;
  final OnPressed onTap;
  final Color? color;
  final bool? disableTrailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: ConstantColors.appColor,

        child: Icon(leading, color: Colors.white),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          // fontWeight: (color != null) ? FontWeight.bold : null,
        ),
      ),
      trailing:
          (disableTrailing ?? false)
              ? SizedBox()
              : const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
