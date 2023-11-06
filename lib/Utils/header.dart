import 'package:attedance/Pages/splash_two.dart';
import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final screenWidth;
  // ignore: prefer_typing_uninitialized_variables
  final screenHeight;
  final bool isStud;
  const Header({required this.screenHeight, required this.screenWidth,required this.isStud,});

  @override
  // ignore: library_private_types_in_public_api
  _HeaderState createState() =>
      // ignore: no_logic_in_create_state
      _HeaderState(screenWidth: screenWidth, screenHeight: screenHeight);
}

class _HeaderState extends State<Header> {
  // ignore: prefer_typing_uninitialized_variables
  final screenWidth;
  // ignore: prefer_typing_uninitialized_variables
  final screenHeight;
  

  _HeaderState({required this.screenWidth, required this.screenHeight});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/Ellipse header.png'), // Replace with your image asset
              alignment:
                  FractionalOffset(0.4, 0.0), // Move the image to the right
              fit: BoxFit.fitWidth, // You can adjust the fit property as needed
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                SizedBox(
                  width: screenWidth * 0.02,
                  height: screenHeight * 0.11,
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Splash()));
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          "assets/images/Ellipse 2.png",
                          width: screenWidth * 0.17,
                          height: screenWidth * 0.17,
                        ),
                        Hero(
                          tag: 'logo',
                          child: Image.asset(
                            "assets/images/new logo 1.png",
                            width: screenWidth * 0.12,
                            height: screenWidth * 0.12,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  "Attendance Go",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'postnobillbold',
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      decoration: TextDecoration.none),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
