import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diario Interactivo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          titleTextStyle: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold, 
            color: Colors.white
          ),
          centerTitle: true,
          elevation: 5,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          foregroundColor: Colors.white,
          elevation: 4,
        ),
      ),
      home: Padding(
        padding: const EdgeInsets.all(30.0),
        child: LoginScreen(),
      ),
    );
  }
}
