import 'package:attedance/Utils/header.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class Teachstudentdata extends StatefulWidget {
  final List enroll;
  final List fname;
  final List lname;
  final int index;
  final String code;
  const Teachstudentdata(
      {Key? key,
      required this.enroll,
      required this.fname,
      required this.lname,
      required this.index,
      required this.code})
      : super(key: key);

  @override
  _TeachstudentdataState createState() => _TeachstudentdataState(
      enroll: enroll, fname: fname, lname: lname, index: index, code: code);
}

class _TeachstudentdataState extends State<Teachstudentdata> {
  final List enroll;
  final List fname;
  final List lname;
  final int index;
  final String code;
  // int Present = 0;
  // int Absent = 0;

  bool record = true;
  int new_index = 0;
  TextEditingController _searchController = TextEditingController();
  double absentt = 1;
  double presentt = 1;
  _TeachstudentdataState({
    required this.enroll,
    required this.fname,
    required this.lname,
    required this.index,
    required this.code,
  });

  String first = "";
  String last = "";
  String enrolmentNo = "";

  bool p = false;

  final dataMap = <String, double>{
    "Present": 0,
    "Absent": 0,
  };

  final gradientList = <List<Color>>[
    [
      Color.fromRGBO(87, 250, 0, 1),
      Color.fromRGBO(54, 170, 38, 1),
    ],
    [
      Color.fromRGBO(255, 4, 0, 1),
      Color.fromRGBO(239, 92, 0, 1),
    ]
  ];

  @override
  void initState() {
    super.initState();
    importData(code, enroll[index]);
    first = fname[index];
    last = lname[index];
    enrolmentNo = enroll[index];
  }

  void handleSearch(String query) {
    bool enrollment = false;
    bool firstname = false;
    bool lastname = false;
    for (int i = 0; i < enroll.length; i++) {
      if (enroll[i].contains(query)) {
        setState(() {
          new_index = i;
          first = fname[i];
          last = lname[i];
          enrolmentNo = enroll[i];
        });
      } else {
        enrollment = true;
      }
    }

    for (int i = 0; i < fname.length; i++) {
      if (fname[i].contains(query)) {
        setState(() {
          new_index = i;
          first = fname[i];
          last = lname[i];
          enrolmentNo = enroll[i];
        });
      } else {
        firstname = true;
      }
    }

    for (int i = 0; i < lname.length; i++) {
      if (lname[i].contains(query)) {
        setState(() {
          new_index = i;
          first = fname[i];
          last = lname[i];
          enrolmentNo = enroll[i];
        });
      } else {
        lastname = true;
      }
    }
    importData(code, enroll[new_index]);
    print(dataMap);

    if (enrollment && firstname && lastname) {
      setState(() {
        record = false;
      });
    }
  }

  void importData(String code, String username) async {
    DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref().child('course_codes');
    DataSnapshot dataSnapshot;

    await databaseRef
        .child(code)
        .child('Stud_Ratio')
        .child(username)
        .once()
        .then((DatabaseEvent databaseEvent) async {
      dataSnapshot = databaseEvent.snapshot;

      Map<dynamic, dynamic>? data = dataSnapshot.value as Map?;
      print(data);
      if (data != null) {
        print("Entered");
        int present = data["Present"] ?? 0;
        int absent = data["Absent"] ?? 0;

        setState(() {
          presentt = present.toDouble();
          absentt = absent.toDouble();
          dataMap.update("Present", (value) => present.toDouble());
          dataMap.update("Absent", (value) => absent.toDouble());
        });
        print("Hellp");
        print(absentt);
        print(presentt);
      }
    });
  }

