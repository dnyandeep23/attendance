import 'dart:ui';

import 'package:attedance/Pages/splash_two.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:attedance/Utils/header.dart';
import 'package:imei/imei.dart';
import 'package:rive/rive.dart';
import 'package:device_information/device_information.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  int _segmentIndex = 0;
  Color _asegmentedControlColor = Colors.black;
  Color _bsegmentedControlColor = Colors.white;
  bool _obscureTText = true;
  bool _obscureT2Text = true;
  bool _obscureSText = true;
  bool _obscureS2Text = true;
  final GlobalKey<FormState> studKey = GlobalKey<FormState>();
  final GlobalKey<FormState> teachKey = GlobalKey<FormState>();
  final TextEditingController firstNameStud = TextEditingController();
  final TextEditingController lastNameStud = TextEditingController();
  final TextEditingController studIdStud = TextEditingController();
  final TextEditingController emailStud = TextEditingController();
  final TextEditingController mobStud = TextEditingController();
  final TextEditingController instituteNameStud = TextEditingController();
  final TextEditingController passStud = TextEditingController();
  final TextEditingController confPassStud = TextEditingController();
  final TextEditingController firstNameTeach = TextEditingController();
  final TextEditingController lastNameTeach = TextEditingController();
  final TextEditingController usernameTeach = TextEditingController();
  final TextEditingController emailTeach = TextEditingController();
  final TextEditingController mobTeach = TextEditingController();
  final TextEditingController instituteNameTeach = TextEditingController();
  final TextEditingController passTeach = TextEditingController();
  final TextEditingController confPassTeach = TextEditingController();

  bool fnameStud = false;
  bool lname = false;
  bool sid = false;
  bool email = false;
  bool mob = false;
  bool institute = false;
  bool pass = false;
  bool cnfpass = false;

  bool isStudError = false;
  bool isTeachError = false;
  bool isStud = false;
  bool isTeach = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Stack(children: [
          SizedBox(
            height: screenHeight * 1.3,
            width: screenWidth,
            child: const RiveAnimation.asset(
              'assets/riv/bg.riv',
              fit: BoxFit.cover,
              alignment: FractionalOffset(0, 0),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 5,
                sigmaY:
                    5), // Adjust the sigma values for desired blur intensity
            child: Container(
              color: Colors.transparent,
            ),
          ),
          Container(
              color: Colors.transparent,
              child: Column(children: [
                Header(
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    isStud: true),
                Column(children: [
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                          width: screenWidth * 0.6,
                          height: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: const Color.fromARGB(30, 217, 217, 217),
                              border: Border.all(
                                  color: const Color.fromARGB(
                                      153, 255, 255, 255)))),
                      const Text("Register",
                          style: TextStyle(
                              fontFamily: 'PoppinsBold',
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              decoration: TextDecoration.none))
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  Container(
                    width: screenWidth * 0.95,
                    height: isStud
                        ? (isStudError
                            ? screenHeight * 1.2
                            : screenHeight * 0.9)
                        : (isTeachError
                            ? screenHeight * 1.2
                            : screenHeight * 0.9),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: const Color.fromARGB(30, 217, 217, 217),
                        border: Border.all(
                            color: const Color.fromARGB(153, 255, 255, 255))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                                    _asegmentedControlColor = _segmentIndex == 0
                                        ? Colors.black
                                        : Colors.white;
                                    _bsegmentedControlColor = _segmentIndex == 1
                                        ? Colors.black
                                        : Colors.white;
                                    isStud = _segmentIndex == 0 ? true : false;
                                    isTeach = _segmentIndex == 0 ? true : false;
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
                              studentRegister(screenWidth, screenHeight),
                              teacherRegister(screenWidth, screenHeight),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ]),
              ])),
        ]),
      ),
    );
  }

  Widget studentRegister(double screenWidth, double screenHeight) {
    return Material(
      color: Colors.transparent,
      child: Form(
        key: studKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: screenHeight * 0.03,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: firstNameStud,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          setState(() {
                            fnameStud = true;
                            isStudError = true;
                          });
                          return "First Name is required";
                        } else if (value.length < 2) {
                          setState(() {
                            fnameStud = true;
                            isStudError = true;
                          });
                          return "First Name is too short";
                        } else if (value.length > 50) {
                          setState(() {
                            fnameStud = true;
                            isStudError = true;
                          });
                          return "First Name is too long";
                        } else if (!RegExp(r'^[A-Za-z ]+$').hasMatch(value)) {
                          setState(() {
                            fnameStud = true;
                            isStudError = true;
                          });
                          return "First Name can only contain letters";
                        }
                        setState(() {
                          fnameStud = false;
                          isStudError = false;
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
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
                        labelText: 'First Name',
                        counterText: '',
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * 0.03,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: lastNameStud,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          setState(() {
                            lname = true;
                            isStudError = true;
                          });
                          return "Last Name is required";
                        } else if (value.length < 2) {
                          setState(() {
                            lname = true;
                            isStudError = true;
                          });
                          return "Last Name is too short";
                        } else if (value.length > 50) {
                          setState(() {
                            lname = true;
                            isStudError = true;
                          });
                          return "Last Name is too long";
                        } else if (!RegExp(r'^[A-Za-z ]+$').hasMatch(value)) {
                          setState(() {
                            lname = true;
                            isStudError = true;
                          });
                          return "Last Name can only contain letters";
                        }
                        setState(() {
                          lname = false;
                          isStudError = false;
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
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
                        labelText: 'Last Name',
                        counterText: '',
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              TextFormField(
                controller: studIdStud,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    setState(() {
                      sid = true;
                      isStudError = true;
                    });
                    return "Student ID is required";
                  } else if (value.length >= 10) {
                    setState(() {
                      sid = true;
                      isStudError = true;
                    });
                    return "Student ID must be exactly 10 characters long";
                  } else if (!RegExp(r'^[A-Za-z0-9 ]+$').hasMatch(value)) {
                    setState(() {
                      sid = true;
                      isStudError = true;
                    });
                    return "Student ID can only contain letters and numbers";
                  }
                  setState(() {
                    sid = false;
                    isStudError = false;
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
                  labelText: 'Student - ID',
                  counterText: '',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              TextFormField(
                controller: emailStud,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    setState(() {
                      email = true;
                      isStudError = true;
                    });
                    return "Email is required";
                  } else if (!RegExp(
                          r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[a-zA-Z ]{2,})+$')
                      .hasMatch(value)) {
                    setState(() {
                      email = true;
                      isStudError = true;
                    });
                    return "Please enter a valid email address";
                  } else if (value.length > 100) {
                    setState(() {
                      email = true;
                      isStudError = true;
                    });
                    return "Email cannot be longer than 100 characters";
                  }
                  setState(() {
                    email = false;
                    isStudError = false;
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
                  labelText: 'Email',
                  counterText: '',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              TextFormField(
                controller: mobStud,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    setState(() {
                      mob = true;
                      isStudError = true;
                    });
                    return "Mobile number is required";
                  } else if (!RegExp(r'^[789 ]\d{9}$').hasMatch(value) ||
                      value.length != 10) {
                    setState(() {
                      mob = true;
                      isStudError = true;
                    });
                    return "Please enter a valid 10-digit Indian mobile number";
                  }
                  setState(() {
                    mob = false;
                    isStudError = false;
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
                  labelText: 'Mobile No',
                  counterText: '',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              TextFormField(
                controller: instituteNameStud,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    setState(() {
                      isStudError = true;
                      institute = true;
                    });
                    return "institute name is required";
                  }
                  setState(() {
                    isStudError = false;
                    institute = false;
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
                  labelText: 'Institute Name',
                  counterText: '',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              Stack(alignment: Alignment.center, children: [
                TextFormField(
                  controller: passStud,
                  obscureText: _obscureSText,
                  obscuringCharacter: '✯',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      setState(() {
                        isStudError = true;
                      });
                      return "Password is required";
                    } else if (value.length < 8) {
                      setState(() {
                        isStudError = true;
                      });
                      return "Password must be at least 8 characters long";
                    } else if (!RegExp(r'^(?=.*[a-z ])').hasMatch(value)) {
                      setState(() {
                        isStudError = true;
                      });
                      return "Password must contain at least one lowercase letter";
                    } else if (!RegExp(r'^(?=.*[A-Z ])').hasMatch(value)) {
                      setState(() {
                        isStudError = true;
                      });
                      return "Password must contain at least one uppercase letter";
                    } else if (!RegExp(r'^(?=.*\d)').hasMatch(value)) {
                      setState(() {
                        isStudError = true;
                      });
                      return "Password must contain at least one digit";
                    } else if (!RegExp(r'^(?=.*[@#$%^&+= ])').hasMatch(value)) {
                      setState(() {
                        isStudError = true;
                      });
                      return "Password must contain at least one special character";
                    }
                    setState(() {
                      isStudError = false;
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
                            _obscureSText = !_obscureSText;
                          });
                        },
                        child: Icon(
                          _obscureSText
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
                height: isStudError ? screenHeight * 0.02 : screenHeight * 0.03,
              ),
              Stack(alignment: Alignment.center, children: [
                TextFormField(
                  controller: confPassStud,
                  obscureText: _obscureS2Text,
                  obscuringCharacter: '✯',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      setState(() {
                        cnfpass = true;
                        isStudError = true;
                      });
                      return "Confirm Password is required";
                    } else if (value != passStud.text) {
                      setState(() {
                        cnfpass = true;
                        isStudError = true;
                      });
                      return "Passwords do not match";
                    } else if (fnameStud ||
                        lname ||
                        sid ||
                        email ||
                        pass ||
                        mob ||
                        institute ||
                        cnfpass) {
                      setState(() {
                        cnfpass = true;
                        isStudError = true;
                      });
                      return null;
                    }

                    setState(() {
                      cnfpass = false;
                      isStudError = false;
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
                    labelText: 'Confirm Password',
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
                            _obscureS2Text = !_obscureS2Text;
                          });
                        },
                        child: Icon(
                          _obscureS2Text
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
                height: screenHeight * 0.03,
              ),
              ButtonTheme(
                height: screenHeight * 0.0001,
                minWidth: screenWidth * 0.8,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffd9d9d9),
                    shadowColor: const Color.fromARGB(236, 109, 107, 107),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {
                    _storeStudData();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text('Register',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'postnobillextrabold',
                            fontSize: 36)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _storeStudData() async {
    if (studKey.currentState!.validate()) {
      String imei = await DeviceInformation.deviceIMEINumber;
      // String imei = Imei.platformVersion;
      String firstName = firstNameStud.text.toUpperCase().trim();
      String lastName = lastNameStud.text.toUpperCase().trim();
      String studId = studIdStud.text.toUpperCase().trim();
      String email = emailStud.text.trim();
      String mob = mobStud.text.trim();
      String institute = instituteNameStud.text.toUpperCase().trim();
      String pass = passStud.text.trim();

      try {
        DatabaseReference databaseRef =
            FirebaseDatabase.instance.ref().child('student');

        print("hello");
        DataSnapshot userSnapshot;
        // Check if the user already exists in the database
        await databaseRef
            .child(studId)
            .once()
            .then((DatabaseEvent databaseEvent) async {
          userSnapshot = databaseEvent.snapshot;
          print("hii");
          if (userSnapshot.value != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('$studId is already stored in the database.'),
            ));
          } else {
            await databaseRef.child(studId).set({
              'firstName': firstName,
              'lastName': lastName,
              'studentId': studId,
              'Email': email,
              'Mobile': mob,
              'instituteName': institute,
              'Password': pass,
              'imei': imei,
            });

            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Splash()));
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

  teacherRegister(double screenWidth, double screenHeight) {
    return Material(
        color: Colors.transparent,
        child: Form(
          key: teachKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              SizedBox(
                height: screenHeight * 0.03,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: firstNameTeach,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          setState(() {
                            isTeachError = true;
                          });
                          return "First Name is required";
                        } else if (value.length < 2) {
                          setState(() {
                            isTeachError = true;
                          });
                          return "First Name is too short";
                        } else if (value.length > 50) {
                          setState(() {
                            isTeachError = true;
                          });
                          return "First Name is too long";
                        } else if (!RegExp(r'^[A-Za-z ]+$').hasMatch(value)) {
                          setState(() {
                            isTeachError = true;
                          });
                          return "First Name can only contain letters";
                        }
                        setState(() {
                          isTeachError = false;
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
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
                        labelText: 'First Name',
                        counterText: '',
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * 0.03,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: lastNameTeach,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          setState(() {
                            isTeachError = true;
                          });
                          return "Last Name is required";
                        } else if (value.length < 2) {
                          setState(() {
                            isTeachError = true;
                          });
                          return "Last Name is too short";
                        } else if (value.length > 50) {
                          setState(() {
                            isTeachError = true;
                          });
                          return "Last Name is too long";
                        } else if (!RegExp(r'^[A-Za-z ]+$').hasMatch(value)) {
                          setState(() {
                            isTeachError = true;
                          });
                          return "Last Name can only contain letters";
                        }
                        setState(() {
                          isTeachError = false;
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
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
                        labelText: 'Last Name',
                        counterText: '',
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              TextFormField(
                controller: usernameTeach,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    setState(() {
                      isTeachError = true;
                    });
                    return "UserName is required";
                  } else if (value.length < 4) {
                    setState(() {
                      isTeachError = true;
                    });
                    return "UserName must be at least 4 characters long";
                  } else if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(value)) {
                    setState(() {
                      isTeachError = true;
                    });
                    return "UserName can only contain letters and numbers";
                  }
                  setState(() {
                    isTeachError = false;
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
                height: screenHeight * 0.03,
              ),
              TextFormField(
                controller: emailTeach,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    setState(() {
                      isTeachError = true;
                    });
                    return "Email is required";
                  } else if (!RegExp(
                          r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[a-zA-Z ]{2,})+$')
                      .hasMatch(value)) {
                    setState(() {
                      isTeachError = true;
                    });
                    return "Please enter a valid email address";
                  } else if (value.length > 100) {
                    setState(() {
                      isTeachError = true;
                    });
                    return "Email cannot be longer than 100 characters";
                  }
                  setState(() {
                    isTeachError = false;
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
                  labelText: 'Email',
                  counterText: '',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              TextFormField(
                controller: mobTeach,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    setState(() {
                      isTeachError = true;
                    });
                    return "Mobile number is required";
                  } else if (!RegExp(r'^[789 ]\d{9}$').hasMatch(value) ||
                      value.length != 10) {
                    setState(() {
                      isTeachError = true;
                    });
                    return "Please enter a valid 10-digit Indian mobile number";
                  }
                  setState(() {
                    isTeachError = false;
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
                  labelText: 'Mobile No',
                  counterText: '',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              TextFormField(
                controller: instituteNameTeach,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    setState(() {
                      isTeachError = true;
                    });
                    return "institute name is required";
                  }
                  setState(() {
                    isTeachError = false;
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
                  labelText: 'Institute Name',
                  counterText: '',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              Stack(alignment: Alignment.center, children: [
                TextFormField(
                  controller: passTeach,
                  obscureText: _obscureTText,
                  obscuringCharacter: '✯',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      setState(() {
                        isTeachError = true;
                      });
                      return "Password is required";
                    } else if (value.length < 8) {
                      setState(() {
                        isTeachError = true;
                      });
                      return "Password must be at least 8 characters long";
                    } else if (!RegExp(r'^(?=.*[a-z ])').hasMatch(value)) {
                      setState(() {
                        isTeachError = true;
                      });
                      return "Password must contain at least one lowercase letter";
                    } else if (!RegExp(r'^(?=.*[A-Z ])').hasMatch(value)) {
                      setState(() {
                        isTeachError = true;
                      });
                      return "Password must contain at least one uppercase letter";
                    } else if (!RegExp(r'^(?=.*\d)').hasMatch(value)) {
                      setState(() {
                        isTeachError = true;
                      });
                      return "Password must contain at least one digit";
                    } else if (!RegExp(r'^(?=.*[@#$%^&+= ])').hasMatch(value)) {
                      setState(() {
                        isTeachError = true;
                      });
                      return "Password must contain at least one special character";
                    }
                    setState(() {
                      isTeachError = false;
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
                height:
                    isTeachError ? screenHeight * 0.02 : screenHeight * 0.03,
              ),
              Stack(alignment: Alignment.center, children: [
                TextFormField(
                  controller: confPassTeach,
                  obscureText: _obscureT2Text,
                  obscuringCharacter: '✯',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      setState(() {
                        cnfpass = true;
                        isTeachError = true;
                      });
                      return "Confirm Password is required";
                    } else if (value != passTeach.text.trim()) {
                      setState(() {
                        cnfpass = true;
                        isTeachError = true;
                      });
                      return "Passwords do not match";
                    } else if (fnameStud ||
                        lname ||
                        sid ||
                        email ||
                        pass ||
                        mob ||
                        institute ||
                        cnfpass) {
                      setState(() {
                        isTeachError = true;
                      });
                      return null;
                    }

                    setState(() {
                      cnfpass =
                          false; // Reset the cnfpass flag when passwords match
                      isTeachError = false;
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
                    labelText: 'Confirm Password',
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
                            _obscureT2Text = !_obscureT2Text;
                          });
                        },
                        child: Icon(
                          _obscureT2Text
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
                height: screenHeight * 0.03,
              ),
              ButtonTheme(
                height: screenHeight * 0.0001,
                minWidth: screenWidth * 0.8,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffd9d9d9),
                    shadowColor: const Color.fromARGB(236, 109, 107, 107),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {
                    _storeTeachData();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text('Register',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'postnobillextrabold',
                            fontSize: 36)),
                  ),
                ),
              ),
            ]),
          ),
        ));
  }

  void _storeTeachData() async {
    if (teachKey.currentState!.validate()) {
      String firstName = firstNameTeach.text.trim();
      String lastName = lastNameTeach.text.trim();
      String userName = usernameTeach.text.trim();
      String email = emailTeach.text.trim();
      String mob = mobTeach.text.trim();
      String institute = instituteNameTeach.text.trim();
      String pass = passTeach.text.trim();
      String imei = await DeviceInformation.deviceIMEINumber;

      try {
        DatabaseReference databaseRef =
            FirebaseDatabase.instance.ref().child('teacher');

        DataSnapshot userSnapshot;
        await databaseRef
            .child(userName)
            .once()
            .then((DatabaseEvent databaseEvent) async {
          userSnapshot = databaseEvent.snapshot;
          if (userSnapshot.value != null) {
            // User already exists, update their coordinates
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('$userName is already stored in the database.'),
            ));
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => const Splash()));
          } else {
            // User does not exist, create a new entry
            await databaseRef.child(userName.toUpperCase()).set({
              'userName': userName.toUpperCase(),
              'firstName': firstName.toUpperCase(),
              'lastName': lastName.toUpperCase(),
              'Email': email,
              'Mobile': mob,
              'Institute Name': institute.toUpperCase(),
              'Password': pass,
              'imei': imei,
            });
            // ignore: use_build_context_synchronously
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Splash()));
          }
        });
      } catch (e) {
        print('Error storing data: $e');
      }
    }
  }
}
