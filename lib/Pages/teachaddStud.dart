// ignore_for_file: unused_import, file_names, no_logic_in_create_state, duplicate_ignore

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_list.dart';
import 'package:flutter/material.dart';

import 'package:attedance/Utils/header.dart';

class TeachaddStud extends StatefulWidget {
  final String code;
  final String courseName;
  const TeachaddStud({Key? key, required this.code, required this.courseName})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _TeachaddStudState createState() =>
      _TeachaddStudState(code: code, courseName: courseName);
}

class _TeachaddStudState extends State<TeachaddStud> {
  final String code;
  final String courseName;
  _TeachaddStudState({required this.code, required this.courseName});

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _instituteNameController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  String message = '';
  int color = 0;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Header(screenHeight: screenHeight, screenWidth: screenWidth,isStud: false),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Center(
              child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color.fromARGB(200, 76, 70, 70),
                      border: Border.all(color: Colors.white, width: 1.0)),
                  child: const Text('Add New Student',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppinsBold',
                          fontSize: 25))),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Center(
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.88,
                  // height: MediaQuery.of(context).size.height * 0.53,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(100, 126, 120, 120),
                      border: Border.all(color: Colors.white, width: 1.0)),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Firstname Name must be given.";
                              }
                              return null;
                            },
                            controller: _firstNameController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(left: 15),
                              hintText: 'First Name',
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2)),
                              errorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2)),
                            ),
                            cursorColor: Colors.white,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Last Name must be given.";
                              }
                              return null;
                            },
                            controller: _lastNameController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(left: 15),
                              hintText: 'Last Name',
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2)),
                              errorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2)),
                            ),
                            cursorColor: Colors.white,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Student ID must be given.";
                              }
                              return null;
                            },
                            controller: _studentIdController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(left: 15),
                              hintText: 'StudentId',
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2)),
                              errorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2)),
                            ),
                            cursorColor: Colors.white,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Institute Name must be given.";
                              }
                              return null;
                            },
                            controller: _instituteNameController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(left: 15),
                              hintText: 'Institute Name',
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2)),
                              errorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2)),
                            ),
                            cursorColor: Colors.white,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Mobile No must be given.";
                              }
                              if (RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                                return null; // Valid mobile number
                              } else {
                                return "Mobile No should contain exactly 10 numeric digits.";
                              }
                            },
                            controller: _mobileNumberController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(left: 15),
                              hintText: 'Nobile No',
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2)),
                              errorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2)),
                            ),
                            cursorColor: Colors.white,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password must be given.";
                              }
                              if (value.length < 8) {
                                return "Password must be at least 8 characters long.";
                              }
                              return null; // Valid password
                            },
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(left: 15),
                              hintText: 'Password',
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2)),
                              errorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2)),
                            ),
                            cursorColor: Colors.white,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Text("$message",
                            style:
                                TextStyle(color: Color(color), fontSize: 18)),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        ElevatedButton(
                          onPressed: () {
                            handleSubmit();
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      String enrol = _studentIdController.text.toUpperCase();
      String pass = _passwordController.text.toUpperCase();
      String mob = _mobileNumberController.text.toUpperCase();
      String institute = _instituteNameController.text.toUpperCase();
      String first = _firstNameController.text.toUpperCase();
      String last = _lastNameController.text.toUpperCase();
      bool exsits = false;
      DatabaseReference databaseRef =
          FirebaseDatabase.instance.ref().child('student');
      DatabaseReference courseRef =
          FirebaseDatabase.instance.ref().child('course_codes');
      DataSnapshot userSnapshot;
      await databaseRef
          .child(enrol)
          .once()
          .then((DatabaseEvent databaseEvent) async {
        userSnapshot = databaseEvent.snapshot;
        // print(userSnapshot);
        if (userSnapshot.value != null) {
          Map<dynamic, dynamic>? userData = userSnapshot.value as Map?;
          userData?.forEach((key, value) {
            if (value['studentId'] == enrol) {
              databaseRef.child(enrol).child(code).update({
                'courseCode': code,
                'courseName': courseName,
              });
              courseRef.child(code).child('student').child(enrol).set({
                'firstName': first,
                'lastName': last,
                'studentId': enrol,
              });

              exsits = true;
              return;
            } else {
              exsits = false;
            }
          });
        }
      });

      if(exsits == false){
try {
          print(code);
          databaseRef.child(enrol).update({
            'Mobile': mob,
            'Password': pass,
            'firstName': first,
            'lastName': last,
            'instituteName': institute,
            'studentId': enrol
          });
          await databaseRef.child(enrol).child('course').child(code).update({
            'courseCode': code,
            'courseName': courseName,
          });
          await courseRef.child(code).child('student').child(enrol).set({
            'firstName': first,
            'lastName': last,
            'studentId': enrol,
          });
          setState(() {
            message = "Student Stored Successfully";
            color = 0xFF38FB02;
            _studentIdController.clear();
            _firstNameController.clear();
            _lastNameController.clear();
            _mobileNumberController.clear();
            _passwordController.clear();
            _instituteNameController.clear();
          });
          Future.delayed(const Duration(milliseconds: 2000), () {
            setState(() {
              message = '';
            });
          });
        } catch (e) {
          setState(() {
            message = "Failed to store student: $e"; // Print the error message
            color = 0xFFFF0000;
          });
        }
      }
      
    }
  }
}
