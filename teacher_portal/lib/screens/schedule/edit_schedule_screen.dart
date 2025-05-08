import 'package:flutter/material.dart';

class EditScheduleScreen extends StatefulWidget {
  final Map<String, String> classData;

  const EditScheduleScreen({super.key, required this.classData});

  @override
  State<EditScheduleScreen> createState() => _EditScheduleScreenState();
}

class _EditScheduleScreenState extends State<EditScheduleScreen> {
  late TextEditingController timeController;
  late TextEditingController noteController;

  @override
  void initState() {
    super.initState();
    timeController = TextEditingController(text: widget.classData['time']);
    noteController = TextEditingController(text: widget.classData['note']);
  }

  @override
  void dispose() {
    timeController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    Navigator.pop(context, {
      'subject': widget.classData['subject']!,
      'grade': widget.classData['grade']!,
      'room': widget.classData['room']!,
      'time': timeController.text,
      'note': noteController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Schedule')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: timeController,
              decoration: const InputDecoration(labelText: 'Time'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: 'Note'),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
