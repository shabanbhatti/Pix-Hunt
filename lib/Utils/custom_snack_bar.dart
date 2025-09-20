import 'package:flutter/material.dart';

void snackbar(BuildContext context,String title,{Color color=Colors.green,Duration duration= const Duration(seconds: 2)}){

ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title), backgroundColor: color,duration: duration,));

}