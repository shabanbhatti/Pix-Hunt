import 'package:flutter/material.dart';

class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({super.key, required this.title});
final String title;
  @override
  Widget build(BuildContext context) {
    return  SliverAppBar(
          backgroundColor: Colors.indigo,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
          ),
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          floating: true,
          snap: true,
        );
  }
}