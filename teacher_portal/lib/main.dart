import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/login.dart';
import 'screens/notes/notes.dart';
import 'screens/classes/classes.dart';
import 'screens/schedule/schedule.dart';
import 'screens/register/register.dart'; // <-- Register screen
import 'screens/mcq/mcq_screen.dart'; // <-- MCQ screen

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic>? teacherData;
  int _selectedIndex = 0;

  void handleLoginSuccess(Map<String, dynamic> data) {
    setState(() {
      teacherData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (teacherData == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(onLoginSuccess: handleLoginSuccess),
      );
    }

    String teacherName =
        "${teacherData?['first_name'] ?? ''} ${teacherData?['last_name'] ?? ''}";

    final List<Widget> pages = [
      NotesWidget(
        studentName: '',
      ),
      ClassesScreen(teacherData: teacherData!),
      ScheduleScreen(teacherData: teacherData!),
      RegisterScreen(
        teacherData: teacherData!,
        savedAttendance: [],
      ), // ✅ Register added back
      MCQScreen(), // ✅ MCQ screen
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 17, 84, 185),
          centerTitle: true,
          title: Text(
            'Welcome, $teacherName',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue[900],
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.note),
              label: 'Notes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.class_),
              label: 'Classes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule),
              label: 'Schedule',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.checklist),
              label: 'Register',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.quiz),
              label: 'MCQs',
            ),
          ],
        ),
      ),
    );
  }
}
