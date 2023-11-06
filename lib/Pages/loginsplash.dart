// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:attedance/Pages/course.dart';
import 'package:attedance/Pages/courseteach.dart';

import 'package:attedance/Pages/splash_three.dart';
import 'package:attedance/Utils/customToast.dart';
import 'package:attedance/Utils/threeroatingdot.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginsplash extends StatefulWidget {
  final controller;

  final updateVisibility;
  const Loginsplash(
      {Key? key, required this.controller, required this.updateVisibility})
      : super(key: key);

  @override
  _LoginsplashState createState() =>
      _LoginsplashState(controller, updateVisibility);
}

class _LoginsplashState extends State<Loginsplash>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String name = '';
  String studname = '';
  late String password;
  late String fname;
  late String lname;
  late bool approved;
  String storedPassword = '';
  String storedName = '';
  bool show = false;
  bool isStud = false;
  final controller;
  final updateVisibility;
  _LoginsplashState(this.controller, this.updateVisibility);
  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 250), () {
      setState(() {
        show = true;
      });
    });

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    getValidationData().whenComplete(() => {
          print(isStud),
          if (isStud)
            {
              retriveData().whenComplete(() => {
                    if (studname == storedName)
                      {
                        if (password == storedPassword)
                          {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudCourse(
                                  name: '$fname $lname',
                                  username: name,
                                ),
                              ),
                            )
                          }
                        else
                          {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => SplashNew(
                                  controller: controller,
                                  updateVisibility: updateVisibility),
                            ))
                          }
                      }
                    else
                      {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => SplashNew(
                              controller: controller,
                              updateVisibility: updateVisibility),
                        ))
                      }
                  })
            }
          else
            {
              retriveTeachData().whenComplete(() {
                if (studname == storedName) {
                  if (password == storedPassword) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TeachCourse(
                            name: '$fname $lname',
                            username: name,
                            approved: approved),
                      ),
                    );
                  } else {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => SplashNew(
                          controller: controller,
                          updateVisibility: updateVisibility),
                    ));
                  }
                } else {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => SplashNew(
                        controller: controller,
                        updateVisibility: updateVisibility),
                  ));
                }
              })
            }
        });
  }

  retriveData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    setState(() {
      name = sharedPreferences.getString('studentId').toString();
    });
    DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref().child('student');
    // print("Hello");

    DataSnapshot userSnapshot;
    // Check if the user already exists in the database
    await databaseRef
        .child(name)
        .once()
        .then((DatabaseEvent databaseEvent) async {
      userSnapshot = databaseEvent.snapshot;
      // print(userSnapshot);
      if (userSnapshot.value != null) {
        Map<dynamic, dynamic>? userData = userSnapshot.value as Map?;
        if (userData != null && userData.containsKey('Password')) {
          setState(() {
            storedPassword = userData['Password'].toString();
            storedName = userData['studentId'].toString();
          });
        }
      }
    });
  }

  retriveTeachData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    setState(() {
      name = sharedPreferences.getString('username').toString();
    });
    DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref().child('teacher');
    // print("Hello");

    DataSnapshot userSnapshot;
    // Check if the user already exists in the database
    await databaseRef
        .child(name)
        .once()
        .then((DatabaseEvent databaseEvent) async {
      userSnapshot = databaseEvent.snapshot;
      // print(userSnapshot);
      if (userSnapshot.value != null) {
        Map<dynamic, dynamic>? userData = userSnapshot.value as Map?;
        if (userData != null && userData.containsKey('Password')) {
          setState(() {
            storedPassword = userData['Password'].toString();
            storedName = userData['studentId'].toString();
          });
        }
      }
    });
  }

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    setState(() {
      studname = sharedPreferences.getString('studentId').toString();
      isStud = sharedPreferences.getBool('isStud') ?? false;
      approved = sharedPreferences.getBool('approved') ?? false;
      name = sharedPreferences.getString('username').toString();
      password = sharedPreferences.getString('password').toString();
      fname = sharedPreferences.getString('firstName').toString();
      lname = sharedPreferences.getString('lastName').toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: screenHeight * 0.9,
        color: Colors.black,
        child: Column(children: [
          Container(
            alignment: Alignment.center,
            color: Colors.black,
            height: screenHeight * 0.8,
            child: Stack(
              alignment: Alignment.center,
              children: [
                FractionalTranslation(
                  translation:
                      const Offset(0.0, 0.0), // Move the first image up
                  child: Container(
                    width: screenWidth * 0.8, // Adjust as needed
                    height: screenWidth * 0.8, // Adjust as needed
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/Ellipse 2.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Hero(
                  tag: 'logo',
                  child: Image.asset(
                    "assets/images/logo 1.png",
                    width: screenWidth * 0.6, // Adjust as needed
                    height: screenWidth * 0.6, // Adjust as needed
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  height: screenHeight * 0.41,
                  width: screenWidth * 0.85, // Set the desired height here
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 5, // Adjust the thickness as needed
                    // Set the background color if desired
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the AnimationController
    super.dispose();
  }
}
