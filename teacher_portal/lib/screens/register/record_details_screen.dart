import 'package:flutter/material.dart';

class RecordDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>
      record; // Contains subject, date, present list, etc.
  final int index; // Index of the record being edited
  final List<String>
      allStudents; // Full list of students passed from RegisterScreen

  const RecordDetailsScreen({
    super.key,
    required this.record,
    required this.index,
    required this.allStudents, // Required for dynamic class list
  });

  @override
  State<RecordDetailsScreen> createState() => _RecordDetailsScreenState();
}

class _RecordDetailsScreenState extends State<RecordDetailsScreen> {
  late TextEditingController subjectController;
  late TextEditingController dateController;

  late List<String> allStudents; // Dynamic student list
  late Map<String, bool>
      studentSelection; // Map of student name to attendance status

  @override
  void initState() {
    super.initState();

    // Initialize text fields with existing values
    subjectController = TextEditingController(text: widget.record['subject']);
    dateController = TextEditingController(text: widget.record['date']);

    // Use the student list passed from RegisterScreen
    allStudents = widget.allStudents;

    // Get the present students from the record
    List<String> initiallyPresent =
        List<String>.from(widget.record['present'] ?? []);

    // Create a map to track which students are marked present
    studentSelection = {
      for (var student in allStudents)
        student: initiallyPresent.contains(student),
    };
  }

  // Save the edited record and return to previous screen
  void saveChanges() {
    // Build updated present student list based on selected checkboxes
    List<String> updatedPresent = studentSelection.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    // Pop this screen and return updated record
    Navigator.pop(context, {
      'subject': subjectController.text,
      'date': dateController.text,
      'present': updatedPresent,
      'grade': widget.record['grade'], // Keep grade unchanged
    });
  }

  @override
  void dispose() {
    subjectController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter the selected students from the map
    List<String> presentStudents = studentSelection.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Attendance'),
        backgroundColor: const Color.fromARGB(255, 17, 84, 185),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject input field
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(labelText: 'Subject'),
            ),
            // Date input field
            TextField(
              controller: dateController,
              decoration: const InputDecoration(labelText: 'Date'),
            ),

            const SizedBox(height: 20),

            // List of present students (currently marked)
            const Text(
              "Students Present",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...presentStudents.map((name) {
              return ListTile(
                title: Text(name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      studentSelection[name] = false; // Mark student absent
                    });
                  },
                ),
              );
            }).toList(),

            const Divider(height: 40),

            // Checkbox list to mark/unmark attendance
            const Text(
              "Mark Attendance",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...allStudents.map((student) {
              return CheckboxListTile(
                title: Text(student),
                value: studentSelection[student] ?? false,
                onChanged: (bool? value) {
                  setState(() {
                    studentSelection[student] = value ?? false;
                  });
                },
              );
            }).toList(),

            const SizedBox(height: 30),

            // Button to save changes
            Center(
              child: ElevatedButton(
                onPressed: saveChanges,
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
