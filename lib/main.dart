import 'package:adv_11_am_firebase_app/views/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(
    MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: 'login_page',
      routes: {
        '/': (context) => HomePage(),
        'login_page': (context) => LoginPage(),
      },
    ),
  );
}
