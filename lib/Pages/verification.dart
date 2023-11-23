// ignore_for_file: avoid_print

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slider_button/slider_button.dart';

class MyPage extends StatefulWidget {
  final bool attendance;
  final int num1;
  final int num2;
  final int num3;
  final int timer;
  final int res;
  final String username;
  final String code;
  const MyPage({
    Key? key,
    required this.attendance,
    required this.num1,
    required this.num2,
    required this.num3,
    required this.timer,
    required this.res,
    required this.username,
    required this.code,
  }) : super(key: key);

  @override
  State<MyPage> createState() =>
      _MyPageState(attendance, num1, num2, num3, res, timer, username, code);
}

class _MyPageState extends State<MyPage> {
  bool clickA = false;
  bool clickB = false;
  bool clickC = false;
  final bool attendance;
  final int num1;
  final int num2;
  final int num3;
  final int _timer;
  final int res;
  final String username;
  final String code;
  int val = 0;
  final Stopwatch stopwatch = Stopwatch()..start();
  String formattedTime = '00:00:00';

  _MyPageState(this.attendance, this.num1, this.num2, this.num3, this.res,
      this._timer, this.username, this.code);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateTimer();
    Timer(Duration(seconds: _timer), () {
      Navigator.pop(context);
    });
  }

  void updateTimer() {
    setState(() {
      final minutes = stopwatch.elapsed.inMinutes;
      final seconds = stopwatch.elapsed.inSeconds.remainder(60);
      final microseconds = stopwatch.elapsedMicroseconds.remainder(1000000);

      formattedTime =
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${microseconds.toString().padLeft(2, '0')}';

      Future.delayed(Duration(milliseconds: 100), updateTimer);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color.fromARGB(87, 126, 120, 120),
        body: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: screenWidth,
                  child: Image.asset(
                    'assets/images/Eclipse 1.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.03,
                  child: Image.asset(
                    "assets/images/Ellipse 2.png",
                    width: screenWidth * 0.35,
                    height: screenWidth * 0.35,
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.03,
                  child: Hero(
                    tag: 'logo',
                    child: Image.asset(
                      "assets/images/new logo 1.png",
                      width: screenWidth * 0.5,
                      height: screenWidth * 0.5,
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.27,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Attendance',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'postnobillbold',
                            fontSize: 40),
                      ),
                      SizedBox(
                        width: screenWidth * 0.02,
                      ),
                      const Text(
                        'GO',
                        style: TextStyle(
                            color: Colors.blue,
                            fontFamily: 'postnobillbold',
                            fontSize: 40),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "$formattedTime",
                            style: TextStyle(color: Colors.white),
                          ),
                        )))
              ],
            ),
            SizedBox(
              height: screenHeight * 0.04,
            ),
            const Text(
              'Select the correct number',
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontFamily: 'poppinsBold',
                  fontSize: 24),
            ),
            SizedBox(
              height: screenHeight * 0.04,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      clickA = true;
                      clickB = false;
                      clickC = false;
                      val = num1;
                    });
                  },
                  child: Container(
                      alignment: Alignment.center,
                      height: screenHeight * 0.17,
                      width: screenHeight * 0.17,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(161, 68, 68, 68),
                          border: clickA
                              ? Border.all(color: Colors.blue, width: 4)
                              : Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(100)),
                      child: Text(
                        '$num1',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontFamily: 'poppinsBold',
                            fontSize: 60),
                      )),
                ),
                SizedBox(
                  width: screenWidth * 0.08,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      clickA = false;
                      clickB = true;
                      clickC = false;
                      val = num2;
                    });
                  },
                  child: Container(
                      alignment: Alignment.center,
                      height: screenHeight * 0.17,
                      width: screenHeight * 0.17,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(161, 68, 68, 68),
                          border: clickB
                              ? Border.all(color: Colors.blue, width: 4)
                              : Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(100)),
                      child: Text(
                        '$num2',
                        style:const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontFamily: 'poppinsBold',
                            fontSize: 60),
                      )),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                setState(() {
                  clickA = false;
                  clickB = false;
                  clickC = true;
                  val = num3;
                });
              },
              child: Container(
                  alignment: Alignment.center,
                  height: screenHeight * 0.17,
                  width: screenHeight * 0.17,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(161, 68, 68, 68),
                      border: clickC
                          ? Border.all(color: Colors.blue, width: 4)
                          : Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(100)),
                  child: Text(
                    '$num3',
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontFamily: 'poppinsBold',
                        fontSize: 60),
                  )),
            ),
            SizedBox(height: screenHeight * 0.045),
            Center(
                child: SliderButton(
                    buttonColor: Color.fromARGB(255, 0, 0, 0),
                    backgroundColor: Color.fromARGB(97, 255, 255, 255),
                    width: screenWidth * 0.85,
                    action: () {
                      check();

                      ///Do something here

                      // Navigator.of(context).pop();
                    },
                    label: const Text(
                      " Slide to Mark Attendance ",
                      style: TextStyle(
                          color: Color(0xff4a4a4a),
                          fontWeight: FontWeight.w500,
                          fontSize: 17),
                    ),
                    icon: Icon(CupertinoIcons.chevron_forward,
                        color: Colors.white, size: 35)))
          ],
        ));
  }

  void check() async {
    DateTime now = DateTime.now();
    String date =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    DatabaseReference dataStud =
        FirebaseDatabase.instance.ref().child('student');

    DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref().child('course_codes');

    String fname;
    String lname;

    int present;
    int absent;

    DataSnapshot dataSnapshot;
    DataSnapshot snapshot;

    await dataStud
        .child(username)
        .once()
        .then((DatabaseEvent databaseEvent) async {
      dataSnapshot = databaseEvent.snapshot;

      Map<dynamic, dynamic>? data = dataSnapshot.value as Map?;
      if (data != null) {
        fname = data['firstName'];
        lname = data['lastName'];

        if (res == val) {
          print("Done");
          databaseRef
              .child(code)
              .child('Stud_att')
              .child(date)
              .update({"date": date});
          databaseRef
              .child(code)
              .child('Stud_att')
              .child(date)
              .child('Present')
              .child(username)
              .update({
            "EnrollmentNo": username,
            "FirstName": fname,
            "LastName": lname,
            'status': 'Present',
          });

          databaseRef
              .child(code)
              .child('Stud_Ratio')
              .child(username)
              .once()
              .then((DatabaseEvent dataEvent) async {
            snapshot = dataEvent.snapshot;

            if (snapshot.value != null && snapshot.exists) {
              // Data is present
              Map<dynamic, dynamic>? studInfo = snapshot.value as Map?;
              present = studInfo?['Present'] ?? 0;
              absent = studInfo?['Absent'] ?? 0;
              print("Entered");
            } else {
              // Data is not present
              present = 1;
              absent = 0;
              print("Closed");
            }

            // Update the data
            databaseRef.child(code).child('Stud_Ratio').child(username).update({
              'Present': present + 1,
              'Absent': absent,
            });
          });

          Navigator.pop(context);
        } else {
          databaseRef
              .child(code)
              .child('Stud_att')
              .child(date)
              .update({"date": date});
          databaseRef
              .child(code)
              .child('Stud_att')
              .child(date)
              .child('Absent')
              .child(username)
              .update({
            "EnrollmentNo": username,
            "FirstName": fname,
            "LastName": lname,
            'status': 'Absent',
          });

          databaseRef
              .child(code)
              .child('Stud_Ratio')
              .child(username)
              .once()
              .then((DatabaseEvent dataEvent) async {
            snapshot = dataEvent.snapshot;

            if (snapshot.value != null && snapshot.exists) {
              // Data is present
              Map<dynamic, dynamic>? studInfo = snapshot.value as Map?;
              present = studInfo?['Present'] ?? 0;
              absent = studInfo?['Absent'] ?? 0;
              print("Entered");
            } else {
              // Data is not present
              present = 0;
              absent = 1;
              print("Closed");
            }

            // Update the data
            databaseRef.child(code).child('Stud_Ratio').child(username).update({
              'Present': present,
              'Absent': absent + 1,
            });
          });
          print("false");
          Navigator.pop(context);
        }
      }
    });
  }
}
