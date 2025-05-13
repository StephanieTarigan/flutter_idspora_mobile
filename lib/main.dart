import 'package:flutter/material.dart';
import 'package:flutter_application_idspora/Events/add_events.dart';
import 'package:flutter_application_idspora/landingPage.dart';
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
      initialRoute: '/landing', // Rute awal aplikasi
      routes: {
        '/landing': (context) => const LandingPage(),
        '/home': (context) => const HomeScreen(),
        '/task': (context) => const TaskPage(),
        '/event': (context) => const EventsPage(),
        '/finance': (context) => const FinancePage(),
        '/add_events': (context) => const AddEvents(),
      },
      debugShowCheckedModeBanner: false, // Hilangkan banner debug
    );
  }
}