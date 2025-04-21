import 'package:flutter/material.dart';

class EditClassScreen extends StatefulWidget {
  final Map<String, String> classData;

  const EditClassScreen({super.key, required this.classData});

  @override
  State<EditClassScreen> createState() => _EditClassScreenState();
}

class _EditClassScreenState extends State<EditClassScreen> {
  late TextEditingController gradeController;
  late TextEditingController roomController;
  late TextEditingController timeController;

  @override
  void initState() {
    super.initState();
    gradeController = TextEditingController(text: widget.classData['grade']);
    roomController = TextEditingController(text: widget.classData['room']);
    timeController = TextEditingController(text: widget.classData['time']);
  }

  @override
  void dispose() {
    gradeController.dispose();
    roomController.dispose();
    timeController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    Navigator.pop(context, {
      "subject": widget.classData['subject']!,
      "grade": gradeController.text,
      "room": roomController.text,
      "time": timeController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.classData['subject']}'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: gradeController,
              decoration: const InputDecoration(labelText: 'Grade'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: roomController,
              decoration: const InputDecoration(labelText: 'Room'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(labelText: 'Time'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _saveChanges,
              icon: const Icon(Icons.save),
              label: const Text("Save Changes"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
