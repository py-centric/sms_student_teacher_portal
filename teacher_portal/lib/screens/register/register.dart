import 'package:flutter/material.dart';
import 'package:teacher_portal/screens/register/attendance_records.dart';
import '../notes/notes.dart';

class RegisterScreen extends StatefulWidget {
  final Map<String, dynamic> teacherData;
  final List<Map<String, dynamic>> savedAttendance; // Add this line

  const RegisterScreen({
    super.key,
    required this.teacherData,
    required this.savedAttendance, // Add this line to pass data
  });

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final List<String> students = [
    'Matome Mokoena',
    'Tshegofatso Marope',
    'Kamohelo Khumalo',
    'Kedumetse Mogotsi',
    'Ofentse Mthembu',
    'Oagile Motsepe',
    'Paballo Ndlovu',
    'Olebogeng Dlamini',
    'Boitumelo Mabuza',
    'Atlegang Kgomo',
    'Thabang Mahlangu',
    'Lesedi Ramphora',
  ];

  final List<String> subjects = [
    'Mathematics',
    'Science',
    'English',
    'Life Orientation'
  ];
  String selectedSubject = 'Mathematics';

  final List<String> grades = [
    for (int i = 8; i <= 12; i++) ...['${i}A', '${i}B']
  ];
  String selectedGrade = '8A';

  final List<bool> attendance = List<bool>.filled(12, false);
  DateTime selectedDate = DateTime.now();

  String getFormattedDate() {
    final now = DateTime.now();
    return "${now.day} ${_getMonthName(now.month)} ${now.year}";
  }

  String _getMonthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[month - 1];
  }

  int get presentCount => attendance.where((isPresent) => isPresent).length;

  void _saveAttendance() {
    final presentStudents = students
        .asMap()
        .entries
        .where((entry) => attendance[entry.key])
        .map((entry) => entry.value)
        .toList();

    final record = {
      "date": "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
      "subject": selectedSubject,
      "grade": selectedGrade,
      "present": presentStudents,
    };

    setState(() {
      widget.savedAttendance
          .add(record); // Update the savedAttendance in widget
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Attendance saved!')),
    );

    // Navigate and pass savedAttendance to the next screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttendanceRecords(
          savedAttendance: widget.savedAttendance, // Pass the updated data
          onDelete: (index) {
            setState(() {
              widget.savedAttendance.removeAt(index); // Update on delete
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 84, 185),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Register Attendance',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttendanceRecords(
                    savedAttendance:
                        widget.savedAttendance, // Pass the updated data
                    onDelete: (index) {
                      setState(() {
                        widget.savedAttendance.removeAt(index);
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  getFormattedDate(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: selectedSubject,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSubject = newValue!;
                    });
                  },
                  items: subjects.map((subject) {
                    return DropdownMenuItem<String>(
                      value: subject,
                      child:
                          Text(subject, style: const TextStyle(fontSize: 18)),
                    );
                  }).toList(),
                ),
                DropdownButton<String>(
                  value: selectedGrade,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGrade = newValue!;
                    });
                  },
                  items: grades.map((grade) {
                    return DropdownMenuItem<String>(
                      value: grade,
                      child: Text(grade, style: const TextStyle(fontSize: 18)),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Present: $presentCount/${students.length}',
              style: const TextStyle(fontSize: 16, color: Colors.green),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              students[index],
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.sticky_note_2_outlined,
                                color: Colors.blueGrey),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NotesWidget(studentName: students[index]),
                                ),
                              );
                            },
                          ),
                          Checkbox(
                            activeColor: const Color.fromARGB(255, 17, 84, 185),
                            value: attendance[index],
                            onChanged: (bool? value) {
                              setState(() {
                                attendance[index] = value ?? false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _saveAttendance,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 17, 84, 185),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  'Save Attendance',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
