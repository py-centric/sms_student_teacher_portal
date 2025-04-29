import 'package:flutter/material.dart';

class RecordDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> record;
  final int index;

  const RecordDetailsScreen({
    super.key,
    required this.record,
    required this.index,
  });

  @override
  State<RecordDetailsScreen> createState() => _RecordDetailsScreenState();
}

class _RecordDetailsScreenState extends State<RecordDetailsScreen> {
  late TextEditingController subjectController;
  late TextEditingController dateController;
  late TextEditingController newStudentController;
  List<String> studentNames = [];

  @override
  void initState() {
    super.initState();
    subjectController =
        TextEditingController(text: widget.record['subject'] ?? '');
    dateController = TextEditingController(text: widget.record['date'] ?? '');
    newStudentController = TextEditingController();
    studentNames = List<String>.from(widget.record['studentsPresent'] ?? []);
  }

  void saveChanges() {
    Navigator.pop(context, {
      'subject': subjectController.text,
      'date': dateController.text,
      'studentsPresent': studentNames,
    });
  }

  void addStudent() {
    final name = newStudentController.text.trim();
    if (name.isNotEmpty) {
      setState(() {
        studentNames.add(name);
        newStudentController.clear();
      });
    }
  }

  void removeStudent(int index) {
    setState(() {
      studentNames.removeAt(index);
    });
  }

  @override
  void dispose() {
    subjectController.dispose();
    dateController.dispose();
    newStudentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Attendance'),
        backgroundColor: const Color.fromARGB(255, 17, 84, 185),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(labelText: 'Subject'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(labelText: 'Date'),
            ),
            const SizedBox(height: 20),
            const Text(
              "Students Present",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...studentNames.asMap().entries.map((entry) {
              int idx = entry.key;
              String name = entry.value;
              return ListTile(
                title: Text(name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => removeStudent(idx),
                ),
              );
            }),
            const SizedBox(height: 10),
            TextField(
              controller: newStudentController,
              decoration: InputDecoration(
                labelText: 'Add Student Name',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: addStudent,
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 17, 84, 185),
              ),
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
