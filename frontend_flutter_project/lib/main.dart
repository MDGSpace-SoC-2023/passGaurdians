import 'package:flutter/material.dart';
//import 'package:loginuicolors/password_details.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/homepage.dart';

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
