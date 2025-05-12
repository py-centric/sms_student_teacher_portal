import 'package:flutter/material.dart';

class EditScheduleScreen extends StatefulWidget {
  final Map<String, String> classData;

  const EditScheduleScreen({super.key, required this.classData});

  @override
  State<EditScheduleScreen> createState() => _EditScheduleScreenState();
}

class _EditScheduleScreenState extends State<EditScheduleScreen> {
  late TextEditingController noteController;
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  @override
  void initState() {
    super.initState();
    noteController = TextEditingController(text: widget.classData['note']);
    selectedDate = DateTime.now();
    startTime = const TimeOfDay(hour: 8, minute: 0);
    endTime = const TimeOfDay(hour: 9, minute: 0);
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _pickStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: startTime ?? const TimeOfDay(hour: 8, minute: 0),
    );
    if (picked != null) {
      setState(() {
        startTime = picked;
      });
    }
  }

  Future<void> _pickEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: endTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      setState(() {
        endTime = picked;
      });
    }
  }

  void _saveChanges() {
    final formattedDate = selectedDate != null
        ? '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}'
        : 'No date';

    final formattedTime =
        '${startTime?.format(context)} - ${endTime?.format(context)}';

    Navigator.pop(context, {
      'subject': widget.classData['subject']!,
      'grade': widget.classData['grade']!,
      'room': widget.classData['room']!,
      'time': formattedTime,
      'date': formattedDate,
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
            ListTile(
              title: Text(selectedDate == null
                  ? 'Select Date'
                  : 'Date: ${selectedDate!.toLocal().toString().split(' ')[0]}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            ListTile(
              title: Text(startTime == null
                  ? 'Select Start Time'
                  : 'Start Time: ${startTime!.format(context)}'),
              trailing: const Icon(Icons.access_time),
              onTap: _pickStartTime,
            ),
            ListTile(
              title: Text(endTime == null
                  ? 'Select End Time'
                  : 'End Time: ${endTime!.format(context)}'),
              trailing: const Icon(Icons.access_time),
              onTap: _pickEndTime,
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
