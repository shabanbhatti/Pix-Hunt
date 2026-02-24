import 'package:flutter/material.dart';
import 'package:pix_hunt_project/core/constants/constant_colors.dart';
import 'package:pix_hunt_project/core/typedefs/typedefs.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.leading,
    required this.onTap,
    required this.title,
  });
  final IconData leading;
  final String title;
  final OnPressed onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: ConstantColors.appColor,

        child: Icon(leading, color: Colors.white),
      ),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
