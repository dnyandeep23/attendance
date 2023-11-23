import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class ReadExcel extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final String code;
  final String courseName;
  const ReadExcel(
      {Key? key,
      required this.screenWidth,
      required this.screenHeight,
      required this.code,
      required this.courseName})
      : super(key: key);

  @override
  _ReadExcelState createState() => _ReadExcelState(
      screenWidth: screenWidth,
      screenHeight: screenHeight,
      code: code,
      courseName: courseName);
}

class _ReadExcelState extends State<ReadExcel> {
  final String code;
  final String courseName;
  File? _pickedFile;
  bool filepicked = false;
  final double screenWidth;
  final double screenHeight;
  String message = '';
  int color = 0;
  _ReadExcelState(
      {required this.screenWidth,
      required this.screenHeight,
      required this.code,
      required this.courseName});
  late var jsonVar;
  List<String> rowdetail = [];
  Future<void> pickXLSXFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'csv'],
    );

    if (result != null) {
      setState(() {
        filepicked = true;
        _pickedFile = File(result.files.single.path!);
      });

      // await _readAndExtractData(_pickedFile!);
    } else {}
  }

  Future<void> convertXlsxToJson(File file) async {
    try {
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      Map<String, dynamic> jsonData = {};

      for (var table in excel.tables.keys) {
        var sheet = excel.tables[table]!;
        var rows = sheet.rows;

        for (var i = 0; i < rows.length; i++) {
          if (i == 0) {
            continue; // Skip the first row (headers)
          }

          var rowData = <String, dynamic>{};

          for (var j = 0; j < rows[i].length; j++) {
            var cellValue = rows[i][j]?.value;

            if (cellValue != null) {
              if (cellValue is Data) {
                rowData[rows[0][j]?.value.toString() ?? ''] =
                    cellValue.value.toString();
              } else {
                rowData[rows[0][j]?.value.toString() ?? ''] =
                    cellValue.toString();
              }
            } else {
              rowData[rows[0][j]?.value.toString() ?? ''] =
                  ''; // Assign an empty string for null cells
            }
          }

          if (jsonData.containsKey(table)) {
            jsonData[table].add(rowData);
          } else {
            jsonData[table] = [rowData];
          }
        }
      }

      jsonVar = json.encode(jsonData);
      print(jsonVar);

      for (var element in jsonData['Sheet1']) {
        // Accessing properties of the current element
        String enrollmentNo = element['Enrollment No'].toString();
        String firstName = element['FirstName'].toString();
        String lastName = element['LastName'].toString();
        String instituteName = element['Institute Name'].toString();
        String mobileNo = element['Mobile No'].toString();

        // Printing or using the data
        print('Enrollment No: $enrollmentNo');
        print('First Name: $firstName');
        print('Last Name: $lastName');
        print('Institute Name: $instituteName');
        print('Mobile No: $mobileNo');
        print('\n');

        storeData(enrollmentNo, firstName, lastName, instituteName, mobileNo,
            enrollmentNo);
      }
    } catch (e) {
      print(e);
    }

    // Display the JSON data
  }

  void storeData(String enrol, String first, String last, String institute,
      String mob, String pass) async {
    print("Entered");
    bool exsits = false;
    DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref().child('student');
    DatabaseReference courseRef =
        FirebaseDatabase.instance.ref().child('course_codes');
    DataSnapshot userSnapshot;
    await databaseRef
        .child(enrol)
        .once()
        .then((DatabaseEvent databaseEvent) async {
      userSnapshot = databaseEvent.snapshot;
      // print(userSnapshot);
      if (userSnapshot.value != null) {
        Map<dynamic, dynamic>? userData = userSnapshot.value as Map?;
        userData?.forEach((key, value) {
          if (value['studentId'] == enrol) {
            databaseRef.child(enrol).child(code).update({
              'courseCode': code,
              'courseName': courseName,
            });
            courseRef.child(code).child('student').child(enrol).set({
              'firstName': first,
              'lastName': last,
              'studentId': enrol,
            });

            exsits = true;
            return;
          } else {
            exsits = false;
          }
        });
      }
    });

    if (exsits == false) {
      try {
        print(code);
        databaseRef.child(enrol).update({
          'Mobile': mob,
          'Password': pass,
          'firstName': first,
          'lastName': last,
          'instituteName': institute,
          'studentId': enrol
        });
        await databaseRef.child(enrol).child('course').child(code).update({
          'courseCode': code,
          'courseName': courseName,
        });
        await courseRef.child(code).child('student').child(enrol).set({
          'firstName': first,
          'lastName': last,
          'studentId': enrol,
        });
        setState(() {
          message = "Student Stored Successfully";
          color = 0xFF38FB02;
        });
        Future.delayed(const Duration(milliseconds: 2000), () {
          setState(() {
            message = '';
          });
        });
      } catch (e) {
        setState(() {
          message = "Failed to store student: $e"; // Print the error message
          color = 0xFFFF0000;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Divider(color: Colors.white),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        InkWell(
          onTap: () {
            !filepicked ? pickXLSXFile() : null;
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            child: DottedBorder(
              borderType: BorderType.RRect,
              color: Colors.white,
              radius: const Radius.circular(20),
              strokeWidth: 2,
              dashPattern: const [8, 2, 8, 2],
              child: Stack(children: [
                Container(
                  alignment: Alignment.center,
                  width: screenWidth * 0.88,
                  height: screenHeight * 0.2,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(50, 255, 255, 255),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      filepicked
                          ? Icon(
                              CupertinoIcons.checkmark_circle_fill,
                              color: Colors.white,
                              size: screenWidth * 0.1,
                            )
                          : Icon(
                              CupertinoIcons.doc_chart_fill,
                              color: Colors.white,
                              size: screenWidth * 0.1,
                            ),
                      SizedBox(
                        width: screenWidth * 0.03,
                      ),
                      filepicked
                          ? Text(
                              "${_pickedFile!.path.split('/').last}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )
                          : Text(
                              "Upload CSV or XLSX File",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                    ],
                  ),
                ),
                filepicked
                    ? Positioned(
                        top: 10,
                        right: 10,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              filepicked = false;
                              _pickedFile!.writeAsString('');
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: screenWidth * 0.12,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(200)),
                            width: screenWidth * 0.12,
                            child: Icon(
                              CupertinoIcons.delete_solid,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      )
                    : SizedBox()
              ]),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        Text("$message", style: TextStyle(color: Color(color), fontSize: 18)),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        ElevatedButton(
            onPressed: () {
              convertXlsxToJson(_pickedFile!);
            },
            style: ButtonStyle(
              side: MaterialStatePropertyAll(BorderSide(color: Colors.black)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Submit",
                style: TextStyle(
                  fontFamily: 'postnobillbold',
                  fontSize: 29,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
        SizedBox(height: MediaQuery.of(context).size.height * 0.04),
      ],
    );
  }
}
