import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class NewTemp extends StatefulWidget {
  const NewTemp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NewTempState createState() => _NewTempState();
}

class _NewTempState extends State<NewTemp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          RiveAnimation.asset(
            'assets/riv/bg.riv',
            fit: BoxFit.cover,
            alignment: FractionalOffset(0, 0),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 0,
                sigmaY:
                    5), // Adjust the sigma values for desired blur intensity
            child: Container(
              color:
                  Colors.transparent, // Make sure the container is transparent
            ),
          ),
        ],
      ),
    );
  }
}
