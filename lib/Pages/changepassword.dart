import 'package:attedance/Pages/login.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Changepassword extends StatefulWidget {
  final String username;
  final bool isteach;
  const Changepassword(
      {Key? key, required this.isteach, required this.username})
      : super(key: key);

  @override
  _ChangepasswordState createState() =>
      _ChangepasswordState(isteach: isteach, username: username);
}

class _ChangepasswordState extends State<Changepassword> {
  final GlobalKey<FormState> _pass = GlobalKey<FormState>();
  final TextEditingController pass = TextEditingController();
  final TextEditingController confpass = TextEditingController();
  final String username;
  final bool isteach;
  _ChangepasswordState({required this.isteach, required this.username});
  void updatePassword() {
    if (_pass.currentState!.validate()) {
      String password = pass.text;
      if (isteach == true) {
        DatabaseReference ref =
            FirebaseDatabase.instance.ref().child('teacher');
        ref.child(username).update({'Password': password});
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => StudLogin(),
        ));
      } else {
        DatabaseReference ref =
            FirebaseDatabase.instance.ref().child('student');
        ref.child(username).update({'Password': password});
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => StudLogin(),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Column(
              children: [
                Image.asset('assets/images/pass.png'),
                Container(
                    width: screenWidth * 0.97,
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(200, 113, 112, 112),
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(20)),
                    child: Form(
                      key: _pass,
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                          TextFormField(
                            style: TextStyle(color: Colors.white),
                            controller: pass,
                            decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 253, 253, 253)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.white,
                                )),
                                fillColor: Colors.black26,
                                counterStyle: TextStyle(color: Colors.white)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password is required";
                              } else if (value.length < 8) {
                                return "Password must be at least 8 characters long";
                              } else if (!RegExp(r'^(?=.*[a-z ])')
                                  .hasMatch(value)) {
                                return "Password must contain at least one lowercase letter";
                              } else if (!RegExp(r'^(?=.*[A-Z ])')
                                  .hasMatch(value)) {
                                return "Password must contain at least one uppercase letter";
                              } else if (!RegExp(r'^(?=.*\d)')
                                  .hasMatch(value)) {
                                return "Password must contain at least one digit";
                              } else if (!RegExp(r'^(?=.*[@#$%^&+= ])')
                                  .hasMatch(value)) {
                                return "Password must contain at least one special character";
                              }

                              return null;
                            },
                          ),
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                          TextFormField(
                            style: TextStyle(color: Colors.white),
                            controller: confpass,
                            decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 253, 253, 253)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.white,
                                )),
                                fillColor: Colors.black26,
                                counterStyle: TextStyle(color: Colors.white)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Confirm Password is required";
                              } else if (value != confpass.text) {
                                return "Passwords do not match";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: screenHeight * 0.04,
                          ),
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Color.fromARGB(20, 255, 255, 255)),
                                  side: MaterialStatePropertyAll(BorderSide(
                                      color: Colors.white, width: 1))),
                              onPressed: () {
                                updatePassword();
                              },
                              child: Text(
                                "Submit",
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      ),
                    )),
              ],
            ),
            Positioned(
              top: screenHeight * 0.037,
              left: screenWidth * 0.05,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => StudLogin()));
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
          ],
        ));
  }
}
