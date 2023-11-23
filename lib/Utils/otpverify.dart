import 'package:attedance/Pages/course.dart';
import 'package:attedance/Pages/courseteach.dart';
import 'package:attedance/Pages/editprofile.dart';
import 'package:attedance/Pages/profile.dart';
import 'package:attedance/Pages/splash_two.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OTPverify extends StatefulWidget {
  final String username;
  final String name;
  final String phone;
  final bool isteach;
  const OTPverify(
      {super.key,
      required this.username,
      required this.name,
      required this.isteach,
      required this.phone});

  @override
  State<OTPverify> createState() => _OTPverifyState(
      username: username, name: name, phone: phone, isteach: isteach);
}

class _OTPverifyState extends State<OTPverify> {
  final String username;
  final String name;
  final String phone;
  final bool isteach;
  _OTPverifyState(
      {required this.username,
      required this.name,
      required this.isteach,
      required this.phone});

  List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());
  final FirebaseAuth auth = FirebaseAuth.instance;
  // String verificationId = '';
  String message = '';
  bool iserr = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> signInWithPhoneNumber() async {
    try {
      setState(() {
        message = '';
        iserr = false;
      });
      String smsCode = otpControllers.fold(
          '', (previous, controller) => previous + controller.text);

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: Editprofile.verify, smsCode: smsCode);

      // Sign the user in (or link) with the credential
      await auth.signInWithCredential(credential);

      if (isteach == true) {
        DatabaseReference ref =
            FirebaseDatabase.instance.ref().child('teacher');
        ref.child(username).update({'Mobile': phone});
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Profile(
            username: username,
            isteach: isteach,
            show_update: false,
          ),
        ));
      } else {
        DatabaseReference ref =
            FirebaseDatabase.instance.ref().child('student');
        ref.child(username).update({'Mobile': phone});
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Profile(
            username: username,
            isteach: isteach,
            show_update: false,
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

  List<Widget> _buildOTPFields() {
    List<Widget> otpFields = [];

    for (int i = 0; i < 6; i++) {
      otpFields.add(
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: TextFormField(
              controller: otpControllers[i],
              obscureText: true,
              maxLength: 1,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1,
                    )),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 2,
                    )),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 2,
                    )),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value.length == 1) {
                  if (i < 5) {
                    FocusScope.of(context).nextFocus();
                  }
                }
              },
            ),
          ),
        ),
      );
    }

    return otpFields;
  }

  @override
  void dispose() {
    // Dispose the controllers to avoid memory leaks
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 106, 105, 105),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 2)),
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                    top: screenHeight * 0.1, bottom: screenHeight * 0.1),
                width: screenWidth * 0.5,
                child: Text(
                  "Verify OTP",
                  style: TextStyle(
                      fontFamily: 'postnobillbold',
                      fontSize: 35,
                      color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Container(
              width: screenWidth * 0.9,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 72, 71, 71)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 100),
                child: Column(
                  children: [
                    Row(
                      children: _buildOTPFields(),
                    ),
                    SizedBox(
                      height: screenHeight * 0.08,
                    ),
                    iserr
                        ? Text(
                            "$message",
                            style: TextStyle(color: Colors.red, fontSize: 18),
                          )
                        : SizedBox(),
                    iserr
                        ? SizedBox(
                            height: screenHeight * 0.02,
                          )
                        : SizedBox(),
                    InkWell(
                      onTap: () {
                        signInWithPhoneNumber();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: screenWidth,
                        height: screenHeight * 0.06,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text("SUBMIT",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'postnobillextrabold',
                                fontSize: 36,
                                fontWeight: FontWeight.w800)),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        Positioned(
          top: screenHeight * 0.037,
          left: screenWidth * 0.05,
          child: InkWell(
            onTap: () {
              isteach
                  ? Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => TeachCourse(
                        username: username,
                        name: name,
                        approved: true,
                      ),
                    ))
                  : Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => StudCourse(
                        username: username,
                        name: name,
                      ),
                    ));
            },
            child: Row(
              children: [
                Container(
                  width: screenWidth * 0.15,
                  height: screenWidth * 0.15,
                  decoration: BoxDecoration(
                      color: Color(0xff686262),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2)),
                  child: Icon(
                    Icons.arrow_back_sharp,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
