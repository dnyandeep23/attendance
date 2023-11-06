// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

Future<void> initializeService({required String username}) async {
  final service = FlutterBackgroundService();
  // AndroidNotificationChannel channel = const AndroidNotificationChannel(
  //     '1', "Attendance",
  //     description: 'hello', importance: Importance.high);
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  // await service.configure(
  //     iosConfiguration: IosConfiguration(),
  //     androidConfiguration: AndroidConfiguration(
  //       onStart: onStart,
  //       isForegroundMode: true,
  //       autoStart: true,
  //       notificationChannelId: "1",
  //       initialNotificationTitle: "Attendance",
  //       foregroundServiceNotificationId: 888,
  //     ));

  // service.startService();
}

@pragma('vm-entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  await Firebase.initializeApp();
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  // service.on('stopService').listen((event) {
  //   service.stopSelf();
  // });

  Timer.periodic(const Duration(seconds: 100000), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        // ignore: avoid_print
        // print("hello");
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            forceAndroidLocationManager: true);
        DatabaseReference databaseRef =
            FirebaseDatabase.instance.ref().child('student');
        await databaseRef.child('FH21CO003').update({
          'latitude': position.latitude,
          'longitude': position.longitude,
        }).catchError((E) => print(E.toString()));

// notification hein halke mein mat lena

        // flutterLocalNotificationsPlugin.show(
        //     88,
        //     "Attendance Go",
        //     "Feature Enabled",
        //     const NotificationDetails(
        //         android: AndroidNotificationDetails("1", "Attendance",
        //             channelDescription: 'hello', icon: 'ic_bg_service_small')));
      }
    }
  });
}
