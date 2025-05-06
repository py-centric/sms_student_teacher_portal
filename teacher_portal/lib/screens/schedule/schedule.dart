import 'package:flutter/material.dart';
import 'edit_schedule_screen.dart';

class ScheduleScreen extends StatefulWidget {
  final Map<String, dynamic> teacherData;

  const ScheduleScreen({super.key, required this.teacherData});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<Map<String, String>> classes = [
    {
      "subject": "Mathematics",
      "grade": "Grade 10",
      "room": "Room 101",
      "time": "08:00 - 09:00",
      "date": "",
      "note": ""
    },
    {
      "subject": "Physical Science",
      "grade": "Grade 11",
      "room": "Lab 1",
      "time": "09:15 - 10:15",
      "date": "",
      "note": ""
    },
    {
      "subject": "Life Orientation",
      "grade": "Grade 12",
      "room": "Room 203",
      "time": "11:00 - 12:00",
      "date": "",
      "note": ""
    },
  ];
  void _editSchedule(int index) async {
    final updatedClass = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (_) => EditScheduleScreen(classData: classes[index]),
      ),
    );

    if (updatedClass != null) {
      setState(() {
        classes[index] = updatedClass;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: classes.length,
          itemBuilder: (context, index) {
            final cls = classes[index];
            return GestureDetector(
              onTap: () => _editSchedule(index),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.schedule, color: Colors.white),
                  ),
                  title: Text(cls['subject']!,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cls['grade']!),
                      if (cls['date']!.isNotEmpty) Text("Date: ${cls['date']}"),
                      Text("Time: ${cls['time']}"),
                      Text("Location: ${cls['room']}"),
                      if (cls['note']!.isNotEmpty)
                        Text("Note: ${cls['note']!}",
                            style: TextStyle(color: Colors.deepPurple)),
                    ],
                  ),
                  trailing: const Icon(Icons.edit_calendar, size: 20),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
