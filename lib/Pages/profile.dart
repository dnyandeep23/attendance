import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final String username;
  final bool isteach;
  const Profile({Key? key, required this.username, required this.isteach})
      : super(key: key);

  @override
  _ProfileState createState() =>
      _ProfileState(username: username, isteach: isteach);
}

class _ProfileState extends State<Profile> {
  final String username;
  final bool isteach;
  _ProfileState({
    required this.username,
    required this.isteach,
  });

  String user = "";
  String profession = "";
  String mail = "";
  String mob = "";
  String password = "";
  String name = "";

  void retriveData() {
    if (isteach) {
      DatabaseReference teachRef =
          FirebaseDatabase.instance.ref().child('teacher');
      DataSnapshot teachSnap;

      teachRef.child(username).once().then((DatabaseEvent databaseEvent) async {
        teachSnap = databaseEvent.snapshot;

        // print(coursecode);
        Map<dynamic, dynamic>? teachData = teachSnap.value as Map?;

        if (teachData != null) {
          String fname = teachData['firstName'];
          String lname = teachData['lastName'];
          String emailid = teachData['Email'];
          String mobile = teachData['Mobile'];
          String pass = teachData['Password'];
          String username = teachData['userName'];

          setState(() {
            name = "$fname $lname";
            profession = "Teacher";
            mail = emailid;
            mob = mobile;
            password = pass;
            user = username;
          });
        }
      });
    } else {
      DatabaseReference studRef =
          FirebaseDatabase.instance.ref().child('student');
      DataSnapshot studSnap;

      studRef.child(username).once().then((DatabaseEvent databaseEvent) async {
        studSnap = databaseEvent.snapshot;

        // print(coursecode);
        Map<dynamic, dynamic>? studData = studSnap.value as Map?;
        if (studData != null) {
          print(studData);
          String fname = studData['firstName'] ??
              ''; // Use an empty string if 'firstName' is null
          String lname = studData['lastName'] ?? '';
          String emailid = studData['Email'] ?? '';
          String mobile = studData['Mobile'] ?? '';
          String pass = studData['Password'] ?? '';
          String studentId = studData['studentId'] ?? '';

          setState(() {
            name = "$fname $lname";
            profession = "Teacher";
            mail = emailid;
            mob = mobile;
            password = pass;
            user = studentId;
          });
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retriveData();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xff7E7878), // Set the background color
      body: Center(
        child: Stack(
          children: [
            Positioned(
              top: -screenHeight * 0.17,
              left: -110,
              child: Transform.rotate(
                angle: -3.6,
                child: Container(
                  width: 500,
                  height: 300.0,
                  decoration: BoxDecoration(
                    color: Color(0xff4C4444),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.07,
              left: screenWidth * 0.04,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: screenWidth * 0.08,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: screenWidth * 0.55,
                            height: screenWidth * 0.55,
                            child: Hero(
                                tag: 'icon',
                                child: Image.asset('assets/images/icon.png')),
                          ),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Center(
                            child: Text(
                              '$name',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: screenWidth * 0.9,
                    height: 2,
                    color: Color(0xff000000),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Row(
                        children: [
                          Container(
                            child: Icon(
                              Icons.badge_outlined,
                              color: Color(0xff000000),
                            ),
                            margin: EdgeInsets.all(8.0),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isteach ? "Username" : 'Student ID',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xff000000),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '$user',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Row(
                        children: [
                          Container(
                            child: Icon(
                              Icons.person_2_outlined,
                              color: Color(0xff000000),
                            ),
                            margin: EdgeInsets.all(8.0),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Profession',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xff000000),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '$profession',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Row(
                        children: [
                          Container(
                            child: Icon(
                              Icons.mail_outlined,
                              color: Color(0xff000000),
                            ),
                            margin: EdgeInsets.all(8.0),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mail',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xff000000),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '$mail',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Row(
                        children: [
                          Container(
                            child: Icon(
                              Icons.phone_android_outlined,
                              color: Color(0xff000000),
                            ),
                            margin: EdgeInsets.all(8.0),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mobile',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xff000000),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '+91 $mob',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Row(
                        children: [
                          Container(
                            child: Icon(
                              Icons.lock_outline,
                              color: Color(0xff000000),
                            ),
                            margin: EdgeInsets.all(8.0),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Password',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xff000000),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '$password',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: screenHeight * 0.037,
              right: screenWidth * 0.05,
              child: Row(
                children: [
                  Container(
                    width: screenWidth * 0.1,
                    height: screenWidth * 0.1,
                    decoration: BoxDecoration(
                      color: Color(0xff686262),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.edit,
                      color: Color(0xff000000),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: screenHeight * 0.037,
              left: screenWidth * 0.05,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/splash");
                },
                child: Row(
                  children: [
                    Container(
                      width: screenWidth * 0.15,
                      height: screenWidth * 0.15,
                      decoration: BoxDecoration(
                        color: Color(0xff686262),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_sharp,
                        color: Color(0xff000000),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
