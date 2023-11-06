import 'package:attedance/Pages/course.dart';
import 'package:attedance/Firebase/firebase_options.dart';
import 'package:attedance/Pages/login.dart';
import 'package:attedance/Pages/mapview.dart';
import 'package:attedance/Pages/new_temp.dart';
import 'package:attedance/Pages/register.dart';
import 'package:attedance/Pages/splash_two.dart';
import 'package:attedance/Pages/teacherStudDetail.dart';
import 'package:attedance/Pages/verification.dart';
import 'package:attedance/Utils/background.dart';
import 'package:attedance/Utils/firebase_api.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:permission_handler/permission_handler.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized.

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi(navigatorKey).initNotification();
  await initializeService(username: 'FH21CO003');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Attendance',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 34, 34, 34),
          ),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const MyHomePage(),
          '/splash': (context) => const Splash(),
          '/login': (context) => const StudLogin(),
          '/register': (context) => const Register(),
          '/course': (context) => const StudCourse(
                name: '',
                username: '',
              ),
          '/mapView': (context) =>
              const MapViewWidget(name: '', username: '', code: ''),
          '/new': (context) => const NewTemp(),
          '/teachStudView': (context) => const TeachStudDetails(
                code: '',
                name: '',
                username: '',
                approved: false,
                courseName: '',
              ),
          '/mypage': (context) => const MyPage(
              attendance: false, num1: 0, num2: 0, num3: 0, res: 0, timer: 0,username:'',code:''),
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var hide = false;

  @override
  void initState() {
    super.initState();
    requestPermissions();
    requestAndCheckLocationPermission();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        hide = true;
      });
      Navigator.pushReplacement(
        context as BuildContext,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const Splash(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 0.1);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
          transitionDuration:
              const Duration(milliseconds: 2000), // Adjust as needed
        ),
      );
    });
  }

    Future<void> requestPermissions() async {
    final permissions = [
      Permission.phone,
      Permission.mediaLibrary,
      Permission.notification,
    ];

    // Request permissions
    final statuses = await permissions.request();

    // setState(() {
    //   _permissionStatuses = statuses;
    // });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(
          width: screenWidth,
          height: screenHeight * 0.3, // Adjust as needed
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            FractionalTranslation(
              translation: const Offset(0.0, 0.0), // Move the first image up
              child: !hide
                  ? Container(
                      width: screenWidth * 0.8, // Adjust as needed
                      height: screenWidth * 0.8, // Adjust as needed
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/Ellipse 2.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : SizedBox(), // Hide "Ellipse 2"
            ),
            Hero(
              tag: 'logo',
              child: Image.asset(
                "assets/images/logo 1.png",
                width: screenWidth * 0.6, // Adjust as needed
                height: screenWidth * 0.6, // Adjust as needed
              ),
            ),
          ],
        ),
      ],
    );
  }

  void requestAndCheckLocationPermission() async {
    var locationStatus = await Permission.location.status;
    var backgroundLocationStatus = await Permission.locationAlways.status;

    if (locationStatus.isGranted) {
      if (backgroundLocationStatus.isGranted) {
        // Both location and background location permissions are granted
        // You can now access the user's location continuously.
        print("Location and background location permissions are granted");
      } else {
        // Request background location permission
        var backgroundPermissionStatus =
            await Permission.locationAlways.request();
        if (backgroundPermissionStatus.isGranted) {
          // Background location permission granted, you can now use location services.
          print("Background location permission granted");
        } else if (backgroundPermissionStatus.isDenied) {
          // Background location permission denied.
          print("Background location permission denied");
        } else if (backgroundPermissionStatus.isPermanentlyDenied) {
          // Background location permission permanently denied, open settings to enable it.
          openAppSettings();
        }
      }
    } else if (locationStatus.isDenied) {
      // Location permission denied, open app settings
      openAppSettings();
    } else if (locationStatus.isPermanentlyDenied) {
      // Location permission permanently denied, open app settings
      openAppSettings();
    } else {
      // Request location permission
      var locationPermissionStatus = await Permission.location.request();
      if (locationPermissionStatus.isGranted) {
        _requestBackgroundLocationPermission();
      } else if (locationPermissionStatus.isDenied) {
        openAppSettings();
      }
    }
  }

  Future<void> _requestBackgroundLocationPermission() async {
    final status = await Permission.locationAlways.request();
    if (status.isGranted) {}
    else if (status.isDenied) {}
    else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
