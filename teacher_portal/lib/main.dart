import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/login.dart';
import 'screens/notes/notes.dart';
import 'screens/classes/classes.dart';

void main() async {
  await dotenv.load(fileName: ".env"); // Load environment variables
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic>? teacherData; // Login response
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

    List<Widget> pages = [
      
     
      NotesWidget(), // Notes screen already handles note saving & viewing
      ClassesScreen(teacherData: teacherData!),
      ///ScheduleScreen(teacherData: teacherData!),
     //RegisterScreen(teacherData: teacherData!),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Teacher Portal', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 17, 84, 185),
          centerTitle: true,
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
           
          ],
        ),
      ),
    );
  }
}
