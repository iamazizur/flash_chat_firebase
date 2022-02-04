import 'package:flash_chat/flash_chat_app/screens/chat_screen.dart';
import 'package:flash_chat/flash_chat_app/screens/login_screen.dart';
import 'package:flash_chat/flash_chat_app/screens/registration_screen.dart';
import 'package:flash_chat/flash_chat_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//firebase imports
import 'package:flutter/material.dart';
import 'firebase_options.dart';

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
