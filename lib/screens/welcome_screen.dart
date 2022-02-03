// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, todo, unused_import, prefer_const_constructors_in_immutables

import 'package:flash_chat/components/rounded_buttons.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcomeScreen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    controller.forward();
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.blue)
        .animate(controller);
    /*
    animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);

    controller.reverse(from: 1.0);
    animation.addStatusListener((status) {
      if (animation.status == AnimationStatus.completed) {
        controller.reverse(from: 1.0);
      } else if (animation.status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });   
   */

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                AnimatedTextKit(
                  repeatForever: true,
                  isRepeatingAnimation: true,
                  animatedTexts: [
                    TyperAnimatedText(
                      'Splash Chat',
                      textStyle: TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.blueGrey),
                      // speed: Duration(seconds: 1),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 48.0),
            RoundedButton(
                color: Colors.lightBlueAccent,
                name: 'Log in',
                onPress: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                }),
            RoundedButton(
              color: Colors.blueAccent,
              name: 'Register',
              onPress: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
