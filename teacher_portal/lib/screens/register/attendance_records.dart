import 'package:flutter/material.dart';
import 'record_details_screen.dart';

class AttendanceRecords extends StatefulWidget {
  final List<Map<String, dynamic>> savedAttendance;
  final Function(List<Map<String, dynamic>> updatedList)? onListUpdated;

  const AttendanceRecords({
    super.key,
    required this.savedAttendance,
    this.onListUpdated,
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
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure?"),
        content: const Text("Do you want to delete this attendance record?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        attendanceList.removeAt(index);
      });

      widget.onListUpdated?.call(attendanceList);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Record deleted successfully')),
      );
    }
  }

  void _updateRecord(int index, Map<String, dynamic> updatedRecord) {
    setState(() {
      attendanceList[index] = updatedRecord;
    });

    widget.onListUpdated?.call(attendanceList);
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
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: attendanceList.length,
              itemBuilder: (context, index) {
                final record = attendanceList[index];
                final presentList =
                    List<String>.from(record['studentsPresent'] ?? []);

                return GestureDetector(
                  onTap: () async {
                    final updatedRecord =
                        await Navigator.push<Map<String, dynamic>>(
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
                                "Subject: ${record['subject'] ?? 'N/A'}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Date: ${record['date'] ?? 'N/A'}",
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
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
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
    );
  }
}
