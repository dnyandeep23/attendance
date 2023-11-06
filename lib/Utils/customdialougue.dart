import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CustomStatefulDialog extends StatefulWidget {
  final String name;
  final String username;
  final GlobalKey<FormState> studCourse;
  const CustomStatefulDialog(
      {super.key,
      required this.name,
      required this.username,
      required this.studCourse,
      });
  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _CustomStatefulDialogState createState() =>
      _CustomStatefulDialogState(name: name, username: username,studCourse: studCourse);
}

class _CustomStatefulDialogState extends State<CustomStatefulDialog> {
  final String name;
  final String username;
final GlobalKey<FormState> studCourse;
  TextEditingController courseCode = TextEditingController();
  String message = '';
  bool err = false;
  bool click = false;

  _CustomStatefulDialogState({required this.name, required this.username,required this.studCourse});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: const BorderSide(color: Colors.grey, width: 1.0),
      ),
      backgroundColor: const Color.fromARGB(150, 0, 0, 0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Create a Course',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'poppinsBold',
                fontSize: 20,
              ),
            ),
            const Divider(
              color: Colors.white,
            ),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: courseCode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Course name is required';
                      } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                        return 'Only letters are allowed';
                      } else {
                        return null; // No validation error
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Course Code',
                      labelStyle: TextStyle(
                        textBaseline: TextBaseline.alphabetic,
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    cursorColor: Colors.white,
                    cursorHeight: 20,
                    style: const TextStyle(
                      textBaseline: TextBaseline.alphabetic,
                      color: Colors.white,
                      fontFamily: 'poppinsBold',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  if (err)
                    Text(
                      message,
                      style: const TextStyle(
                        color: Colors.red,
                        fontFamily: 'poppinsBold',
                        fontSize: 14,
                      ),
                    ),
                  if (err) SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (studCourse.currentState!.validate()) {
                        // Course name is valid, proceed to generate code
                        setState(() {
                          click = true;
                          _storeInDatabase();
                        });
                      }

                      // err ? showSnack() : null;
                      Navigator.pop(context);
                      // showSnack();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'poppinsBold',
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _storeInDatabase() async {
    String code = courseCode.text.toUpperCase();
    DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref().child('course_codes');

    DatabaseReference studentRef =
        FirebaseDatabase.instance.ref().child('student');
    // print("Hello");

    DataSnapshot courseSnap;
    // Check if the user already exists in the database
    await databaseRef.once().then((DatabaseEvent databaseEvent) async {
      courseSnap = databaseEvent.snapshot;
      print(courseSnap.value);

      String myname = name.toString();
      if (courseSnap.value != null) {
        Map<dynamic, dynamic>? courseData = courseSnap.value as Map?;
        List<String> existingCourseCodes = [];
        List<String> existingCourseName = [];
        List<String> name = myname.split(' ');
        String first = name[0];
        String last = name[1];

        if (courseData != null) {
          courseData.forEach((key, value) {
            String courseCode = value['courseCode']
                .toString(); // Assuming the key is 'courseCode'
            existingCourseCodes
                .add(courseCode); // Add the course code to the list
            String courseName = value['courseName']
                .toString(); // Assuming the key is 'courseCode'
            existingCourseName
                .add(courseName); // Add the course code to the list
          });

          if (existingCourseCodes.contains(code)) {
            print("match");
            setState(() {
              err = true;
              message = '';
            });
            String matchedCourseName = '';
            int indexOfMatch = existingCourseCodes.indexOf(code);
            if (indexOfMatch != -1) {
              matchedCourseName = existingCourseName[indexOfMatch];
            }

            await studentRef
                .child(username)
                .child('course')
                .child(code)
                .update({
              'courseCode': code,
              'courseName': matchedCourseName,
            });

            await databaseRef
                .child(code)
                .child('student')
                .child(username)
                .update({
              'studentId': username,
              'firstName': first,
              'lastName': last,
            });
            // coursesRetrival();
          } else {
            setState(() {
              err = true;
              message = 'Invalid course code';
            });
          }
        }
      }
    });
  }
}
