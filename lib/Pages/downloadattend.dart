import 'package:attedance/Utils/customexcelexport.dart';
import 'package:attedance/Utils/drawer.dart';
import 'package:attedance/Utils/header.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DownloadAttendance extends StatefulWidget {
  final bool isStud;
  final String username;
  const DownloadAttendance(
      {Key? key, required this.isStud, required this.username})
      : super(key: key);

  @override
  _DownloadAttendanceState createState() =>
      _DownloadAttendanceState(isStud: isStud, username: username);
}

class _DownloadAttendanceState extends State<DownloadAttendance> {
  final bool isStud;
  final String username;
  Map<String, dynamic> data = {};
  _DownloadAttendanceState({required this.isStud, required this.username});
  DateTime selectedStartDate = DateTime.now();
  TextEditingController startdateInput = TextEditingController();
  DateTime selectedEndDate = DateTime.now();
  TextEditingController enddateInput = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  TextEditingController code = TextEditingController();

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedStartDate) {
      setState(() {
        selectedStartDate = picked;
        startdateInput.text =
            "${selectedStartDate.year}-${selectedStartDate.month.toString().padLeft(2, '0')}-${selectedStartDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedEndDate) {
      setState(() {
        selectedEndDate = picked;
        enddateInput.text =
            "${selectedEndDate.year}-${selectedEndDate.month.toString().padLeft(2, '0')}-${selectedEndDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      drawer: MyDrawer(isteach: !isStud, student: isStud, username: username),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  // height: screenHeight * 1.03,
                  width: screenWidth,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(100, 148, 147, 147),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(100),
                          bottomRight: Radius.circular(100))),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.1),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/att.png",
                              height: screenHeight * 0.35,
                            )
                          ]),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          margin: EdgeInsets.only(bottom: screenHeight * 0.005),
                          // height: screenHeight * 0.4,
                          width: screenWidth,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(150, 148, 147, 147),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(100),
                                  bottomRight: Radius.circular(100))),
                          child: Form(
                              key: _form,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    SizedBox(height: screenHeight * 0.02),
                                    TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Course Code must be given";
                                        } else if (value.length != 6) {
                                          return "Course code contains 6 characters";
                                        } else if (!RegExp(r'^[a-zA-Z0-9 ]*$')
                                            .hasMatch(value)) {
                                          return "Course code must contain numbers and characters";
                                        }
                                        return null;
                                      },
                                      style: TextStyle(color: Colors.white),
                                      cursorColor: Colors.white,
                                      controller: code,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 2,
                                                  style: BorderStyle.solid)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 2,
                                                  style: BorderStyle.solid)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 2,
                                                  style: BorderStyle.solid)),
                                          label: Text(
                                            "Course Code",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                    ),
                                    SizedBox(height: screenHeight * 0.02),
                                    TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Start Date must be selected";
                                        }
                                        return null;
                                      },
                                      controller: startdateInput,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        icon: Icon(Icons.calendar_today,
                                            color: Colors.white),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2,
                                                style: BorderStyle.solid)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2,
                                                style: BorderStyle.solid)),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2,
                                                style: BorderStyle.solid)),
                                        hintText: "YYYY/MM/DD",
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        label: Text(
                                          "Start Date",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      readOnly: true,
                                      onTap: () {
                                        _selectStartDate(context);
                                      },
                                    ),
                                    SizedBox(height: screenHeight * 0.02),
                                    TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "End Date must be selected";
                                        }
                                        return null;
                                      },
                                      style: TextStyle(color: Colors.white),
                                      controller: enddateInput,
                                      decoration: InputDecoration(
                                        icon: Icon(Icons.calendar_today,
                                            color: Colors.white),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2,
                                                style: BorderStyle.solid)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2,
                                                style: BorderStyle.solid)),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2,
                                                style: BorderStyle.solid)),
                                        hintText: "YYYY/MM/DD",
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        label: Text(
                                          "End Date",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      readOnly: true,
                                      onTap: () {
                                        _selectEndDate(context);
                                      },
                                    ),
                                    SizedBox(height: screenHeight * 0.04),
                                    InkWell(
                                      onTap: () {
                                        retriveData(screenWidth);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            gradient: LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment.bottomLeft,
                                              colors: [
                                                Color.fromARGB(
                                                    255, 198, 196, 196),
                                                Color.fromARGB(
                                                    255, 255, 255, 255),
                                                Color.fromARGB(
                                                    255, 198, 196, 196),
                                              ],
                                            )),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24.0, vertical: 12),
                                          child: Text(
                                            "Submit",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.06),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(
                //   height: screenHeight * 1 * 2,
                // )
              ],
            ),
            Header(
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                isStud: isStud)
          ],
        ),
      ),
    );
  }

  void retriveData(double screenWidth) async {
    if (_form.currentState!.validate()) {
      String coursecode = code.text.toUpperCase().trim();
      String start = startdateInput.text;
      String end = enddateInput.text;
      DateTime startDate = DateTime.parse(start);
      DateTime endDate = DateTime.parse(end);

      DatabaseReference databaseRef =
          FirebaseDatabase.instance.ref().child('course_codes');

      DataSnapshot dataSnapshot;
      await databaseRef
          .child(coursecode)
          .child('Stud_att')
          .once()
          .then((DatabaseEvent databaseEvent) async {
        dataSnapshot = databaseEvent.snapshot;

        Map<dynamic, dynamic>? attendData = dataSnapshot.value as Map?;

        print(attendData);
        if (attendData != null) {
          attendData.forEach((key, value) {
            DateTime rdate = DateTime.parse(key);
            print(rdate);
            if (rdate == startDate ||
                (rdate.isAfter(startDate) && rdate.isBefore(endDate)) ||
                rdate == endDate) {
              String d =
                  "${rdate.year}-${rdate.month.toString().padLeft(2, '0')}-${rdate.day.toString().padLeft(2, '0')}";

              data.addAll({"$d": value});

              print(value);
              createExcelFile(data);
            }
          });
        }
       
      });
    }
  }
}