  void checkData() async {
    DateTime now = DateTime.now();
    String date =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    DatabaseReference dataStud =
        FirebaseDatabase.instance.ref().child('student');

    DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref().child('course_codes');

    String fname;
    String lname;

    int present;
    int absent;

    DataSnapshot dataSnapshot;
    DataSnapshot snapshot;
    await dataStud
        .child(enrolmentNo)
        .once()
        .then((DatabaseEvent databaseEvent) async {
      dataSnapshot = databaseEvent.snapshot;

      Map<dynamic, dynamic>? data = dataSnapshot.value as Map?;
      if (data != null) {
        fname = data['firstName'];
        lname = data['lastName'];

        if (p == true) {
          print("Done");
          databaseRef
              .child(code)
              .child('Stud_att')
              .child(date)
              .child('Present')
              .child(enrolmentNo)
              .update({
            "EnrollmentNo": enrolmentNo,
            "FirstName": fname,
            "LastName": lname,
            'status': 'Present',
          });

          databaseRef
              .child(code)
              .child('Stud_Ratio')
              .child(enrolmentNo)
              .once()
              .then((DatabaseEvent dataEvent) async {
            snapshot = dataEvent.snapshot;

            if (snapshot.value != null && snapshot.exists) {
              // Data is present
              Map<dynamic, dynamic>? studInfo = snapshot.value as Map?;
              present = studInfo?['Present'] ?? 0;
              absent = studInfo?['Absent'] ?? 0;
              print("Entered");
            } else {
              // Data is not present
              present = 1;
              absent = 0;
              print("Closed");
            }

            // Update the data
            databaseRef
                .child(code)
                .child('Stud_Ratio')
                .child(enrolmentNo)
                .update({
              'Present': present + 1,
              'Absent': absent,
            });
          });
          importData(code, enrolmentNo);
        } else {
          databaseRef
              .child(code)
              .child('Stud_att')
              .child(date)
              .child('Absent')
              .child(enrolmentNo)
              .update({
            "EnrollmentNo": enrolmentNo,
            "FirstName": fname,
            "LastName": lname,
            'status': 'Absent',
          });

          databaseRef
              .child(code)
              .child('Stud_Ratio')
              .child(enrolmentNo)
              .once()
              .then((DatabaseEvent dataEvent) async {
            snapshot = dataEvent.snapshot;

            if (snapshot.value != null && snapshot.exists) {
              // Data is present
              Map<dynamic, dynamic>? studInfo = snapshot.value as Map?;
              present = studInfo?['Present'] ?? 0;
              absent = studInfo?['Absent'] ?? 0;
              print("Entered");
            } else {
              // Data is not present
              present = 0;
              absent = 1;
              print("Closed");
            }

            // Update the data
            databaseRef
                .child(code)
                .child('Stud_Ratio')
                .child(enrolmentNo)
                .update({
              'Present': present,
              'Absent': absent + 1,
            });
          });
          print("false");
          importData(code, enrolmentNo);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(children: [
            Header(
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                isStud: true),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(
                      color: Colors.white, height: 1, fontSize: 18),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.white, width: 2)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.white, width: 2)),
                    hintText: 'Search',
                    // labelText: 'Search',

                    counterStyle: TextStyle(color: Colors.white, fontSize: 18),
                    fillColor: const Color.fromARGB(119, 255, 255, 255),
                    hintStyle: TextStyle(color: Colors.white, fontSize: 18),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  onEditingComplete: () {
                    handleSearch(_searchController.text.toUpperCase());
                  }, // Handle the submitted event.
                ),
              ),
            ),
            Center(
              child: Container(
                width: screenWidth * 0.97,
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFFB3B0B0),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(20),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.95,
                ),
                child: record
                    ? Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                bottom: 20), // Add margin between logo and text
                            child: Column(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(
                                      'https://th.bing.com/th/id/R.b06d80c5216d4ab434a001648b9a33be?rik=%2buuxvzkpRcBi7g&riu=http%3a%2f%2fgetdrawings.com%2ffree-icon%2fstudent-icon-transparent-63.png&ehk=NQOKqMtH%2buWNJpJgPDl8tGh4fu57wCu9gh2wdTjyi%2bI%3d&risl=&pid=ImgRaw&r=0'),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '$first $last',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontFamily: 'poppinsBold',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '$enrolmentNo',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 18, 18, 18),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        height: screenHeight * 0.25,
                        child: Column(children: [
                          Image.asset('assets/images/norecord.png'),
                          Text(
                            'No Record Found',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )
                        ])),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: screenWidth * 0.97,
              height: screenHeight * 0.6,
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFFB3B0B0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  PieChart(
                    dataMap: dataMap,
                    animationDuration: Duration(milliseconds: 800),
                    chartLegendSpacing: screenWidth * 0.1,
                    chartRadius: screenWidth * 0.45,
                    // colorList: colorList,
                    initialAngleInDegree: 0,
                    chartType: ChartType.ring,
                    ringStrokeWidth: 40,
                    centerText: "Attendance",
                    legendOptions: const LegendOptions(
                      showLegendsInRow: false,
                      legendPosition: LegendPosition.bottom,
                      showLegends: true,
                      legendShape: BoxShape.circle,
                      legendTextStyle:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    chartValuesOptions: ChartValuesOptions(
                      chartValueBackgroundColor:
                          Color.fromARGB(255, 255, 255, 255),
                      chartValueStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      showChartValueBackground: true,
                      showChartValues: true,
                      showChartValuesInPercentage: true,
                      showChartValuesOutside: false,
                      decimalPlaces: 1,
                    ),
                    gradientList: gradientList,
                    // emptyColorGradient: ---Empty Color gradient---
                  ),
                  SizedBox(
                    height: screenHeight * 0.035,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const Text(
                            "Present",
                            style: TextStyle(
                                fontFamily: 'postnobillbold',
                                fontSize: 40,
                                color: Colors.black),
                          ),
                          Text(
                            "$presentt",
                            style: const TextStyle(
                                fontFamily: 'poppinsBold',
                                fontSize: 25,
                                color: Colors.black),
                          )
                        ],
                      ),
                      SizedBox(
                        width: screenWidth * 0.08,
                      ),
                      Column(
                        children: [
                          Text(
                            "Absent",
                            style: TextStyle(
                                fontFamily: 'postnobillbold',
                                fontSize: 40,
                                color: Colors.black),
                          ),
                          Text(
                            "$absentt",
                            style: TextStyle(
                                fontFamily: 'poppinsBold',
                                fontSize: 25,
                                color: Colors.black),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              // alignment: Alignment.center,
              width: screenWidth * 0.97,
              height: screenHeight * 0.4,
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFFB3B0B0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  Text(
                    "MARK ATTENDANCE \nMANUALLY",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 35,
                        fontFamily: 'postnobillbold'),
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              p = true;
                            });
                            checkData();
                          },
                          style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Color.fromARGB(255, 92, 212, 0)),
                              side: MaterialStatePropertyAll(
                                  BorderSide(color: Colors.white, width: 2))),
                          child: Text(
                            "Present",
                            style: TextStyle(
                                color: const Color.fromARGB(255, 205, 204, 204),
                                fontSize: 22,
                                fontFamily: 'poppinsBold'),
                          )),
                      SizedBox(
                        width: screenWidth * 0.05,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              p = false;
                            });
                            checkData();
                          },
                          clipBehavior: Clip.hardEdge,
                          style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Color.fromARGB(255, 212, 15, 0)),
                              side: MaterialStatePropertyAll(
                                  BorderSide(color: Colors.white, width: 2))),
                          child: const Text(
                            "Absent",
                            style: TextStyle(
                                color: Color.fromARGB(255, 212, 209, 209),
                                fontSize: 22,
                                fontFamily: 'poppinsBold'),
                          )),
                    ],
                  )
                ],
              ),
            )
          ]),
        ));
  }
}
