import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'TaskPage.dart';
import 'EventsPage.dart';
import 'FinancePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white, // Warna latar belakang default
      ),
      initialRoute: '/home', // Rute awal aplikasi
      routes: {
        '/home': (context) => const HomeScreen(),
        '/task': (context) => const TaskPage(),
        '/event': (context) => const EventsPage(),
        '/finance': (context) => const FinancePage(),
      },
      debugShowCheckedModeBanner: false, // Hilangkan banner debug
    );
  }
}