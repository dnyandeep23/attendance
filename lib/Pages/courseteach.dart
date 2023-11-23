// ignore_for_file: avoid_print

import 'dart:math';
import 'dart:ui';

import 'package:attedance/Pages/teacherStudDetail.dart';
import 'package:attedance/Utils/drawer.dart';
import 'package:firebase_database/firebase_database.dart';

// import 'package:background_locator/background_locator.dart';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../Utils/header.dart';

class TeachCourse extends StatefulWidget {
  final String name; // Declare the variable as final
  final String username; // Declare the variable as final
  final bool approved;
  const TeachCourse(
      {Key? key,
      required this.name,
      required this.username,
      required this.approved})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<TeachCourse> createState() =>
      _StudCourseState(name: name, username: username, approved: approved);
}

class _StudCourseState extends State<TeachCourse> {
  final String name; // Declare the variable as final
  final String username;
  final bool approved; // Declare the variable as final
  String randomCode = '';
  late String code;
  bool err = false;
  String message = '';
  bool click = false;
  _StudCourseState(
      {required this.name, required this.username, required this.approved});

  List<Color> colorList = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
  ];

  List<String> course = [];
  List<String> coursesCode = [];
  final TextEditingController courseCodeode = TextEditingController();
  final TextEditingController courseName = TextEditingController();
  final GlobalKey<FormState> _teachCourse = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  @override
  void initState() {
    super.initState();

    setState(() {
      coursesRetrieval();
    });
    print('Courses : $course');
  }

  void showSnackBar() {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  coursesRetrieval() {
    DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref().child('teacher');

    databaseRef.child(username).child('course').once().then(
        (DatabaseEvent event) {
      DataSnapshot dataSnapshot = event.snapshot;
      print("datasnapshot: $dataSnapshot");
      Map<dynamic, dynamic>? courseData = dataSnapshot.value as Map?;

      List<String> existingCourseCodes = [];
      List<String> existingCourseNames = [];

      if (courseData != null) {
        print(courseData);
        courseData.forEach((key, value) {
          if (value is Map) {
            String courseCode = value['courseCode'].toString();
            existingCourseCodes.add(courseCode);
            String courseName = value['courseName'].toString();
            existingCourseNames.add(courseName);
          }
        });

        print("Existing Course Codes: $existingCourseCodes");
        print("Existing Course Names: $existingCourseNames");

        setState(() {
          course = existingCourseNames;
          coursesCode = existingCourseCodes;
        });
      } else {
        print("No course data found.");
      }
    }, onError: (error) {
      print("Error: $error");
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
        Header(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            isStud: false),
        SizedBox(
          height: screenHeight * 0.03,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
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
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.83,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(13, 217, 217, 217),
                      border: Border.all(color: Colors.white)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                        child: Row(children: [
                          SizedBox(
                            width: screenWidth * 0.05,
                            height: screenHeight * 0.05,
                          ),
                          Container(
                            width: screenWidth * 0.52,
                            height: screenHeight * 0.075,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: screenHeight * 0.005,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                    Text(
                                      '$name ',
                                      style: const TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xffffffff),
                                          fontFamily: 'poppinsBold',
                                          overflow: TextOverflow.ellipsis),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              coursesRetrieval();
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: screenWidth * 0.08),
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
                          SizedBox(
                            width: screenWidth * 0.02,
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
                        ]),
                      ),
                      SizedBox(
                        height: screenHeight * 0.005,
                      ),
                      Container(
                        width: screenWidth,
                        height: screenHeight * 0.747,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(40, 126, 120, 120),
                            border: const Border.fromBorderSide(BorderSide(
                                style: BorderStyle.solid,
                                color: Colors.white60))),
                        child: ListWheelScrollView(
                          itemExtent: screenHeight * 0.25,
                          diameterRatio: 6.5,
                          offAxisFraction: -0.6,
                          children:
                              List<Widget>.generate(course.length, (index) {
                            if (colorList.isNotEmpty) {
                              return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TeachStudDetails(
                                            name: name,
                                            username: username,
                                            code: coursesCode[index],
                                            approved: approved,
                                            courseName: course[index]),
                                      ),
                                    );
                                    // Navigator.pushNamed(
                                    //     context, '/teachStudView');
                                  },
                                  child: Stack(children: [
                                    Container(
                                      width: screenWidth * 0.85,
                                      decoration: const BoxDecoration(
                                        color: Color.fromARGB(250, 87, 87, 87),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
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
                                    Positioned(
                                      top: 20,
                                      right: 20,
                                      child: Container(
                                        color: const Color.fromARGB(0, 0, 0, 0),
                                        child: Text(
                                          'Course Code: ${coursesCode[index]}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]));
                            } else {
                              return Center(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "You have not created a course yet...",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            }
                          }),
                        ),
                        // child: ,
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ),
      ]),
      drawer: MyDrawer(isteach: approved, student: false, username: username),
    );
  }

  void generateRandomCode() {
    final random = Random();
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    const codeLength = 6; // You can adjust the length as needed

    setState(() {
      randomCode = List.generate(codeLength,
          (index) => characters[random.nextInt(characters.length)]).join();
      courseCodeode.text = '   ${randomCode.toString()}';
    });
  }

  _storeInDatabase(String code) async {
    if (code.isNotEmpty) {
      DatabaseReference databaseRef =
          FirebaseDatabase.instance.ref().child('course_codes');

      DatabaseReference teacherRef =
          FirebaseDatabase.instance.ref().child('teacher');
      // print("Hello");

      DataSnapshot courseSnap;
      // Check if the user already exists in the database
      await databaseRef.once().then((DatabaseEvent databaseEvent) async {
        courseSnap = databaseEvent.snapshot;
        print(courseSnap.value);

        if (courseSnap.value != null) {
          Map<dynamic, dynamic>? courseData = courseSnap.value as Map?;
          List<String> existingcourseCodeodes = [];
          List<String> existingCourseName = [];

          if (courseData != null) {
            courseData.forEach((key, value) {
              String courseCodeode = value['courseCode']
                  .toString(); // Assuming the key is 'courseCodeode'
              existingcourseCodeodes
                  .add(courseCodeode); // Add the course code to the list
              String courseName = value['courseName']
                  .toString(); // Assuming the key is 'courseCodeode'
              existingCourseName
                  .add(courseName); // Add the course code to the list
            });

            if (existingCourseName
                .contains(courseName.text.toUpperCase().toString())) {
              setState(() {
                err = true;
                message = 'Course name already exists';
                click = false;
              });
            } else if (!existingcourseCodeodes.contains(code)) {
              // The provided 'code' doesn't match any existing course code, so add it
              databaseRef.child(code).set({
                'courseCode': code,
                'courseName': courseName.text.toUpperCase().toString(),
                'teachUsername': username
              });

              teacherRef.child(username).child('course').child(code).update({
                'courseCode': code,
                'courseName': courseName.text.toUpperCase().toString(),
              });

              setState(() {
                click = false;
                coursesRetrieval();
              });
            } else {
              // The provided 'code' matches an existing course code, generate a new code or handle it as needed
              generateRandomCode(); // You can replace this with your desired action
            }
          }

          print(existingcourseCodeodes.toString());
        } else {
          // If there are no existing courses, add the new course
          databaseRef.child(code).set({
            'courseCode': code,
            'courseName': courseName.text.toUpperCase().toString(),
            'teachUsername': username
          });
          teacherRef.child(username).child('course').child(code).update({
            'courseCode': code,
            'courseName': courseName.text.toUpperCase().toString(),
          });
          setState(() {
            click = false;
            coursesRetrieval();
            Navigator.pop(context);
          });
        }
      });
    }
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
                      key: _teachCourse,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: courseName,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Course name is required';
                                } else if (!RegExp(r'^[a-zA-Z\s]+$')
                                    .hasMatch(value)) {
                                  return 'Only letters and spaces are allowed';
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
                                  labelText: 'Course Name',
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
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Center(
                                  child: TextField(
                                    enabled: false,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(1.0),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                221, 255, 255, 255)),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                221, 255, 255, 255)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                    ),
                                    style: const TextStyle(
                                      textBaseline: TextBaseline.alphabetic,
                                      color: Colors.white,
                                      fontFamily: 'poppinsBold',
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    readOnly: true,
                                    controller: courseCodeode,
                                    cursorHeight: 0.5,
                                  ),
                                ),
                                Positioned(
                                  right: 10,
                                  child: InkWell(
                                    onTap: () {
                                      if (_teachCourse.currentState!
                                          .validate()) {
                                        // Course name is valid, proceed to generate code
                                        setState(() {
                                          click = true;
                                          generateRandomCode();
                                        });
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(11))),
                                      height: screenHeight * 0.045,
                                      width: screenWidth * 0.25,
                                      child: !click
                                          ? const Text(
                                              'Generate',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'poppinsBold',
                                                fontSize: 14,
                                              ),
                                            )
                                          : const Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.035),
                            err
                                ? Text(
                                    message,
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontFamily: 'poppinsBold',
                                        fontSize: 14),
                                  )
                                : const Text('Hi'),
                            err
                                ? SizedBox(height: screenHeight * 0.035)
                                : SizedBox(),
                            ElevatedButton(
                              onPressed: () {
                                if (_teachCourse.currentState!.validate()) {
                                  // Course name is valid, proceed to generate code
                                  setState(() {
                                    click = true;
                                    _storeInDatabase(randomCode);
                                    Navigator.pop(context);

                                    // generateRandomCode();
                                  });
                                }
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
}
