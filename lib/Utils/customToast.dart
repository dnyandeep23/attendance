// ignore: file_names
import 'package:flutter/material.dart';

class CustomToast extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final double screenwidth;

  CustomToast({ 
    required this.message,
    required this.screenwidth,
    this.backgroundColor = Colors.black54,
    this.textColor = Colors.white,
    this.fontSize = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        width: screenwidth * 0.9,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          message,
          style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.w400,
              fontFamily: 'postnobillbold'),
        ),
      ),
    );
  }
}
