// ignore_for_file: avoid_print

import 'dart:async';
import 'package:attedance/Pages/verification.dart';
import 'package:attedance/Utils/background.dart';
import 'package:attedance/Utils/customToast.dart';
import 'package:attedance/Utils/drawer.dart';
import 'package:attedance/Utils/header.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewWidget extends StatefulWidget {
  final String name; // Declare the variable as final
  final String username;
  final String code;
  const MapViewWidget({
    Key? key,
    required this.name,
    required this.username,
    required this.code,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _MapViewState createState() => _MapViewState(username: username, code: code);
}

class _MapViewState extends State<MapViewWidget> {
  late GoogleMapController mapController;
  String username;
  String code;
  _MapViewState({required this.username, required this.code});

  final Map<String, Marker> _markers = {};

  bool isLoadingMarkers = true;
  late double userLatitude = 0.0;
  late double userLongitude = 0.0;
  late LatLng currentLoc = const LatLng(0.0, 0.0);
  late Timer locationTimer;
  bool isVisited = false;
  String message = '';
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  int a = 0xFF000000;
  bool showSnack = false;
  @override
  void initState() {
    super.initState();
    _setLoc();
    startLocationUpdates();
    if (_markers.isEmpty) {
      setState(() {
        isLoadingMarkers = true;
      });
    } else {
      setState(() {
        isLoadingMarkers = false;
      });
    }

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
    });

    Geolocator.getPositionStream(
      locationSettings: AndroidSettings(
          forceLocationManager: true,
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 10,
          foregroundNotificationConfig: const ForegroundNotificationConfig(
              notificationTitle: 'Attendance Go',
              notificationText: 'Location for attendance')),
    ).listen((Position position) {
      _setLoc();
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
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
  }

  Future<void> _setLoc() async {
    try {
      Position position = await _getCurrentPosition();
      if (position != null) {
        currentLoc = LatLng(position.latitude, position.longitude);
        userLatitude = position.latitude;
        userLongitude = position.longitude;

        final initialCameraPosition = CameraPosition(
          target: currentLoc,
          zoom: 15,
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
        // _markers["marker"] = updatedMarker;

        mapController.animateCamera(
            CameraUpdate.newCameraPosition(initialCameraPosition));

        DatabaseReference databaseRef =
            FirebaseDatabase.instance.ref().child('student');
        await databaseRef.child(username).update({
          'latitude': position.latitude,
          'longitude': position.longitude,
        });
      } else {
        print('null');
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  @override
  void dispose() {
    // Cancel the timer when the screen is disposed
    locationTimer.cancel();
    super.dispose();
  }

  void markAttendance(double screenWidth) async {
    DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref().child('course_codes');
    DatabaseReference studRef =
        FirebaseDatabase.instance.ref().child('course_codes');

    DataSnapshot dataSnapshot;
    await databaseRef
        .child(code)
        .once()
        .then((DatabaseEvent databaseEvent) async {
      dataSnapshot = databaseEvent.snapshot;

      Map<dynamic, dynamic>? data = dataSnapshot.value as Map?;

      if (data != null) {
        bool attendance = data['attendance'];
        int num1 = data['n1'];
        int num2 = data['n2'];
        int num3 = data['n3'];
        int res = data['res'];
        int timer = data['timer'];

        // print("attendance $attendance");
        // print("n1 $num1");
        // print("n2 $num2");
        // print("n3 $num3");
        // print("res $res");
        // print("timer $timer");
        if (attendance == true) {
          if (isVisited == false) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyPage(
                        attendance: attendance,
                        num1: num1,
                        num2: num2,
                        num3: num3,
                        res: res,
                        timer: timer,
                        username: username,
                        code: code)));
            Future.delayed(Duration(seconds: 2), () {
              setState(() {
                isVisited = true;
                message = "You have marked your attendance already...";
              });
            });
            Future.delayed(Duration(seconds: 30), () {
              setState(() {
                isVisited = false;
                message = "";
              });
            });
          }
        } else {
          DataSnapshot studSnapshot;
          await studRef
              .child(code)
              .child('allowedStuds')
              .once()
              .then((DatabaseEvent databaseEvent) async {
            studSnapshot = databaseEvent.snapshot;
            Map<dynamic, dynamic>? stud = studSnapshot.value as Map?;

            if (stud != null) {
              stud.forEach((key, value) {
                if (value['enrollment' == code]) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyPage(
                              attendance: attendance,
                              num1: num1,
                              num2: num2,
                              num3: num3,
                              res: res,
                              timer: timer,
                              username: username,
                              code: code)));
                } else {
                  setState(() {
                    showSnack = true;
                    message = "Your Teacher Has not started Attendance Yet...";
                  });

                  Future.delayed(const Duration(seconds: 2), () {
                    setState(() {
                      showSnack = false;
                      message = "";
                    });
                  });
                }
              });
            } else {
              setState(() {
                showSnack = true;
                message = "Your Teacher Has not started Attendance Yet...";
              });
              Future.delayed(const Duration(seconds: 2), () {
                setState(() {
                  showSnack = false;
                  message = "";
                });
              });
            }
          });
        }
      } else {
        print("No found");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SizedBox(
            height: screenHeight,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentLoc,
                zoom: 25,
              ),
              onMapCreated: (controller) {
                setState(() {
                  mapController = controller;
                });
              },
              markers: _markers.values.toSet(),
              zoomControlsEnabled: false,
            ),
          ),
          Container(
            color: const Color.fromARGB(90, 0, 0, 0),
          ),
          Header(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              isStud: true),
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
              : const SizedBox(),
          Positioned(
            bottom: 10,
            left: 4,
            child: InkWell(
              onTap: () {
                setState(() {
                  a = 0xFF2B2929;
                });

                Future.delayed(const Duration(microseconds: 3), () {
                  a = 0xFF000000;
                });

                markAttendance(screenWidth);
                // setState(() {
                //   showSnack = true;
                // });
                // Future.delayed(Duration(seconds: 2), () {
                //   setState(() {
                //     showSnack = false;
                //   });
                // });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Color(a),
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(20)),
                width: screenWidth * 0.98,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Mark My Attendance",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.none,
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
          ),
          showSnack || isVisited
              ? Positioned(
                  top: screenHeight * 0.3,
                  left: screenWidth * 0.02,
                  child: Container(
                    alignment: Alignment.center,
                    width: screenWidth * 0.95,
                    height: screenHeight * 0.1,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(170, 0, 0, 0),
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "$message",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
      drawer: MyDrawer(isteach: false, student: true,username: username),
    );
  }
}
