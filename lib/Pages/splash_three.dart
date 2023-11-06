import 'package:attedance/Pages/login.dart';

import 'package:attedance/Pages/register.dart';
import 'package:flutter/material.dart';

class SplashNew extends StatefulWidget {
  final AnimationController controller;
  final void Function(bool newValue) updateVisibility;

  const SplashNew(
      {Key? key, required this.controller, required this.updateVisibility})
      : super(key: key);

  @override
  State<SplashNew> createState() => _SplashNewState();
}

class _SplashNewState extends State<SplashNew>
    with SingleTickerProviderStateMixin {
  int a = 0xff797373;
  int b = 0xff797373;
  var click = false;
  late AnimationController _controller;

  bool hide = false; // Initialize hide as false

  void updateVisibility(bool newValue) {
    setState(() {
      hide = newValue;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );
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

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Animation has completed, update the state here
        setState(() {
          click = true;
        });
      }
    });

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
                alignment: const FractionalOffset(-0.4, -0.0),
              ),
              color: Colors.black,
            ),
            child: Column(
              children: [
                !hide
                    ? Stack(children: [
                        FractionalTranslation(
                          translation: const Offset(3.5, 0.4),
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
                  height: click ? 5 : 10,
                ),
                !hide
                    ? !click
                        ? Column(
                            children: [
                              // SizedBox(
                              //   height: screenHeight * 0.03,
                              // ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    a = 0xFF413E3E;
                                  });

                                  Future.delayed(
                                      const Duration(milliseconds: 100), () {
                                    setState(() {
                                      a = 0xff797373;
                                    });
                                  });
                                  // Handle onTap here
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   const SnackBar(
                                  //     content: Text('Button Tapped!'),
                                  //   ),
                                  // );
                                  Future.delayed(
                                      const Duration(milliseconds: 500), () {
                                    widget.updateVisibility(true);
                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            const StudLogin(),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          const begin = Offset(0.0, 0.1);
                                          const end = Offset.zero;
                                          const curve = Curves.easeInOut;
                                          var tween = Tween(
                                                  begin: begin, end: end)
                                              .chain(CurveTween(curve: curve));
                                          var offsetAnimation =
                                              animation.drive(tween);
                                          return SlideTransition(
                                              position: offsetAnimation,
                                              child: child);
                                        },
                                        transitionDuration: const Duration(
                                            milliseconds:
                                                800), // Adjust as needed
                                      ),
                                    );
                                  });
                                },
                                child: Container(
                                  width: screenHeight * 0.15,
                                  height: screenHeight * 0.15,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Color(a),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                  ),
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: screenWidth * 0.12,
                                  ),
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: const Color(0xff797373),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            blurRadius: 5.0,
                                          ),
                                        ]),
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.3,
                                  ),
                                  FadeTransition(
                                    opacity: Tween<double>(
                                      begin: 0.8,
                                      end: 1.0,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: widget.controller,
                                        curve: Curves.bounceInOut,
                                      ),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          b = 0xFF413E3E;
                                        });

                                        Future.delayed(
                                            const Duration(milliseconds: 100),
                                            () {
                                          setState(() {
                                            b = 0xff797373;
                                          });
                                        });
                                        // Handle onTap here

                                        Future.delayed(
                                            const Duration(milliseconds: 500),
                                            () {
                                          widget.updateVisibility(true);
                                          Navigator.pushReplacement(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                      secondaryAnimation) =>
                                                  const Register(),
                                              transitionsBuilder: (context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child) {
                                                const begin = Offset(0.0, 0.1);
                                                const end = Offset.zero;
                                                const curve = Curves.easeInOut;
                                                var tween = Tween(
                                                        begin: begin, end: end)
                                                    .chain(CurveTween(
                                                        curve: curve));
                                                var offsetAnimation =
                                                    animation.drive(tween);
                                                return SlideTransition(
                                                    position: offsetAnimation,
                                                    child: child);
                                              },
                                              transitionDuration: const Duration(
                                                  milliseconds:
                                                      800), // Adjust as needed
                                            ),
                                          );
                                        });
                                        // ScaffoldMessenger.of(context).showSnackBar(
                                        //   const SnackBar(
                                        //     content: Text('Button Tapped!'),
                                        //   ),
                                        // );
                                      },
                                      child: Container(
                                        width: screenHeight * 0.16,
                                        height: screenHeight * 0.16,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: Color(b),
                                          boxShadow: const [
                                            BoxShadow(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              blurRadius: 5.0,
                                            ),
                                          ],
                                        ),
                                        child: const Text(
                                          "Register",
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
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
