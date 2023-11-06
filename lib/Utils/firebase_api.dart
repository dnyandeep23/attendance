import 'dart:convert';
import 'package:attedance/Pages/verification.dart';
import 'package:attedance/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm-entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title : ${message.notification?.title}');
  print('Body : ${message.notification?.body}');
  print('Payload : ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
      'high_importance_channel', 'High importance Notification',
      description: 'This channel is used for important notification channel',
      importance: Importance.defaultImportance);

  final _localNotifications = FlutterLocalNotificationsPlugin();
  final iOS = IOSFlutterLocalNotificationsPlugin();

  FirebaseApi(GlobalKey<NavigatorState> navigatorKey);

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    // Create a variable to store the payload data
    final Map<String, dynamic> messageData = message.data;

    // Check if there's a specific key in the payload to determine which page to navigate to
    if (messageData.containsKey('pageToOpen')) {
      final String pageToOpen = messageData['pageToOpen'];

      if (pageToOpen == 'MyPage') {
        // Navigate to MyPage
        navigatorKey.currentState?.pushNamed('/course');
      }
    }
  }

  Future initLocalNotifications() async {
    // const iOS = IOS();
    const android = AndroidInitializationSettings('ic_bg_service_small');
    const settings = InitializationSettings(android: android);

    await _localNotifications.initialize(settings,
        onDidReceiveBackgroundNotificationResponse: (payload) {
      final message = RemoteMessage.fromMap(jsonDecode(payload as String));
    });
  }

  Future initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;

      if (notification != null) {
        // Display the notification when the app is in the foreground
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: 'ic_bg_service_small',
            ),
          ),
          payload: jsonEncode(message.toMap()),
        );
      }

      // Handle other message data if needed
      // ...
    });
  }

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token : $fCMToken');
    initPushNotification();
    // FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  // void _handleMessage(RemoteMessage message) {
  //   if (message.data['type'] == 'chat') {
  //     Navigator.push(
  //          MaterialPageRoute(builder: (context) => MyPage()) );
  //   }
  // }
}
