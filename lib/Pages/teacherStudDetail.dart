import 'dart:async';
import 'dart:math';

import 'package:attedance/Pages/mapviewteach.dart';
import 'package:attedance/Pages/teachaddStud.dart';
import 'package:attedance/Pages/teachstudentdata.dart';
import 'package:attedance/Pages/teachverify.dart';
import 'package:attedance/Pages/verification.dart';
import 'package:attedance/Utils/drawer.dart';
import 'package:attedance/Utils/header.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TeachStudDetails extends StatefulWidget {
  final String code;
  final String name;
  final String username;
  final bool approved;
  final String courseName;
  const TeachStudDetails({
    Key? key,
    required this.code,
    required this.name,
    required this.username,
    required this.approved,
    required this.courseName,
  });

  @override
  // ignore: no_logic_in_create_state
  State<TeachStudDetails> createState() => AttendenceScreenState(
        code: code,
        name: name,
        username: username,
        approved: approved,
        courseName: courseName,
      );
}

class AttendenceScreenState extends State<TeachStudDetails> {
  // int items = 50;
  final bool approved;
  final String name;
  final String username;
  final String courseName;
  String code;
  List<String> enroll = [];
  List<String> fname = [];
  List<String> lname = [];
  AttendenceScreenState({
    Key? key,
    required this.code,
    required this.name,
    required this.username,
    required this.approved,
    required this.courseName,
  });

  @override
  void initState() {
    super.initState();
    retriveStudents();
  }

  double bottomSheetHeight = 0;
  void retriveStudents() async {
    print(code);
    DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref().child('course_codes');

    DataSnapshot dataSnapshot;
    await databaseRef
        .child(code)
        .child('student')
        .once()
        .then((DatabaseEvent databaseEvent) async {
      dataSnapshot = databaseEvent.snapshot;

      Map<dynamic, dynamic>? courseData = dataSnapshot.value as Map?;

      if (courseData != null) {
        enroll.clear();
        fname.clear();
        lname.clear();
        // ignore: avoid_print
        print(courseData);
        courseData.forEach((key, value) {
          if (value is Map) {
            setState(() {
              String studId = value['studentId'].toString();
              enroll.add(studId);
              String firstname = value['firstName'].toString();
              fname.add(firstname);
              String lastname = value['lastName'].toString();
              lname.add(lastname);
            });
          }
        });
      }
    });
  }

  void removeStud(String enrol, int index) async {
    DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref().child('course_codes');
    DatabaseReference studRef =
        FirebaseDatabase.instance.ref().child('student');
    DataSnapshot dataSnapshot;
    DataSnapshot studSnapshot;
    await databaseRef
        .child(code)
        .child('student')
        .once()
        .then((DatabaseEvent databaseEvent) async {
      dataSnapshot = databaseEvent.snapshot;

      Map<dynamic, dynamic>? studData = dataSnapshot.value as Map?;
      studData?.forEach((key, value) {
        if (value['studentId'] == enrol) {
          setState(() {
            enroll.removeAt(index);
            fname.removeAt(index);
            lname.removeAt(index);
          });
          databaseRef.child(code).child('student').child(enrol).remove();
        }
      });
    });

    await studRef
        .child(enrol)
        .child('course')
        .once()
        .then((DatabaseEvent databaseEvent) async {
      studSnapshot = databaseEvent.snapshot;

      print(username);
      print(enrol);
      print('${studSnapshot.value}');

      Map<dynamic, dynamic>? newData = studSnapshot.value as Map?;
      newData?.forEach((key, value) {
        if (value['courseCode'] == code) {
          studRef.child(enrol).child('course').child(code).remove();
        }
      });
    });
  }

  int generateRandomTwoDigitNumber() {
    final random = Random();
    return 10 +
        random.nextInt(90); // Generates a random number between 10 and 99
  }

