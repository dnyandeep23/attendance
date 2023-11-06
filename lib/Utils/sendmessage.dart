import 'dart:convert';

import 'package:http/http.dart' as http;

Future<void> sendNotification() async {
  String serverKey =
      'AAAAP0kuvlE:APA91bFuHVJ-z-ZE5OZKN6KrwvT-FSKzG6KEbbm4asjvmaaWDP1lK1acXKlHANN1-W3EStOHgBPhya4FjGqoq4QpN47IW4ApG8fxFqD6DPApqLcl4oDU38JhvWGWSI18ik2dAL9mHbi0';
  Uri fcmEndpoint = Uri.parse('https://fcm.googleapis.com/fcm/send');

  Map<String, dynamic> notification = {
    'title': 'Button Clicked',
    'body': 'Your message here',
    'image': 'https://www.shutterstock.com/image-photo/attendance-mark-business-school-concept-260nw-2077400443.jpg',
  };

  Map<String, dynamic> data = {
    "pageToOpen": "MyPage"
  };

  Map<String, dynamic> request = {
    'notification': notification,
    'data': data,
    'to':
        "ejW6Y1ECT0qcq5wmOKVCpz:APA91bEIszdL-ho1PybyAYTZvYwCvLKRi_sO-kD7XsIVBeIbo14IemB0ARzhP4nS9sHdLY87e8B6CmeMhh4ZET39f4SE8EEjuQYqNCThU8hYdp7DUueEPn7AuicQmxdbp8KPGY2dv1-y",
  };

  try {
    final response = await http.post(
      fcmEndpoint,
      body: jsonEncode(request),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
    );

    if (response.statusCode == 200) {
      // Notification sent successfully
    } else {
      // Handle error
    }
  } catch (e) {
    // Handle exceptions
  }
}
