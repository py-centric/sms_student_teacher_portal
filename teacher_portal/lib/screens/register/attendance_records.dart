import 'package:flutter/material.dart';
import 'record_details_screen.dart';

class AttendanceRecords extends StatefulWidget {
  final List<Map<String, dynamic>> savedAttendance;
  final Function(int index)? onDelete;

  const AttendanceRecords({
    super.key,
    required this.savedAttendance,
    this.onDelete,
  });

  @override
  State<AttendanceRecords> createState() => _AttendanceRecordsState();
}

class _AttendanceRecordsState extends State<AttendanceRecords> {
  late List<Map<String, dynamic>> attendanceList;

  @override
  void initState() {
    super.initState();
    attendanceList = List<Map<String, dynamic>>.from(widget.savedAttendance);
  }

  void _deleteRecord(int index) async {
    // Show confirmation dialog before deleting
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure?"),
        content: const Text("Do you want to delete this attendance record?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // User declined
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // User confirmed
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    // If confirmed, delete the record
    if (confirmed == true) {
      setState(() {
        attendanceList.removeAt(index);
      });
      if (widget.onDelete != null) {
        widget.onDelete!(index);
      }
    }
  }

  void _updateRecord(int index, Map<String, dynamic> updatedRecord) {
    setState(() {
      attendanceList[index] = updatedRecord;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 17, 84, 185),
        title: const Text("Attendance Records"),
      ),
      body: attendanceList.isEmpty
          ? const Center(child: Text("No attendance records found."))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: attendanceList.length,
                itemBuilder: (context, index) {
                  final record = attendanceList[index];
                  final presentList =
                      List<String>.from(record['present'] ?? []);

                  return GestureDetector(
                    onTap: () async {
                      final updatedRecord = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RecordDetailsScreen(
                            record: record,
                            index: index,
                          ),
                        ),
                      );

                      if (updatedRecord != null) {
                        _updateRecord(index, updatedRecord);
                      }
                    },
                    child: Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Subject: ${record['subject']}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Date: ${record['date']}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Present: ${presentList.length}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _deleteRecord(index),
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
