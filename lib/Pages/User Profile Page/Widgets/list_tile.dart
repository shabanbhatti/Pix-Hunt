import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.leading,
    required this.onTap,
    required this.title,
  });
  final IconData leading;
  final String title;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: Border(
        bottom: (title == 'Log out') ? BorderSide.none : BorderSide(width: 1, color:  Theme.of(context).primaryColor),
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.indigo,
        child: Icon(leading, color: Colors.white),
      ),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