  void allowAttendance() {
    int n1, n2, n3;

    // Generate unique two-digit numbers
    do {
      n1 = generateRandomTwoDigitNumber();
      n2 = generateRandomTwoDigitNumber();
      n3 = generateRandomTwoDigitNumber();
    } while (n1 == n2 || n1 == n3 || n2 == n3);

    final List<int> numbers = [n1, n2, n3];
    final Random random = Random();
    final int selectedIndex = random.nextInt(3); // Randomly selects 0, 1, or 2
    final int res = numbers[selectedIndex];

    DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref().child('course_codes');
    double sec = 15.0;
    databaseRef.child(code).update({
      'attendance': true,
      'timer': sec,
      'n1': n1,
      'n2': n2,
      'n3': n3,
      'res': res,
    });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Teachverify(code: code, res: res)));

    Timer(Duration(seconds: sec.toInt()), () {
      databaseRef.child(code).update({
        'attendance': false,
        'timer': 0,
        'n1': 0,
        'n2': 0,
        'n3': 0,
        'res': 0,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        body: Column(children: [
          Header(screenHeight: screenHeight, screenWidth: screenWidth,isStud:false),
          Stack(children: [
            Column(
              children: [
                Container(
                  // margin: const EdgeInsets.only(top: 50),
                  width: MediaQuery.of(context).size.width * .8,
                  height: MediaQuery.of(context).size.height * 0.06,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(120, 66, 65, 65),
                      border: Border.all(color: Colors.white)),

                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeachaddStud(
                                    code: code,
                                    courseName: courseName,
                                  ),
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color.fromARGB(200, 84, 83, 83),
                                ),
                                // height: screenHeight * 0.03,

                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Image.asset(
                                    'assets/images/add_stud.png',
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                        ),
                        const Text(
                          "   List of Students   ",
                          style: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        InkWell(
                          onTap: () {
                            retriveStudents();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromARGB(200, 84, 83, 83),
                              ),
                              // height: screenHeight * 0.03,

                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(
                                    CupertinoIcons.arrow_2_circlepath_circle,
                                    color: Colors.white,
                                    size: 30),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 0.75,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(120, 66, 65, 65),
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(20)),
                    child: enroll.length != 0
                        ? ListView.builder(
                            itemCount: enroll.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Teachstudentdata(
                                          enroll: enroll,
                                          fname: fname,
                                          lname: lname,
                                          index: index,
                                          code: code,
                                        ),
                                      ));
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  height:
                                      MediaQuery.of(context).size.height * 0.12,
                                  margin: const EdgeInsets.only(top: 10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 201, 203, 203),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Stack(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: screenWidth * 0.04,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 3,
                                              ),
                                              Text(
                                                enroll[index],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: screenWidth * 0.08,
                                                ),
                                              ),
                                              const SizedBox(height: 1),
                                              Text(
                                                "${fname[index]} ${lname[index]}",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: screenWidth * 0.05,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        top: -5,
                                        right: 0,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            removeStud(enroll[index], index);
                                          },
                                          style: ButtonStyle(
                                            alignment: Alignment.centerRight,
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    const Color(0xFF840808)),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                            ),
                                          ),
                                          child: const Text(
                                            "Remove",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            margin: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.32),
                            width: screenWidth * 0.8,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(141, 35, 34, 34),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white)),
                            child: const Center(
                              child: Text(
                                textAlign: TextAlign.center,
                                "Students are not intrested to join your course ....",
                                style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.none,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              child: SizedBox(
                width: screenWidth,
                child: Stack(children: [
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: screenWidth,
                      child: Image.asset('assets/images/Vector 2.png',
                          fit: BoxFit.fitWidth),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: screenHeight * 0.07,
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: screenWidth * 0.12,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  allowAttendance();
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => const MyPage()));
                                },
                                clipBehavior: Clip.antiAlias,
                                style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Colors.transparent),
                                  shape: MaterialStatePropertyAll(
                                      ContinuousRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)))),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4),
                                  child: Image.asset(
                                    'assets/images/attendance.png',
                                    height: screenHeight * 0.06,
                                  ),
                                )),
                            SizedBox(
                              width: screenWidth * 0.1,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MapViewTeach(
                                              name: name,
                                              username: username,
                                              code: code,
                                              approved: approved)));
                                },
                                clipBehavior: Clip.antiAlias,
                                style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Colors.transparent),
                                  shape: MaterialStatePropertyAll(
                                      ContinuousRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)))),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4),
                                  child: Image.asset(
                                    'assets/images/geofence.png',
                                    height: screenHeight * 0.06,
                                  ),
                                )),
                            SizedBox(
                                width: screenWidth * 0.12,
                                height: screenHeight * 0.1),
                          ],
                        ),
                      ),
                    ],
                  )
                ]),
              ),
            )
          ]),
        ]),
        drawer: MyDrawer(isteach: approved, student: false, username: username));
  }
}
