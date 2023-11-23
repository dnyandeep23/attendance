import 'package:attedance/Pages/loginsplash.dart';
import 'package:attedance/Pages/verification.dart';
import 'package:attedance/Utils/sendmessage.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:attedance/Pages/splash_three.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  var click = false;
  late AnimationController _controller;
  bool hide = false;

  void updateVisibility(bool newValue) {
    setState(() {
      hide = newValue;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onButtonPressed() {
    setState(() {
      click = !click;
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          click = true;
        });
      }
    });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Loginsplash(
                controller: _controller, updateVisibility: updateVisibility)));
    // Navigator.push(context, MaterialPageRoute(builder: (context) => MyPage()));
    // sendNotification();

    if (click) {
      _controller.forward(); // Start the animation
    } else {
      _controller.reverse(); // Reverse the animation
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: !hide
                    ? const AssetImage('assets/images/Ellipse.png')
                    : const AssetImage('assets/images/trans.png'),
                alignment: FractionalOffset(-0.4, -0.0),
              ),
              color: Colors.black,
            ),
            child: Column(
              children: [
                !hide
                    ? Stack(children: [
                        FractionalTranslation(
                          translation: const Offset(3.5, 0.5),
                          child: Container(
                            width: screenWidth * 0.1, // Adjust as needed
                            height: screenWidth * 0.1, // Adjust as needed
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image:
                                    AssetImage('assets/images/Ellipse 4.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ])
                    : const SizedBox(),
                const SizedBox(
                  height: 10,
                ),
                !hide
                    ? Stack(children: [
                        FractionalTranslation(
                          translation: const Offset(1.5, 0.3),
                          child: Container(
                            width: screenWidth * 0.15, // Adjust as needed
                            height: screenWidth * 0.15, // Adjust as needed
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image:
                                    AssetImage('assets/images/Ellipse 3.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ])
                    : SizedBox(),
                SizedBox(
                  height: click ? screenHeight * 0.0002 : screenHeight * 0.02,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    !hide
                        ? FractionalTranslation(
                            translation: const Offset(0.0, -0.2),
                            child: Container(
                              width: screenWidth * 0.6, // Adjust as needed
                              height: screenWidth * 0.6, // Adjust as needed
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/Ellipse 2.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                    Hero(
                      tag: 'logo',
                      child: Image.asset(
                        "assets/images/logo 1.png",
                        width: screenWidth * 0.9, // Adjust as needed
                        height: screenWidth * 0.9, // Adjust as needed
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.5,
                    )
                  ],
                ),
                SizedBox(
                  height: click ? 5 : 40,
                ),
                !hide
                    ? !click
                        ? Row(
                            children: [
                              SizedBox(
                                width: screenWidth * 0.25, // Adjust as needed
                                height: screenHeight * 0.25, // Adjust as needed
                                // Adjust as needed
                              ),
                              Center(
                                child: ElevatedButton(
                                  onPressed: _onButtonPressed,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff797373),
                                    shadowColor: const Color.fromARGB(
                                        236, 109, 107, 107),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  child: AnimatedContainer(
                                    width: click
                                        ? screenWidth * 0.04
                                        : screenWidth * 0.4,
                                    height:
                                        screenHeight * 0.1, // Adjust as needed
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                    alignment: Alignment.center,
                                    child: Text(
                                      !click ? 'Click Here' : '',
                                      style: const TextStyle(
                                        fontFamily: 'postnobillextrabold',
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox()
                    : SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
