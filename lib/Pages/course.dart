// ignore_for_file: avoid_print

import 'dart:ui';

import 'package:attedance/Pages/mapview.dart';
import 'package:attedance/Utils/customToast.dart';
import 'package:attedance/Utils/drawer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

// import 'package:background_locator/background_locator.dart';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../Utils/header.dart';

class StudCourse extends StatefulWidget {
  final String name; // Declare the variable as final
  final String username; // Declare the variable as final

  const StudCourse({Key? key, required this.name, required this.username})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StudCourse> createState() =>
      _StudCourseState(name: name, username: username);
}

class _StudCourseState extends State<StudCourse> {
  final String name; // Declare the variable as final
  final String username; // Declare the variable as final
  bool err = false;
  String message = '';
  bool click = false;

  _StudCourseState({required this.name, required this.username});

  List<String> course = [];
  List<String> coursecodes = [];

  final GlobalKey<FormState> _studCourse = GlobalKey<FormState>();
  final TextEditingController courseCode = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    // Start background location tracking when the widget initializes
    // startBackgroundLocator();
    setState(() {
      coursesRetrival();
    });
    print('Courses : $course');
  }

  void showSnack() {
    scaffoldMessengerKey.currentState?.showSnackBar(
      const SnackBar(
        content: Text('message'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  coursesRetrival() async {
    DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref().child('student');

    DataSnapshot dataSnapshot;
    // Check if the user already exists in the database
    await databaseRef
        .child(username)
        .child('course')
        .once()
        .then((DatabaseEvent databaseEvent) async {
      dataSnapshot = databaseEvent.snapshot;

      print(dataSnapshot.toString());

      Map<dynamic, dynamic>? courseData = dataSnapshot.value as Map?;
      List<String> existingCourseCodes = [];
      List<String> existingCourseName = [];

      if (courseData != null) {
        courseData.forEach((key, value) {
          print(value);
          if (value is Map) {
            String courseCode = value['courseCode'].toString();
            existingCourseCodes.add(courseCode);
            String courseName = value['courseName'].toString();
            existingCourseName.add(courseName);
          }
        });

        setState(() {
          course = existingCourseName;
          coursecodes = existingCourseCodes;
        });
        print('Courses : $course');
      }
    });
  }

  void showCustomToast(
      BuildContext context, String message, double screenWidth) {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Positioned(
          bottom: MediaQuery.of(context).size.height * 0.04,
          left: MediaQuery.of(context).size.width * 0.02,
          right: MediaQuery.of(context).size.width * 0.02,
          child: Center(
            child: CustomToast(
              screenwidth: screenWidth,
              message: message,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
            ),
          ),
        );
      },
    );

    overlayState.insert(overlayEntry);

    // After a delay, remove the custom toast
    Future.delayed(const Duration(seconds: 5), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldMessengerKey,
      backgroundColor: Colors.transparent,
      body: Column(children: [
        Header(screenHeight: screenHeight, screenWidth: screenWidth,isStud: true),
        Expanded(
          child: SingleChildScrollView(
            child: SizedBox(
              width: screenWidth,
              height: screenHeight * 0.88,
              child: Stack(alignment: Alignment.center, children: [
                const RiveAnimation.asset(
                  'assets/riv/bg.riv',
                  fit: BoxFit.cover,
                  alignment: FractionalOffset(0, 0),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: 20,
                      sigmaY:
                          20), // Adjust the sigma values for desired blur intensity
                  child: Container(
                    color: Colors
                        .transparent, // Make sure the container is transparent
                  ),
                ),
                Container(
                  width: screenWidth * 0.95,
                  height: screenHeight * 0.82,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromARGB(13, 217, 217, 217),
                      border: Border.all(color: Colors.white)),
                  child: Column(children: [
                    Row(
                      children: [
                        SizedBox(
                          width: screenWidth * 0.05,
                          height: screenHeight * 0.05,
                        ),
                        Container(
                          width: screenWidth * 0.52,
                          // height: screenHeight * 0.07,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: screenHeight * 0.005,
                              ),
                              const Text(
                                'Welcome,',
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xffffffff),
                                  fontFamily: 'poppinsBold',
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '$name',
                                    style: const TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xffffffff),
                                      fontFamily: 'poppinsBold',
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            coursesRetrival();
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: screenWidth * 0.15),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/Ellipse 5.png',
                                  width: screenWidth * 0.09,
                                ),
                                Image.asset(
                                  'assets/images/refresh.png',
                                  width: screenWidth * 0.07,
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _showDialougue(screenHeight, screenWidth);
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: screenWidth * 0.02),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/Ellipse 5.png',
                                  width: screenWidth * 0.09,
                                ),
                                Image.asset(
                                  'assets/images/plus.png',
                                  width: screenWidth * 0.07,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.005,
                    ),
                    Container(
                      width: screenWidth,
                      height: screenHeight * 0.745,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(40, 126, 120, 120),
                          border: const Border.fromBorderSide(BorderSide(
                              style: BorderStyle.solid,
                              color: Colors.white60))),
                      child: ListWheelScrollView(
                        itemExtent: screenHeight * 0.25,
                        diameterRatio: 4.5,
                        // offAxisFraction: -0.6,
                        children: List<Widget>.generate(course.length, (index) {
                          if (course.isNotEmpty) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MapViewWidget(
                                      name: name,
                                      username: username,
                                      code: coursecodes[index],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: screenWidth * 0.9,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(66, 255, 255, 255),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                child: Center(
                                  child: Text(
                                    course[index],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const Center(
                              child: Text(
                                "You have not created a course yet...",
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }
                        }),
                        // child: ,
                      ),
                    )
                  ]),
                ),
              ]),
            ),
          ),
        ),
      ]),
      drawer: MyDrawer(isteach: false, student: true, username: username,),
    );
  }

  _showDialougue(double screenHeight, double screenWidth) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AnimatedContainer(
            duration: const Duration(seconds: 1),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: const BorderSide(color: Colors.grey, width: 1.0),
              ),
              backgroundColor: const Color.fromARGB(150, 0, 0, 0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    const Text(
                      'Create a Course',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'poppinsBold',
                          fontSize: 20),
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    const Divider(
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    Form(
                      key: _studCourse,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: courseCode,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Course name is required';
                                } else if (!RegExp(r'^[a-zA-Z0-9]+$')
                                    .hasMatch(value)) {
                                  return 'Only letters are allowed';
                                } else {
                                  return null; // No validation error
                                }
                              },
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 6.0, horizontal: 20),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(221, 255, 255, 255)),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(221, 255, 255, 255)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  labelText: 'Course Code',
                                  labelStyle: TextStyle(
                                    textBaseline: TextBaseline.alphabetic,
                                    color: Colors.white,
                                    // fontFamily: 'poppinsBold',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  )),
                              cursorColor: Colors.white,
                              cursorHeight: 20,
                              style: const TextStyle(
                                textBaseline: TextBaseline.alphabetic,
                                color: Colors.white,
                                fontFamily: 'poppinsBold',
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: screenHeight * 0.02,
                            ),
                            // err
                            //     ? Text(
                            //         message,
                            //         style: const TextStyle(
                            //             color: Colors.red,
                            //             fontFamily: 'poppinsBold',
                            //             fontSize: 14),
                            //       )
                            //     : const Text(
                            //         '',
                            //         style: TextStyle(
                            //             color:
                            //                 Color.fromARGB(255, 255, 254, 254),
                            //             fontFamily: 'poppinsBold',
                            //             fontSize: 14),
                            //       ),
                            // err
                            //     ? SizedBox(height: screenHeight * 0.035)
                            //     : const SizedBox(),
                            ElevatedButton(
                              onPressed: () {
                                if (_studCourse.currentState!.validate()) {
                                  // Course name is valid, proceed to generate code
                                  setState(() {
                                    click = true;
                                    _storeInDatabase();
                                  });
                                }

                                Navigator.pop(context);
                                err
                                    ? showCustomToast(
                                        context, message, screenWidth)
                                    : null;
                              },
                              style: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.white)),
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'poppinsBold',
                                    fontSize: 20),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  _storeInDatabase() async {
    String code = courseCode.text.toUpperCase();
    DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref().child('course_codes');

    DatabaseReference studentRef =
        FirebaseDatabase.instance.ref().child('student');
    // print("Hello");

    DataSnapshot courseSnap;
    // Check if the user already exists in the database
    await databaseRef.once().then((DatabaseEvent databaseEvent) async {
      courseSnap = databaseEvent.snapshot;
      print(courseSnap.value);

      String myname = name.toString();
      if (courseSnap.value != null) {
        Map<dynamic, dynamic>? courseData = courseSnap.value as Map?;
        List<String> existingCourseCodes = [];
        List<String> existingCourseName = [];
        List<String> name = myname.split(' ');
        String first = name[0];
        String last = name[1];

        if (courseData != null) {
          courseData.forEach((key, value) {
            String courseCode = value['courseCode']
                .toString(); // Assuming the key is 'courseCode'
            existingCourseCodes
                .add(courseCode); // Add the course code to the list
            String courseName = value['courseName']
                .toString(); // Assuming the key is 'courseCode'
            existingCourseName
                .add(courseName); // Add the course code to the list
          });

          if (existingCourseCodes.contains(code)) {
            print("match");
            setState(() {
              err = true;
              message = '';
            });
            String matchedCourseName = '';
            int indexOfMatch = existingCourseCodes.indexOf(code);
            if (indexOfMatch != -1) {
              matchedCourseName = existingCourseName[indexOfMatch];
            }

            await studentRef
                .child(username)
                .child('course')
                .child(code)
                .update({
              'courseCode': code,
              'courseName': matchedCourseName,
            });

            await databaseRef
                .child(code)
                .child('student')
                .child(username)
                .update({
              'studentId': username,
              'firstName': first,
              'lastName': last,
            });
            coursesRetrival();
          } else {
            setState(() {
              err = true;
              message = 'Invalid course code';
            });
          }
        }
      }
    });
  }
}
