// ignore_for_file: unused_local_variable

import 'dart:ui';

import 'package:attedance/Pages/course.dart';
import 'package:attedance/Pages/courseteach.dart';
import 'package:attedance/Pages/phone.dart';
import 'package:attedance/Utils/customToast.dart';
import 'package:attedance/Utils/header.dart';
import 'package:device_information/device_information.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imei/imei.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudLogin extends StatefulWidget {
  const StudLogin({super.key});

  @override
  State<StudLogin> createState() => _StudLoginState();
}

class _StudLoginState extends State<StudLogin> {
  int _segmentIndex = 0;
  Color _asegmentedControlColor = Colors.black;
  Color _bsegmentedControlColor = Colors.white;
  bool d = false;
  final TextEditingController userStudController = TextEditingController();
  final TextEditingController passStudController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController userTeachController = TextEditingController();
  final TextEditingController passTeachController = TextEditingController();
  final GlobalKey<FormState> _teachKey = GlobalKey<FormState>();
  bool isError = false;
  bool isGreen = false;
  bool isClick = false;
  bool _obscureText = true;
  var errorMessage = '';
  bool forget = false;
  bool isTeach = false;
  bool isTError = false;
  bool isTClick = false;
  bool _obscureTText = true;
  bool isTGreen = false;
  var errorTMessage = '';

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(children: [
        Column(children: [
          Header(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              isStud: true),
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                height: screenHeight * 0.9,
                width: screenWidth,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const RiveAnimation.asset(
                      'assets/riv/bg.riv',
                      fit: BoxFit.cover,
                      alignment: FractionalOffset(0, 0),
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX: 6,
                          sigmaY:
                              9), // Adjust the sigma values for desired blur intensity
                      child: Container(
                        color: Colors
                            .transparent, // Make sure the container is transparent
                      ),
                    ),
                    Column(children: [
                      SizedBox(
                        height: screenHeight * 0.07,
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                              width: screenWidth * 0.6,
                              height: screenHeight * 0.09,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color:
                                      const Color.fromARGB(30, 217, 217, 217),
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          153, 255, 255, 255)))),
                          const Text("Login",
                              style: TextStyle(
                                  fontFamily: 'PoppinsBold',
                                  fontSize: 36,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  decoration: TextDecoration.none))
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      const Text("Welcome Back",
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.none,
                              color: Colors.white,
                              fontFamily: 'PoppinsBold')),
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                      Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.55,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(25, 217, 217, 217),
                            border: Border.all(color: Colors.white)),
                        child: Column(
                          children: [
                            SizedBox(
                              height: screenHeight * 0.03,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: CupertinoSegmentedControl<int>(
                                    borderColor: Colors.transparent,
                                    unselectedColor: Colors.transparent,
                                    selectedColor: Colors.transparent,
                                    children: {
                                      0: Container(
                                        width: 135.9590606689453,
                                        height: 32.27458953857422,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: _segmentIndex == 0
                                                ? const Color(0xffd9d9d9)
                                                : Colors.transparent),
                                        child: Center(
                                          child: Text(
                                            'Student',
                                            style: TextStyle(
                                                color: _asegmentedControlColor,
                                                fontFamily: 'poppinsBold',
                                                fontSize: 20,
                                                decoration: TextDecoration.none,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                      ),
                                      1: Container(
                                        width: 135.9590606689453,
                                        height: 32.27458953857422,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: _segmentIndex == 1
                                                ? const Color(0xffd9d9d9)
                                                : Colors.transparent),
                                        child: Center(
                                          child: Text(
                                            'Teacher',
                                            style: TextStyle(
                                                color: _bsegmentedControlColor,
                                                fontFamily: 'poppinsBold',
                                                fontSize: 20,
                                                decoration: TextDecoration.none,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                      ),
                                    },
                                    groupValue: _segmentIndex,
                                    onValueChanged: (int newValue) {
                                      setState(() {
                                        _segmentIndex = newValue;
                                        _asegmentedControlColor =
                                            _segmentIndex == 0
                                                ? Colors.black
                                                : Colors.white;
                                        _bsegmentedControlColor =
                                            _segmentIndex == 1
                                                ? Colors.black
                                                : Colors.white;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),

                            // const StudentLogin(),
                            Expanded(
                              child: IndexedStack(
                                index: _segmentIndex,
                                children: [
                                  StudentLogin(screenHeight, screenWidth),
                                  TeacherLogin(screenHeight, screenWidth),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          )
        ]),
        forget ? Phone(isteach: isTeach) : SizedBox()
      ]),
    );
  }

  StudentLogin(double screenHeight, double screenWidth) {
    return Material(
      color: Colors.transparent,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              SizedBox(
                height: isError ? screenHeight * 0.01 : screenHeight * 0.02,
              ),
              TextFormField(
                controller: userStudController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    setState(() {
                      isError = true;
                    });
                    return "Student ID is required";
                  } else if (value.length >= 10) {
                    setState(() {
                      isError = true;
                    });
                    return "Student ID must be exactly 10 characters long";
                  } else if (!RegExp(r'^[A-Za-z0-9 ]+$').hasMatch(value)) {
                    setState(() {
                      isError = true;
                    });
                    return "Student ID can only contain letters and numbers";
                  }
                  setState(() {
                    isError = false;
                  });
                  return null;
                },
                style: const TextStyle(color: Colors.white, height: 1),
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 230, 0, 0),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFFCE6E6), width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFFCE6E6),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 230, 0, 0),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  fillColor: Color.fromARGB(255, 168, 161, 161),
                  labelText: 'Student ID',
                  counterText: '',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(
                height: isError ? screenHeight * 0.01 : screenHeight * 0.04,
              ),
              Stack(alignment: Alignment.center, children: [
                TextFormField(
                  controller: passStudController,
                  obscureText: _obscureText,
                  obscuringCharacter: '✯',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      setState(() {
                        isError = true;
                      });
                      return "Password is required";
                    } else if (value.length < 8) {
                      setState(() {
                        isError = true;
                      });
                      return "Password must be at least 8 characters long";
                    }
                  },
                  style: const TextStyle(color: Colors.white, height: 1),
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 230, 0, 0),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFFCE6E6), width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFFCE6E6),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 230, 0, 0),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    fillColor: Color.fromARGB(255, 168, 161, 161),
                    labelText: 'Password',
                    counterText: '',
                    labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Positioned(
                  right: screenWidth * 0.04,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color.fromARGB(255, 255, 255, 255),
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
              SizedBox(
                height: isError ? screenHeight * 0.02 : screenHeight * 0.03,
              ),
              isError
                  ? Text(errorMessage,
                      style: TextStyle(
                          color: !isGreen
                              ? const Color.fromARGB(255, 190, 23, 11)
                              : const Color.fromARGB(255, 19, 210, 45)))
                  : const SizedBox(),
              SizedBox(
                height: isError ? screenHeight * 0.01 : screenHeight * 0.02,
              ),
              ButtonTheme(
                height: screenHeight * 0.005,
                minWidth: screenWidth * 0.8,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffd9d9d9),
                    shadowColor: const Color.fromARGB(236, 109, 107, 107),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    // Set maximumSize with a smaller height constraint
                    // Smaller height
                  ),
                  onPressed: () {
                    _readStudInfo(screenWidth);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: !isClick
                        ? const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'postnobillextrabold',
                              fontSize: 36,
                            ),
                          )
                        : const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 5,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              TextButton(
                  onPressed: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: ((context) => Phone(isteach: false,))));
                    setState(() {
                      forget = true;
                      isTeach = false;
                    });
                  },
                  child: Text('Forget Password',
                      style: TextStyle(color: Colors.white)))
            ],
          ),
        ),
      ),
    );
  }

  void _readStudInfo(double screenWidth) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isClick = true;
      });
      String username = userStudController.text.toUpperCase().trim();
      String password = passStudController.text.trim();
      String imeidev = await DeviceInformation.deviceIMEINumber;
 

      try {
        DatabaseReference databaseRef =
            FirebaseDatabase.instance.ref().child('student');

        DataSnapshot userSnapshot;
        // Check if the user already exists in the database
        await databaseRef
            .child(username)
            .once()
            .then((DatabaseEvent databaseEvent) async {
          userSnapshot = databaseEvent.snapshot;
          // print(userSnapshot);
          if (userSnapshot.value != null) {
            Map<dynamic, dynamic>? userData = userSnapshot.value as Map?;
            if (userData != null && userData.containsKey('Password')) {
              String storedPassword = userData['Password'].toString();
              String storedStudId = userData['studentId'].toString();
              String firstname = userData['firstName'].toString();
              String lastname = userData['lastName'].toString();
              String imei = userData['imei'].toString();
              if (imei == imeidev) {
                if (username == storedStudId) {
                  if (password == storedPassword) {
                    // await databaseRef.child(username).update({
                    //   'latitude': position.latitude,
                    //   'longitude': position.longitude,
                    // });
                    setState(() {
                      isClick = false;
                    });

                    // Obtain shared preferences.
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool('isStud', true);
                    await prefs.setBool('approved', false);
                    await prefs.setString('studentId', username);
                    await prefs.setString('password', password);
                    await prefs.setString('firstName', firstname);
                    await prefs.setString('lastName', lastname);
                    await Future.delayed(Duration.zero, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudCourse(
                            name: '$firstname $lastname',
                            username: username,
                          ),
                        ),
                      );
                    });
                    _showErrorMessage("Login SuccessFul", true);
                  } else {
                    _showErrorMessage("In-correct Password", false);
                    setState(() {
                      isClick = false;
                    });
                  }
                } else {
                  _showErrorMessage("Invalid User", false);
                  setState(() {
                    isClick = false;
                  });
                }
              } else {
                if (imei.isEmpty || imei == '') {
                  if (username == storedStudId) {
                    if (password == storedPassword) {
                      await databaseRef.child(username).update({
                        'imei': imeidev,
                      });

                      setState(() {
                        isClick = false;
                      });

                      // Obtain shared preferences.
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setBool('isStud', true);
                      await prefs.setBool('approved', false);
                      await prefs.setString('studentId', username);
                      await prefs.setString('password', password);
                      await prefs.setString('firstName', firstname);
                      await prefs.setString('lastName', lastname);
                      await Future.delayed(Duration.zero, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudCourse(
                              name: '$firstname $lastname',
                              username: username,
                            ),
                          ),
                        );
                      });
                      _showErrorMessage("Login SuccessFul", true);
                    } else {
                      _showErrorMessage("In-correct Password", false);
                      setState(() {
                        isClick = false;
                      });
                    }
                  } else {
                    _showErrorMessage("Invalid User", false);
                    setState(() {
                      isClick = false;
                    });
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("New device detected with : $imeidev"),
                  ));
                  sendRequestToAdmin(
                      context, username, firstname, lastname, imeidev);
                }
              }
            } else {
              _showErrorMessage("Invalid User", false);
              setState(() {
                isClick = false;
              });
            }
          } else {
            _showErrorMessage("User doesn't exisi in the database", false);
            setState(() {
              isClick = false;
            });
          }
        });
      
      } catch (e) {
        print('Error storing data: $e');
      }
    }
  }

  Future<void> sendRequestToAdmin(BuildContext context, String studentId,
      String fname, String lname, String imei) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Send Request to Update New Device?"),
          content: Text(
              "Do you want to send a request to the admin to update your new device?"),
          actions: <Widget>[
            TextButton(
              child: Text("No"),
              onPressed: () {
                // Close the dialog and perform your action if "No" is selected.
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                DatabaseReference databaseRef =
                    FirebaseDatabase.instance.ref().child('request');
                databaseRef.child(studentId).update({
                  'studentId': studentId,
                  'firstName': fname,
                  'lastName': lname,
                  'imei': imei
                });
                // Close the dialog and perform your action if "Yes" is selected.
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorMessage(String message, bool green) {
    setState(() {
      isError = true;
      isGreen = green;
      errorMessage = message;
    });
    // Wait for some time and then reset the error state.
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        isGreen = false;
        isError = false;
        errorMessage = '';
      });
    });
  }

  TeacherLogin(double screenHeight, double screenWidth) {
    return Material(
      color: Colors.transparent,
      child: Form(
        key: _teachKey,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              SizedBox(
                height: isTError ? screenHeight * 0.01 : screenHeight * 0.03,
              ),
              TextFormField(
                controller: userTeachController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    setState(() {
                      isTError = true;
                    });
                    return "UserName is required";
                  } else if (value.length < 4) {
                    setState(() {
                      isTError = true;
                    });
                    return "UserName must be at least 4 characters long";
                  } else if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(value)) {
                    setState(() {
                      isTError = true;
                    });
                    return "UserName can only contain letters and numbers";
                  }
                  setState(() {
                    isTError = false;
                  });
                  return null;
                },
                style: const TextStyle(color: Colors.white, height: 1),
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 230, 0, 0),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFFCE6E6), width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFFCE6E6),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 230, 0, 0),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  fillColor: Color.fromARGB(255, 168, 161, 161),
                  labelText: 'Username',
                  counterText: '',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(
                height: isTError ? screenHeight * 0.01 : screenHeight * 0.04,
              ),
              Stack(alignment: Alignment.center, children: [
                TextFormField(
                  controller: passTeachController,
                  obscureText: _obscureTText,
                  obscuringCharacter: '✯',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      setState(() {
                        isTError = true;
                      });
                      return "Password is required";
                    } else if (value.length < 8) {
                      setState(() {
                        isTError = true;
                      });
                      return "Password must be at least 8 characters long";
                    } else if (!RegExp(r'^(?=.*[A-Z ])').hasMatch(value)) {
                      setState(() {
                        isTError = true;
                      });
                      return "Password must contain at least one uppercase letter";
                    } else if (!RegExp(r'^(?=.*\d)').hasMatch(value)) {
                      setState(() {
                        isTError = true;
                      });
                      return "Password must contain at least one digit";
                    } else if (!RegExp(r'^(?=.*[@#$%^&+= ])').hasMatch(value)) {
                      setState(() {
                        isTError = true;
                      });
                      return "Password must contain at least one special character";
                    }
                    setState(() {
                      isTError = false;
                    });
                    return null;
                  },
                  style: const TextStyle(color: Colors.white, height: 1),
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 230, 0, 0),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFFCE6E6), width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFFCE6E6),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 230, 0, 0),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    fillColor: Color.fromARGB(255, 168, 161, 161),
                    labelText: 'Password',
                    counterText: '',
                    labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Positioned(
                  right: screenWidth * 0.04,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _obscureTText = !_obscureTText;
                          });
                        },
                        child: Icon(
                          _obscureTText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color.fromARGB(255, 255, 255, 255),
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
              SizedBox(
                height: isTError ? screenHeight * 0.02 : screenHeight * 0.03,
              ),
              isTError
                  ? Text(errorTMessage,
                      style: TextStyle(
                          color: !isGreen
                              ? const Color.fromARGB(255, 190, 23, 11)
                              : const Color.fromARGB(255, 19, 210, 45)))
                  : const SizedBox(),
              SizedBox(
                height: isTError ? screenHeight * 0.01 : screenHeight * 0.02,
              ),
              ButtonTheme(
                height: screenHeight * 0.005,
                minWidth: screenWidth * 0.8,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffd9d9d9),
                    shadowColor: const Color.fromARGB(236, 109, 107, 107),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    // Set maximumSize with a smaller height constraint
                    // Smaller height
                  ),
                  onPressed: () {
                    _readTeachInfo();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: !isTClick
                        ? const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'postnobillextrabold',
                              fontSize: 36,
                            ),
                          )
                        : const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 5,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              TextButton(
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: ((context) => Phone(
                    //               isteach: true,
                    //             ))));
                    setState(() {
                      forget = true;
                      isTeach = true;
                    });
                  },
                  child: Text('Forget Password',
                      style: TextStyle(color: Colors.white)))
            ],
          ),
        ),
      ),
    );
  }

  void _readTeachInfo() async {
    if (_teachKey.currentState!.validate()) {
      setState(() {
        isClick = true;
      });
      String username = userTeachController.text.toUpperCase().trim();
      String password = passTeachController.text.trim();
      // Position position = await _getCurrentPosition();

      try {
        DatabaseReference databaseRef =
            FirebaseDatabase.instance.ref().child('teacher');
        // print("Hello");

        DataSnapshot userSnapshot;
        // Check if the user already exists in the database
        await databaseRef
            .child(username)
            .once()
            .then((DatabaseEvent databaseEvent) async {
          userSnapshot = databaseEvent.snapshot;
          // print(userSnapshot);
          if (userSnapshot.value != null) {
            Map<dynamic, dynamic>? userData = userSnapshot.value as Map?;
            if (userData != null && userData.containsKey('Password')) {
              String storedPassword = userData['Password'].toString();
              String storedUserName = userData['userName'].toString();
              String firstname = userData['firstName'].toString();
              String lastname = userData['lastName'].toString();
              bool approved = userData['approved'] ?? false;

              if (username == storedUserName) {
                if (password == storedPassword) {
                  setState(() {
                    isClick = false;
                  });

                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool('isStud', false);
                  await prefs.setBool('approved', approved);
                  await prefs.setString('username', username);
                  await prefs.setString('password', password);
                  await prefs.setString('firstName', firstname);
                  await prefs.setString('lastName', lastname);

                  _showErrorMessage("Login SuccessFul", true);
                  await Future.delayed(Duration.zero, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TeachCourse(
                            name: '$firstname $lastname',
                            username: username,
                            approved: approved),
                      ),
                    );
                  });
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => HomeScreen(
                  //               admin: storedStudId,
                  //             )));
                } else {
                  setState(() {
                    isClick = false;
                  });
                  _showErrorMessage("In-correct Password", false);
                }
              } else {
                setState(() {
                  isClick = false;
                });
                _showErrorMessage("Invalid User", false);
              }
            } else {
              setState(() {
                isClick = false;
              });
              _showErrorMessage("Invalid User", false);
            }
          } else {
            setState(() {
              isClick = false;
            });
            _showErrorMessage("User doesn't exisi in the database", false);
          }
        });
        //
        // Optionally, you can show a success message or navigate to another screen.
        // For example:
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text('Data saved successfully!'),
        // ));
      } catch (e) {
        print('Error storing data: $e');
      }
    }
  }
}
