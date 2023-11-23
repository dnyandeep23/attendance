// ignore_for_file: avoid_print, unused_local_variable, avoid_function_literals_in_foreach_calls

import 'dart:async';
import 'dart:math';
import 'package:attedance/Pages/teachverify.dart';
import 'package:attedance/Utils/attendanceModel.dart';
import 'package:attedance/Utils/convertexcel.dart';
import 'package:attedance/Utils/drawer.dart';
import 'package:attedance/Utils/header.dart';
import 'package:attedance/Utils/studentdatamodel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewTeach extends StatefulWidget {
  final String name; // Declare the variable as final
  final String username;
  final String code;
  final bool approved;
  const MapViewTeach({
    Key? key,
    required this.name,
    required this.username,
    required this.code,
    required this.approved,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _MapViewStateTeach createState() =>
      // ignore: no_logic_in_create_state
      _MapViewStateTeach(
          username: username, coursecode: code, approved: approved);
}

class _MapViewStateTeach extends State<MapViewTeach> {
  late GoogleMapController mapController;
  String username;
  String coursecode;
  final bool approved;
  _MapViewStateTeach({
    required this.username,
    required this.coursecode,
    required this.approved,
  });
  List<AttendanceData> students = [];
  final Map<String, Marker> _markers = {};
  final Map<String, Circle> _circles = {};
  double radiusValue = 0.0;

  List<String> list = [];
  late double userLatitude = 0.0;
  late double userLongitude = 0.0;
  late LatLng currentLoc = const LatLng(0.0, 0.0);
  late LatLng oldCurrentLoc = const LatLng(0.0, 0.0);
  late Timer locationTimer;
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> presentList = [];
  List<String> presentlist = [];
  List<String> absentList = [];
  List studentList = [];
  List<StudentLocation> studList = [];
  bool isLoadingMarkers = true;
  @override
  void initState() {
    super.initState();

    storeStudents();
    if (_markers.isEmpty) {
      setState(() {
        isLoadingMarkers = true;
      });
    } else {
      setState(() {
        isLoadingMarkers = false;
      });
    }

    _setLoc();
    startLocationUpdates();
    locationTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _setLoc();
      if (_markers.isEmpty) {
        setState(() {
          isLoadingMarkers = true;
        });
      } else {
        setState(() {
          isLoadingMarkers = false;
        });
      }
      // storeStudents();
    });

    Geolocator.getPositionStream(
      locationSettings: AndroidSettings(
          forceLocationManager: true,
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 1,
          foregroundNotificationConfig: const ForegroundNotificationConfig(
              notificationTitle: 'Attendance Go',
              notificationText: 'Location for attendance')),

      // For Android
    ).listen((Position position) {
      // Handle location updates here
      _setLoc();
    });
  }

  void storeStudents() async {
    DatabaseReference data =
        FirebaseDatabase.instance.ref().child('course_codes');

    DataSnapshot dataSnap;
    DatabaseReference stud = FirebaseDatabase.instance.ref().child('student');

    DataSnapshot studSnap;

    await data
        .child(coursecode)
        .child('student')
        .once()
        .then((DatabaseEvent databaseEvent) async {
      dataSnap = databaseEvent.snapshot;
      print(dataSnap.value);
      // print(coursecode);
      Map<dynamic, dynamic>? courseData = dataSnap.value as Map?;
      List<String> studname = [];
      if (courseData != null) {
        courseData.forEach((key, value) {
          if (value is Map && value.containsKey('studentId')) {
            String sid = value['studentId'].toString();
            studname.add(sid);
          }
        });
        setState(() {
          studentList = studname;
        });
      } else {
        print("False info");
      }
    });

    await stud.once().then((DatabaseEvent de) {
      studSnap = de.snapshot;
      print(studSnap.value);
      Map<dynamic, dynamic>? studData = studSnap.value as Map?;

      if (studData != null) {
        print('Entered');
        studData.forEach((key, value) {
          if (value is Map &&
              studentList.contains(value['studentId'].toString())) {
            String studentId = value['studentId'];
            String firstName = value['firstName'];
            String lastName = value['lastName'];
            double latitude = value['latitude'] ?? 0.0;
            double longitude = value['longitude'] ?? 0.0;

            StudentLocation studentLocation = StudentLocation(
              studentId: studentId,
              firstName: firstName,
              lastName: lastName,
              latitude: latitude,
              longitude: longitude,
            );

            setState(() {
              studList.add(studentLocation);
            });
          } else {
            print(studData['studentId']);
          }
        });
       

        absentList.clear();
        presentList.clear();

        for (StudentLocation studentLocation in studList) {
          String studentId = studentLocation.studentId;
          String firstName = studentLocation.firstName;
          String lastName = studentLocation.lastName;
          double latitude = studentLocation.latitude;
          double longitude = studentLocation.longitude;

          // Now you can work with each element of studList as needed
          print('Student ID: $studentId');
          print('First Name: $firstName');
          print('Last Name: $lastName');
          print('Latitude: $latitude');
          print('Longitude: $longitude');

          checkUserInLoc(LatLng(latitude, longitude),
              '$studentId $firstName $lastName', studentId);

          // Add your logic here for each element in studList
        }
      } else {
        print('Escaped');
      }
    });
  }

  void startLocationUpdates() {
    setState(() {
      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.bestForNavigation),
      ).listen((Position position) {
        _setLoc();
      });
    });
  }

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied, cannot request permissions.';
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied.';
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }

  Future<void> _setLoc() async {
    try {
      Position position = await _getCurrentPosition();
      // ignore: unnecessary_null_comparison
      setState(() {
        oldCurrentLoc = currentLoc;
        currentLoc = LatLng(position.latitude, position.longitude);
      });
      // ignore: unnecessary_null_comparison
      if (position != null) {
        userLatitude = position.latitude;
        userLongitude = position.longitude;

        final initialCameraPosition = CameraPosition(
          target: currentLoc,
          zoom: 19,
        );

        final updatedMarker = Marker(
          markerId: const MarkerId("marker"),
          position: currentLoc,
        );
        // _addMarker(currentLoc, 'marker1', 'User Location');
        // Update the _markers map with the new marker
        setState(() {
          // Update the _markers map with the new marker
          _markers["marker"] = updatedMarker;
        });

        setState(() {
          final updatedCircle = Circle(
              circleId: const CircleId('1'),
              radius: radiusValue,
              strokeWidth: 2,
              fillColor: const Color.fromARGB(255, 184, 255, 140),
              center: LatLng(position.latitude, position.longitude));
          _circles["circle"] = updatedCircle;
        });

        storeCircleInformation(
            position.latitude, position.longitude, radiusValue);
        // _markers["marker"] = updatedMarker;

        mapController.animateCamera(
            CameraUpdate.newCameraPosition(initialCameraPosition));

        DatabaseReference databaseRef =
            FirebaseDatabase.instance.ref().child('student');
        await databaseRef.child(username).update({
          'latitude': position.latitude,
          'longitude': position.longitude,
        });

        // print("currentLoc : $currentLoc");
        // print("position : $position");
      } else {
        print('null');
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void storeCircleInformation(
      double latitude, double longitude, double radiusValue) {
    // Convert circle information to a map
    Map<String, dynamic> circleData = {
      'center': {'latitude': latitude, 'longitude': longitude},
      'radius': radiusValue,
      'strokeWidth': 2,
      'fillColor': Colors.lime.value,
    };

    // Replace 'your_admin_id' with the actual admin ID

    // Update the circle information in Firebase
    databaseRef
        .child('teacher')
        .child(username)
        .update({'circle': circleData}).then((_) {
      print("Circle information stored in Firebase");
    }).catchError((error) {
      print("Error storing circle information: $error");
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the screen is disposed
    locationTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    double bottomSheetHeight = MediaQuery.of(context).size.height * 0.81;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SizedBox(
            height: screenHeight,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentLoc,
                zoom: 1,
              ),
              onMapCreated: (controller) {
                setState(() {
                  mapController = controller;
                });
              },
              markers: _markers.values.toSet(),
              circles: _circles.values.toSet(),
              zoomControlsEnabled: false,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onHorizontalDragStart: (details) {
                _showRadiusSettingSheet();
              },
              onTap: () {
                // storeStudents();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.9),
                  // border: Border(
                  //   top: BorderSide(
                  //     color: Colors.red, // Border color
                  //     width: 2.0, // Border width
                  //   ),
                  // ),
                ),
                height: 50,
                child: Center(
                  child: Text(
                    'Radius: ${radiusValue.toStringAsFixed(2)} meters',
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'postnobillbold'),
                  ),
                ),
              ),
            ),
          ),
          Stack(
            children: [
              Header(screenHeight: screenHeight, screenWidth: screenWidth,isStud:false),
              Positioned(
                right: 0,
                top: screenHeight * 0.085,
                child: GestureDetector(
                  onHorizontalDragStart: (details) {
                    _scaffoldKey.currentState!.openEndDrawer();
                  },
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(230, 0, 0, 0),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            topLeft: Radius.circular(20))),
                    child: const Icon(
                      CupertinoIcons.search,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              isLoadingMarkers
                  ? Positioned(
                      bottom: screenHeight * 0.4,
                      left: screenWidth * 0.1,
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(220, 0, 0, 0),
                            border: Border.all(
                                color: const Color.fromARGB(255, 241, 222, 222),
                                width: 2),
                            borderRadius: BorderRadius.circular(20)),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 40.0, horizontal: 32.0),
                          child: Column(
                            children: [
                              CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 4,
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                'Your Location is being updated',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ],
      ),
      drawer:MyDrawer(isteach: approved,student:false, username: username),
      endDrawer: AnimatedContainer(
        duration: const Duration(seconds: 2),
        decoration: BoxDecoration(
            color: Color.fromARGB(230, 0, 0, 0),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50), topLeft: Radius.circular(50))),
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
          child: SizedBox(
            height: bottomSheetHeight,
            width: MediaQuery.of(context).size.width,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Students',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'poppinsBold',
                        fontSize: 34),
                  ),
                  SizedBox(
                    width: screenWidth * 0.15,
                  ),
                  InkWell(
                    onTap: () {
                      storeStudents();
                    },
                    child: const Icon(
                      CupertinoIcons.arrow_2_circlepath_circle_fill,
                      color: Colors.white,
                      size: 50,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(color: Colors.white, thickness: 2),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(40),
                ),
                height: screenHeight * 0.3,
                child: ListView(
                  // Wrap the Column with a ListView
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                          top: 0, left: 24, right: 24, bottom: 0),
                      child: Text(
                        'Present Students',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'postnobillbold',
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(color: Colors.white, thickness: 1),
                    ),
                    const SizedBox(width: 5),
                    presentList.isNotEmpty
                        ? Column(
                            children: presentList.map((adminName) {
                              return ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    adminName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17.2,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          )
                        : const Center(
                            child: Text(
                              'No Students',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.015,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(40),
                ),
                height: screenHeight * 0.3,
                child: ListView(
                  // Wrap the Column with a ListView
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                          top: 0, left: 24, right: 24, bottom: 0),
                      child: Text(
                        'Absent Students',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'postnobillbold',
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(color: Colors.white, thickness: 1),
                    ),
                    const SizedBox(width: 10),
                    absentList.isNotEmpty
                        ? Column(
                            children: absentList.map((adminName) {
                              return ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    adminName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17.2,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          )
                        : const Center(
                            child: Text(
                              'No Students',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Material(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        print('Work');
                        downloadExcel(screenWidth);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            CupertinoIcons.arrow_down_doc,
                            color: Colors.black,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.55,
                    ),
                    InkWell(
                      onTap: () {
                        print('Work');
                        storeId();
                        allowAttendance();
                        // storeAttendance();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            CupertinoIcons.calendar_today,
                            color: Colors.black,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void storeId() async {
    DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref().child('course_codes');

    print(presentlist);
    for (String a in presentlist) {
      await databaseRef
          .child(coursecode)
          .child('allowedStuds')
          .child(a)
          .update({'enrollment': a});
    }
  }

  int generateRandomTwoDigitNumber() {
    final random = Random();
    return 10 +
        random.nextInt(90); // Generates a random number between 10 and 99
  }

  void allowAttendance() {
    storeId();
    int n1, n2, n3;

    do {
      n1 = generateRandomTwoDigitNumber();
      n2 = generateRandomTwoDigitNumber();
      n3 = generateRandomTwoDigitNumber();
    } while (n1 == n2 || n1 == n3 || n2 == n3);

    final List<int> numbers = [n1, n2, n3];
    final Random random = Random();
    final int selectedIndex = random.nextInt(3); // Randomly selects 0, 1, or 2
    final int res = numbers[selectedIndex];

    DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref().child('course_codes');
    double sec = 30.0;
    databaseRef.child(coursecode).update({
      'attendance': true,
      'timer': sec,
      'n1': n1,
      'n2': n2,
      'n3': n3,
      'res': res,
    });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Teachverify(code: coursecode, res: res)));

    Timer(Duration(seconds: sec.toInt()), () {
      databaseRef.child(coursecode).update({
        'attendance': false,
        'timer': 0,
        'n1': 0,
        'n2': 0,
        'n3': 0,
        'res': 0,
      });
    });
  }

  void storeAttendance() async {
    print('Enter');
    DateTime now = DateTime.now();
    String date =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    DatabaseReference newRef =
        FirebaseDatabase.instance.ref().child('course_codes');

    for (String element in presentList) {
      List<String> parts = element.split(' ');
      String sid = parts[0];
      String fname = parts[1];
      String lname = parts[2];
      print('present sid : $sid');

      await newRef
          .child(coursecode)
          .child('Stud_att')
          .child(date)
          .child('Present')
          .child(sid)
          .update({
        'EnrollmentNo': sid,
        'FirstName': fname,
        'LastName': lname,
        'status': 'Present'
      });
    }

    for (String element in absentList) {
      List<String> parts = element.split(' ');
      String sid = parts[0];
      String fname = parts[1];
      String lname = parts[2];
      print(' absent sid : $sid');

      await newRef
          .child(coursecode)
          .child('Stud_att')
          .child(date)
          .child('Absent')
          .child(sid)
          .update({
        'EnrollmentNo': sid,
        'FirstName': fname,
        'LastName': lname,
        'status': 'Absent'
      });
    }
  }

  void downloadExcel(double screenWidth) async {
    DateTime now = DateTime.now();
    String date =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref().child('course_codes');

    DataSnapshot dataSnapshot;
    await databaseRef
        .child(coursecode)
        .child('Stud_att')
        .child(coursecode)
        .child('Present')
        .once()
        .then((DatabaseEvent databaseEvent) async {
      dataSnapshot = databaseEvent.snapshot;

      Map<dynamic, dynamic>? courseData = dataSnapshot.value as Map?;

      if (courseData != null) {
        courseData.forEach((key, value) {
          if (value is Map) {
            String enroll = value['EnrollmentNo'];
            String name = value['FirstName'];
            String lname = value['LastName'];
            String status = value['status'];
            list.add(enroll);
            print(enroll);
            AttendanceData student = AttendanceData(
              enrollment: enroll,
              firstName: name,
              lastName: lname,
              status: status,
              date: date,
            );
            students.add(student);
          }
        });
      }
    });

    DataSnapshot studSnapshot;
    await databaseRef
        .child(coursecode)
        .child('student')
        .once()
        .then((DatabaseEvent databaseEvent) async {
      studSnapshot = databaseEvent.snapshot;

      Map<dynamic, dynamic>? courseData = studSnapshot.value as Map?;

      if (courseData != null) {
        courseData.forEach((key, value) {
          if (value is Map || value != null) {
            String enroll = value['studentId'] ??
                ''; // Provide an empty string as a default value
            String name = value['firstName'] ??
                ''; // Provide an empty string as a default value
            String lname = value['lastName'] ?? '';

            if (!list.contains(enroll)) {
              print("an" + enroll);
              AttendanceData student = AttendanceData(
                enrollment: enroll,
                firstName: name,
                lastName: lname,
                status: 'Absent',
                date: date,
              );
              
              students.add(student);
            }
          }
        });
      }
    });

    exportStudentsToExcel(students, screenWidth);
  }

  bool isLocationWithinCircle(double userLat, double userLon,
      double circleCenterLat, double circleCenterLon, double circleRadius) {
    const earthRadius = 6371000; // Radius of the Earth in meters

    double dLat = (circleCenterLat - userLat) * (pi / 180);
    double dLon = (circleCenterLon - userLon) * (pi / 180);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(userLat * (pi / 180)) *
            cos(circleCenterLat * (pi / 180)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = earthRadius * c;

    return distance <= circleRadius;
  }

  void checkUserInLoc(LatLng user, String name, String studId) async {
    DatabaseEvent e = await databaseRef
        .child('teacher')
        .child(username)
        .child('circle')
        .once();
    DataSnapshot snapshot = e.snapshot;
    print(snapshot.value);
    Map<dynamic, dynamic> circleData = snapshot.value as Map<dynamic, dynamic>;
    double circleCenterLat = circleData['center']['latitude'].toDouble();
    double circleCenterLon = circleData['center']['longitude'].toDouble();
    double circleRadius = circleData['radius'].toDouble();

    double userLat = user.latitude;
    double userLon = user.longitude;

    bool isInside = isLocationWithinCircle(
        userLat, userLon, circleCenterLat, circleCenterLon, circleRadius);

    if (isInside) {
      if (!presentList.contains(name)) {
        print('Adding $name to presentList');
        presentList.add(name);
        presentlist.add(studId);
        // CustomToast.showToast(context, "$name is inside");
        print('$name is inside');
      } else {
        print('$name is already in presentList');
      }

      if (absentList.contains(name)) {
        print('Removing $name from absentList');
        absentList.remove(name);
      }
    } else {
      if (!absentList.contains(name)) {
        print('Adding $name to absentList');
        absentList.add(name);
        // CustomToast.showToast(context, "$name is outside");
        print('$name is outside');
      } else {
        print('$name is already in absentList');
      }

      if (isInside) {
        if (!presentList.contains(name)) {
          print('Adding $name to presentList');
          presentList.add(name);
          presentlist.add(studId);
          // CustomToast.showToast(context, "$name is inside");
          print('$name is inside');
        } else {
          print('$name is already in presentList');
        }

        // if (absentList.contains(name)) {
        //   print('Removing $name from absentList');
        //   absentList.remove(name);
        // }
      } else {
        if (!absentList.contains(name)) {
          print('Adding $name to absentList');
          absentList.add(name);
          // CustomToast.showToast(context, "$name is outside");
          print('$name is outside');
        } else {
          print('$name is already in absentList');
        }

        if (presentList.contains(name)) {
          print('Removing $name from presentList');
          absentList.remove(name);
        }
      }

    }
  }

  void _showRadiusSettingSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        double sheetHeight = 300; // Initial height of the bottom sheet

        return StatefulBuilder(
          builder: (context, setState) {
            return AnimatedContainer(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Color.fromARGB(255, 0, 0, 0)),
              duration: const Duration(milliseconds: 500), // Animation duration
              height: sheetHeight,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    'Set Radius',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'poppinsBold',
                        color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Choose the radius value:',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'poppinsBold',
                        color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    activeColor: Colors.amber,
                    min: 0,
                    value: radiusValue,
                    max: 100,
                    divisions: 100,
                    label: radiusValue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        radiusValue = value;
                        _setLoc();
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Radius: ${radiusValue.toStringAsFixed(2)} meters',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'poppinsBold',
                        color: Colors.white),
                  ), // Display the value
                ],
              ),
            );
          },
        );
      },
    );
  }
}
