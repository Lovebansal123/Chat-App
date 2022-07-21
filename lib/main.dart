import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:letschat/screens/welcome_screen.dart';
import 'package:letschat/screens/login_screen.dart';
import 'package:letschat/screens/register_screen.dart';
import 'package:letschat/screens/chat_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context)=>WelcomeScreen(),
        LoginScreen.id: (context)=>LoginScreen(),
        RegistrationScreen.id: (context)=>RegistrationScreen(),
        ChatScreen.id: (context)=>ChatScreen(),


      },
    );
  }
}

