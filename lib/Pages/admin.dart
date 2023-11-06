import 'package:attedance/Utils/drawer.dart';
import 'package:attedance/Utils/header.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Admin extends StatefulWidget {
    final String username;
  const Admin({Key? key,required this.username}) : super(key: key);

  @override
  _AdminState createState() => _AdminState(username: username);
}

class _AdminState extends State<Admin> {
  final String username;
  _AdminState({required this.username});

  List<String> enroll = [];
  List<String> fname = [];
  List<String> lname = [];
  List<String> imei = [];

  @override
  void initState() {
    super.initState();
    retriveStudents();
  }

  void retriveStudents() async {
    DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

    DataSnapshot dataSnapshot;
    await databaseRef
        .child('request')
        .once()
        .then((DatabaseEvent databaseEvent) async {
      dataSnapshot = databaseEvent.snapshot;

      Map<dynamic, dynamic>? courseData = dataSnapshot.value as Map?;

      if (courseData != null) {
        enroll.clear();
        fname.clear();
        lname.clear();
        imei.clear();

        // ignore: avoid_print
        print(courseData);
        courseData.forEach((key, value) {
          if (value is Map) {
            setState(() {
              String studId = value['studentId'].toString();
              enroll.add(studId);
              String firstname = value['firstName'].toString();
              fname.add(firstname);
              String lastname = value['lastName'].toString();
              lname.add(lastname);
              String imeino = value['imei'].toString();
              imei.add(imeino);
            });
          }
        });
      }
    });
  }

  updateIMEI(String imeino, String roll) {
    DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref().child('student');
    databaseRef.child(roll).update({
      'imei': imeino,
    });
    DatabaseReference newRef = FirebaseDatabase.instance.ref();
    newRef.child('request').child(roll).remove();
    setState(() {
      retriveStudents();
    });
  }

  removeIMEI(String enroll) {
    DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
    databaseRef.child('request').child(enroll).remove();
    setState(() {
      retriveStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Header(screenHeight: screenHeight, screenWidth: screenWidth,isStud: false,),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.center,
              height: screenHeight * 0.08,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(66, 20, 19, 19)),
              child: Text(
                "Requested Student List",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(66, 20, 19, 19)),
                height: screenHeight * 0.7,
                child: ListView.builder(
                  itemCount: enroll.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.12,
                        margin: const EdgeInsets.only(top: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 201, 203, 203),
                            borderRadius: BorderRadius.circular(15)),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: screenWidth * 0.04,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      "${enroll[index]}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth * 0.08,
                                      ),
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      "${fname[index]} ${lname[index]}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: screenWidth * 0.05,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Positioned(
                              top: 2,
                              right: 4,
                              child: ElevatedButton(
                                onPressed: () {
                                  // removeStud(enroll[index], index);
                                  updateIMEI(imei[index], enroll[index]);
                                },
                                style: ButtonStyle(
                                  alignment: Alignment.centerRight,
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromARGB(255, 51, 146, 0)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  "Accept",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 2,
                              right: 4,
                              child: ElevatedButton(
                                onPressed: () {
                                  // removeStud(enroll[index], index);
                                  removeIMEI(enroll[index]);
                                },
                                style: ButtonStyle(
                                  alignment: Alignment.centerRight,
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromARGB(255, 161, 6, 6)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  "Decline",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )),
          )
        ],
      ),
      drawer: MyDrawer(isteach: true, student: false,username: username),
    );
  }
}
