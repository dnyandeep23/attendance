import 'package:attedance/Pages/course.dart';
import 'package:attedance/Pages/courseteach.dart';
import 'package:attedance/Pages/editprofile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final String username;
  final bool isteach;
  bool show_update;
  Profile({
    Key? key,
    required this.username,
    required this.isteach,
    required this.show_update,
  }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState(
        username: username,
        isteach: isteach,
        show_update: show_update,
      );
}

class _ProfileState extends State<Profile> {
  final String username;
  final bool isteach;

  bool show_update;
  _ProfileState(
      {required this.username,
      required this.isteach,
      required this.show_update});

  String user = "";
  String profession = "";
  String mail = "";
  String mob = "";
  String password = "";
  String name = "";
  String institute = "";
  String image = "";
  String altimage =
      "https://firebasestorage.googleapis.com/v0/b/attendance-go.appspot.com/o/images%2Fdefault.png?alt=media&token=178d8b2f-38de-416d-9ea5-5b4b027eb046";

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
          String instituteName = teachData['Institute Name'];
          String imageData = teachData['image'];

          setState(() {
            name = "$fname $lname";
            profession = "Teacher";
            mail = emailid;
            mob = mobile;
            password = pass;
            user = username;
            institute = instituteName;
            image = imageData;
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
          String instituteName = studData['instituteName'] ?? '';
          String imageData = studData['image'] ?? '';

          setState(() {
            name = "$fname $lname";
            profession = "Teacher";
            mail = emailid;
            mob = mobile;
            password = pass;
            user = studentId;
            institute = instituteName;
            image = imageData;
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
      body: Stack(children: [
        Center(
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
              Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: screenHeight * 0.04,
                          ),
                          Container(
                            width: screenWidth * 0.5,
                            height: screenWidth * 0.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  width: screenWidth * 0.45,
                                  height: screenWidth * 0.45,
                                  // padding: EdgeInsets.all(20),
                                  child: Hero(
                                    tag: 'icon',
                                    child: Image.network(
                                        image.isEmpty ? altimage : image,
                                        fit: BoxFit.fill),
                                  ),
                                ),
                              ),
                            ),
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
                  Center(
                    child: Container(
                      width: screenWidth * 0.9,
                      height: 2,
                      color: Color(0xff000000),
                    ),
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
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 24.0),
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
                              CupertinoIcons.person_alt_circle,
                              color: Color(0xff000000),
                            ),
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 24.0),
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
                              CupertinoIcons.building_2_fill,
                              color: Color(0xff000000),
                            ),
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 24.0),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Institute',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xff000000),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '$institute',
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
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 24.0),
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
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 24.0),
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
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 24.0),
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
                                '${password.substring(0, 2)} ${'✯' * (password.length - 2)}',
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
              Positioned(
                top: screenHeight * 0.037,
                right: screenWidth * 0.05,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      show_update = true;
                    });
                  },
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
              ),
              Positioned(
                top: screenHeight * 0.037,
                left: screenWidth * 0.05,
                child: InkWell(
                  onTap: () {
                    isteach
                        ? Navigator.of(context)
                            .pushReplacement(MaterialPageRoute(
                            builder: (context) => TeachCourse(
                              username: username,
                              name: name,
                              approved: true,
                            ),
                          ))
                        : Navigator.of(context)
                            .pushReplacement(MaterialPageRoute(
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
        show_update
            ? Container(
                margin: EdgeInsets.all(16),
                child: Editprofile(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  username: username,
                  isteach: isteach,
                  uname: name,
                ))
            : SizedBox()
      ]),
    );
  }
}
