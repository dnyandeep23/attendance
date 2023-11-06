// ignore_for_file: avoid_print

import 'package:attedance/Utils/attendanceModel.dart';
import 'package:attedance/Utils/convertexcel.dart';
import 'package:attedance/Utils/header.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_count_down.dart';

class Teachverify extends StatefulWidget {
  final String code;
  final int res;
  const Teachverify({Key? key, required this.code, required this.res})
      : super(key: key);

  @override
  _TeachverifyState createState() => _TeachverifyState(code, res);
}

class _TeachverifyState extends State<Teachverify> {
  List<String> presentListt = [];
  List<String> absentListt = [];

  List<AttendanceData> students = [];
  // bool show = false;
  final String code;
  final int res;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _TeachverifyState(this.code, this.res);
  // final CountdownController _controller =
  //     CountdownController(duration: const Duration(minutes: 5));
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    double bottomSheetHeight = MediaQuery.of(context).size.height * 0.81;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: Column(children: [
        Header(screenHeight: screenHeight, screenWidth: screenWidth,isStud:false),
        SizedBox(
          height: screenHeight * 0.04,
        ),
        Container(
          alignment: Alignment.center,
          height: screenHeight * 0.08,
          width: screenWidth * 0.4,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(136, 32, 32, 32)),
          child: Countdown(
            seconds: 5,
            // Set the initial duration in seconds
            build: (_, double time) {
              final minutes = (time / 60).floor(); // Calculate minutes
              final seconds = (time % 60).floor(); // Calculate seconds

              // Format minutes and seconds as "00:00"
              final formattedTime =
                  '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

              return Text(
                '$formattedTime',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontFamily: 'postnobillbold',
                ),
              );
            },
            interval: Duration(milliseconds: 100),
            onFinished: () {
              Future.delayed(Duration(seconds: 4), () {
                retriveStudentInfo();

                _scaffoldKey.currentState!.openEndDrawer();
              });

              // Showbottom(context);
            },
          ),
        ),
        SizedBox(
          height: screenHeight * 0.1,
        ),
        Container(
            alignment: Alignment.center,
            width: screenWidth,
            height: screenHeight * 0.63,
            decoration: BoxDecoration(
                color: Color.fromARGB(174, 57, 55, 55),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60)),
                border: Border.all(
                    color: const Color.fromARGB(255, 255, 253, 253))),
            child: Text(
              '$res',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.6,
                  fontFamily: 'postnobillbold'),
            ))
      ]),
      endDrawer: AnimatedContainer(
        duration: const Duration(seconds: 2),
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 0, 0, 0),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50), topLeft: Radius.circular(50))),
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
          child: SizedBox(
            height: bottomSheetHeight,
            width: MediaQuery.of(context).size.width,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Students',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'poppinsBold',
                        fontSize: 34),
                  ),
                  SizedBox(
                    width: screenWidth * 0.15,
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     // storeStudents();
                  //     retriveStudentInfo();
                  //   },
                  //   child: const Icon(
                  //     CupertinoIcons.arrow_2_circlepath_circle_fill,
                  //     color: Colors.white,
                  //     size: 50,
                  //   ),
                  // )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(color: Colors.white, thickness: 2),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(40),
                ),
                height: screenHeight * 0.3,
                child: ListView(
                  // Wrap the Column with a ListView
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                          top: 0, left: 24, right: 24, bottom: 0),
                      child: Text(
                        'Present Students',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'postnobillbold',
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(color: Colors.white, thickness: 1),
                    ),
                    const SizedBox(width: 5),
                    presentListt.isNotEmpty
                        ? Column(
                            children: presentListt.map((adminName) {
                              return ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    adminName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17.2,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          )
                        : const Center(
                            child: Text(
                              'No Students',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.015,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(40),
                ),
                height: screenHeight * 0.3,
                child: ListView(
                  // Wrap the Column with a ListView
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                          top: 0, left: 24, right: 24, bottom: 0),
                      child: Text(
                        'Absent Students',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'postnobillbold',
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(color: Colors.white, thickness: 1),
                    ),
                    const SizedBox(width: 10),
                    absentListt.isNotEmpty
                        ? Column(
                            children: absentListt.map((adminName) {
                              return ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    adminName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17.2,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          )
                        : const Center(
                            child: Text(
                              'No Students',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    exportStudentsToExcel(students, screenWidth);
                  },
                  child: Container(
                    width: screenWidth,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Download',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: screenWidth * 0.06),
                          const Icon(
                            CupertinoIcons.arrow_down_doc,
                            color: Colors.black,
                            size: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  retriveStudentInfo() async {
    presentListt.clear();
    absentListt.clear();
    print('entered');
    DateTime now = DateTime.now();
    String date =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    List<String> list = [];

    DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref().child('course_codes');

    DatabaseReference presentRef =
        FirebaseDatabase.instance.ref().child('course_codes');

    DatabaseReference absentRef =
        FirebaseDatabase.instance.ref().child('course_codes');

    DataSnapshot dataSnapshot;
    DataSnapshot presentSnapshot;
    DataSnapshot absentSnapshot;
    await databaseRef
        .child(code)
        .child('Stud_att')
        .child(date)
        .child('Present')
        .once()
        .then((DatabaseEvent databaseEvent) async {
      dataSnapshot = databaseEvent.snapshot;

      Map<dynamic, dynamic>? courseData = dataSnapshot.value as Map?;

      if (courseData != null) {
        courseData.forEach((key, value) {
          if (value is Map) {
            String enroll = value['EnrollmentNo'];
            String name = value['FirstName'];
            String lname = value['LastName'];
            String status = value['status'];
            list.add(enroll);
            print(enroll);
            AttendanceData student = AttendanceData(
              enrollment: enroll,
              firstName: name,
              lastName: lname,
              status: status,
              date: date,
            );
            students.add(student);
            setState(() {
              presentListt.add("$enroll $name $lname");
            });
          }
        });
      }
    });

    DataSnapshot studSnapshot;
    await databaseRef
        .child(code)
        .child('student')
        .once()
        .then((DatabaseEvent databaseEvent) async {
      studSnapshot = databaseEvent.snapshot;

      Map<dynamic, dynamic>? courseData = studSnapshot.value as Map?;

      if (courseData != null) {
        courseData.forEach((key, value) {
          if (value is Map || value != null) {
            String enroll = value['studentId'] ??
                ''; // Provide an empty string as a default value
            String name = value['firstName'] ??
                ''; // Provide an empty string as a default value
            String lname = value['lastName'] ?? '';

            if (!list.contains(enroll)) {
              // print("an" + enroll);
              AttendanceData student = AttendanceData(
                enrollment: enroll,
                firstName: name,
                lastName: lname,
                status: 'Absent',
                date: date,
              );
              databaseRef
                  .child(code)
                  .child('Stud_att')
                  .child(date)
                  .child('Absent')
                  .child(enroll)
                  .update({
                "EnrollmentNo": enroll,
                "FirstName": name,
                "LastName": lname,
                'status': 'Absent',
              });

              int present = 0;
              int absent = 0;
              DataSnapshot snapshot;
              databaseRef
                  .child(code)
                  .child('Stud_Ratio')
                  .child(enroll)
                  .once()
                  .then((DatabaseEvent dataEvent) async {
                snapshot = dataEvent.snapshot;

                if (snapshot.value != null && snapshot.exists) {
                  // Data is present
                  Map<dynamic, dynamic>? studInfo = snapshot.value as Map?;
                  present = studInfo?['Present'] ?? 0;
                  absent = studInfo?['Absent'] ?? 0;
                  print("Entered");
                }

                // Update the data
                databaseRef
                    .child(code)
                    .child('Stud_Ratio')
                    .child(enroll)
                    .update({
                  'Present': present,
                  'Absent': absent + 1,
                });
              });

              students.add(student);

              setState(() {
                absentListt.add("$enroll $name $lname");
              });
            }
          }
        });
      }
    });
    String enrollment = "";
    List<String> presentStudent = [];
    List<String> absentStudent = [];
    presentRef
        .child(code)
        .child('Stud_att')
        .child(date)
        .child('Present')
        .once()
        .then((DatabaseEvent de) {
      presentSnapshot = de.snapshot;

      Map<dynamic, dynamic>? presentData = presentSnapshot.value as Map?;

      if (presentData != null) {
        presentData.forEach((key, value) {
          if (value is Map || value != null) {
            enrollment = value['EnrollmentNo'];
            presentStudent.add(enrollment);
          }
        });

        absentRef
            .child(code)
            .child('Stud_att')
            .child(date)
            .child('Absent')
            .once()
            .then((DatabaseEvent ab) {
          absentSnapshot = ab.snapshot;

          Map<dynamic, dynamic>? absentData = absentSnapshot.value as Map?;

          if (absentData != null) {
            absentData.forEach((key, value) {
              if (value is Map || value != null) {
                String enroll = value['EnrollmentNo'];
                absentStudent.add(enroll);

                // databaseRef
                //     .child(code)
                //     .child('Stud_Ratio')
                //     .child(enroll)
                //     .child('Absent')
                //     .once()
                //     .then((DatabaseEvent newde) {
                //   DataSnapshot s = newde.snapshot;

                //   Map<dynamic, dynamic>? n = s.value as Map?;

                //   if (n != null) {
                //     int absent = n["Absent"] as int;

                //     databaseRef
                //         .child(code)
                //         .child('Stud_Ratio')
                //         .child(enroll)
                //         .child('Absent')
                //         .update({
                //       'Absent': absent - 1,
                //     });
                //   }
                // });
              }
            });
          }
        });
      }
    });

    absentStudent.forEach((element) {
      if (presentStudent.contains(element)) {
        databaseRef
            .child(code)
            .child('Stud_att')
            .child(date)
            .child('Absent')
            .child(enrollment)
            .remove();

        int present = 0;
        int absent = 0;
        DataSnapshot snapshot;
        databaseRef
            .child(code)
            .child('Stud_Ratio')
            .child(enrollment)
            .once()
            .then((DatabaseEvent dataEvent) async {
          snapshot = dataEvent.snapshot;

          if (snapshot.value != null && snapshot.exists) {
            // Data is present
            Map<dynamic, dynamic>? studInfo = snapshot.value as Map?;
            present = studInfo?['Present'] ?? 0;
            absent = studInfo?['Absent'] ?? 0;
            print("Entered");

            // Check if "Absent" is not already 0
            if (absent > 0) {
              absent = absent - 1; // Decrement "Absent" by 1
            }
          } else {
            // Data is not present

            absent = 0;
            print("Closed");
          }

          // Update the data
          databaseRef.child(code).child('Stud_Ratio').child(enrollment).update({
            'Present': present,
            'Absent': absent,
          });
        });
      }
    });
  }
}
