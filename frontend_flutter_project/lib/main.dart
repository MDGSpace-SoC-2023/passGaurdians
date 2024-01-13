import 'package:flutter/material.dart';
<<<<<<< HEAD
//import 'package:loginuicolors/password_details.dart';
import 'login.dart';
import 'register.dart';
import 'homepage.dart';
=======
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/homepage.dart';
>>>>>>> fc626d25db8a15c9f7c6b9bc110fd411d1c75f1c

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyHomePage(),
    routes: {
      'register': (context) => MyRegister(),
      'login': (context) => MyLogin(),
      'home': (context) => MyHomePage(),

    },
  ));
}
