import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RegisterScreen extends StatefulWidget {
  final Map<String, dynamic> teacherData;

  const RegisterScreen({super.key, required this.teacherData});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int? selectedGrade;
  List<dynamic> learners = [];
  bool isLoading = false;

  Set<int> extractUniqueGrades() {
    List subjects = widget.teacherData['subjects'];
    return subjects.map<int>((subject) => subject['grade'] as int).toSet();
  }

  Future<void> fetchLearnersForGrade(int grade) async {
    setState(() {
      isLoading = true;
      learners = [];
    });

    String apiUrl = dotenv.env['IPv4'] ?? '';
    String apiPort = dotenv.env['API_PORT'] ?? '8000';

    final response = await http.get(
      Uri.parse("$apiUrl:$apiPort/learners/by_grade/$grade"),
      headers: {"Content-Type": "application/json"},
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      setState(() {
        learners = jsonDecode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch learners.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final uniqueGrades = extractUniqueGrades();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Learners'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<int>(
              value: selectedGrade,
              hint: const Text("Select Grade"),
              items: uniqueGrades.map((grade) {
                return DropdownMenuItem(
                  value: grade,
                  child: Text('Grade $grade'),
                );
              }).toList(),
              onChanged: (grade) {
                setState(() {
                  selectedGrade = grade;
                });
                fetchLearnersForGrade(grade!);
              },
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const CircularProgressIndicator()
            else if (learners.isEmpty && selectedGrade != null)
              const Text("No learners found for this grade.")
            else
              Expanded(
                child: ListView.builder(
                  itemCount: learners.length,
                  itemBuilder: (context, index) {
                    var learner = learners[index];
                    return ListTile(
                      title: Text(learner['name']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () {
                              // Mark as present (future implementation)
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              // Mark as absent (future implementation)
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
