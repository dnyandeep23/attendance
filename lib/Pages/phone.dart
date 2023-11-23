// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:attedance/Pages/changepassword.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:attedance/Pages/login.dart';

class Phone extends StatefulWidget {
  const Phone({
    Key? key,
    required this.isteach,
  }) : super(key: key);
  final bool isteach;

  @override
  State<Phone> createState() => _PhoneState(isteach);
}

class _PhoneState extends State<Phone> {
  bool isError = false;
  late String user;
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  // final TextEditingController mobTeach = TextEditingController();
  late String mob;
  final TextEditingController userController = TextEditingController();
  List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());

  String errMessage = "";
  _PhoneState(this.isteach);
  final bool isteach;
  final bool validate = false;
  String message = "";
  bool iserr = false;
  String verify = '';
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
            height: screenHeight * 0.7,
            decoration: BoxDecoration(
                color: const Color.fromARGB(237, 0, 0, 0),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white)),
            child: Column(
              children: [
                Stack(children: [
                  Column(
                    children: [
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Forget Password",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'poppinsBold',
                              fontSize: 24),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 94, 94, 94),
                        thickness: 1,
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: key,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: userController,
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
                                  } else if (!RegExp(r'^[A-Za-z0-9]+$')
                                      .hasMatch(value)) {
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
                                style: const TextStyle(
                                    color: Colors.white, height: 1),
                                cursorColor: Colors.white,
                                decoration: const InputDecoration(
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 230, 0, 0),
                                      width: 2,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFFFCE6E6), width: 2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFFCE6E6),
                                      width: 2,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 230, 0, 0),
                                      width: 2,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  fillColor: Color.fromARGB(255, 168, 161, 161),
                                  labelText: 'User ID',
                                  counterText: '',
                                  labelStyle: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        '$errMessage',
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: !validate
                                  ? MaterialStatePropertyAll(Colors.white)
                                  : MaterialStatePropertyAll(Colors.grey)),
                          onPressed: () {
                            if (key.currentState!.validate()) {
                              validatenumber(isteach);
                            }
                          },
                          child: Text(
                            "Submit",
                            style: TextStyle(color: Colors.black),
                          ))
                    ],
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const StudLogin(),
                        ));
                      },
                      child: Icon(
                        CupertinoIcons.clear_circled_solid,
                        color: Colors.white,
                        size: screenWidth * 0.1,
                      ),
                    ),
                  )
                ]),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) {
                    return Container(
                      width: screenWidth * 0.13,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: TextFormField(
                        controller: _controllers[index],
                        style:TextStyle(color:Colors.white),
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          counterText: "",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            // Move focus to the next field when a digit is entered
                            if (index < 5) {
                              FocusScope.of(context).nextFocus();
                            }
                          }
                        },
                      ),
                    );
                  }),
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: validate
                            ? MaterialStatePropertyAll(Colors.white)
                            : MaterialStatePropertyAll(Colors.grey)),
                    onPressed: () {
                      sendOTP();
                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.black),
                    ))
              ],
            )),
      ),
    );
  }

  void sendOTP() async {
    print("Enterd");
    FirebaseAuth _auth = FirebaseAuth.instance;

    // Replace 'phoneNumber' with the user's phone number in international format (e.g., +1 123-456-7890).
    try {
      setState(() {
        message = '';
        iserr = false;
      });
      String smsCode = _controllers.fold(
          '', (previous, controller) => previous + controller.text);

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verify, smsCode: smsCode);

      // Sign the user in (or link) with the credential
      await _auth.signInWithCredential(credential);

      if (isteach == true) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Changepassword(
            isteach: isteach,
            username: user,
          ),
        ));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Changepassword(
            isteach: isteach,
            username: user,
          ),
        ));
      }
    } catch (e) {
      print('Failed to sign in: $e');
      setState(() {
        message = "Invalid OTP";
        iserr = true;
      });
    }
  }

  void validatenumber(bool isteach) async {
    user = userController.text.toUpperCase();

    print("Enter");
    if (isteach == true) {
      DatabaseReference databaseRef =
          FirebaseDatabase.instance.ref().child('teacher');
      DataSnapshot userSnapshot;
      await databaseRef
          .child(user)
          .once()
          .then((DatabaseEvent databaseEvent) async {
        userSnapshot = databaseEvent.snapshot;

        if (userSnapshot.value != null) {
          Map<dynamic, dynamic>? userData = userSnapshot.value as Map?;
          if (userData != null && userData.containsKey('Mobile')) {
            String storedMob = userData['Mobile'].toString();
            setState(() {
              mob = storedMob;
              print(mob);
            });

            FirebaseAuth.instance.verifyPhoneNumber(
              phoneNumber: '+91$storedMob',
              verificationCompleted: (PhoneAuthCredential credential) {},
              verificationFailed: (FirebaseAuthException e) {},
              codeSent: (String verificationId, int? resendToken) {
                verify = verificationId;
              },
              codeAutoRetrievalTimeout: (String verificationId) {},
            );
          }
        }
      });
    } else {
      DatabaseReference databaseRef =
          FirebaseDatabase.instance.ref().child('student');
      DataSnapshot userSnapshot;
      await databaseRef
          .child(user)
          .once()
          .then((DatabaseEvent databaseEvent) async {
        userSnapshot = databaseEvent.snapshot;

        if (userSnapshot.value != null) {
          Map<dynamic, dynamic>? userData = userSnapshot.value as Map?;
          if (userData != null && userData.containsKey('Mobile')) {
            String storedMob = userData['Mobile'].toString();
            setState(() {
              mob = storedMob;
              print(mob);
            });
            FirebaseAuth.instance.verifyPhoneNumber(
              phoneNumber: '+91$storedMob',
              verificationCompleted: (PhoneAuthCredential credential) {},
              verificationFailed: (FirebaseAuthException e) {},
              codeSent: (String verificationId, int? resendToken) {
                verify = verificationId;
              },
              codeAutoRetrievalTimeout: (String verificationId) {},
            );
          }
        }
      });
    }
  }
}
