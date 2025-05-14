import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ViewMCQs extends StatefulWidget {
  const ViewMCQs({super.key});

  @override
  State<ViewMCQs> createState() => _ViewMCQsState();
}

class _ViewMCQsState extends State<ViewMCQs> {
  List<dynamic> mcqs = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchMCQs();
  }

  Future<void> fetchMCQs() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final apiUrl = dotenv.env['IPv4'] ?? '';
      final apiPort = dotenv.env['API_PORT'] ?? '8000';
      final url = Uri.parse('$apiUrl:$apiPort/mcq/questions');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          mcqs = json.decode(response.body);
        });
      } else {
        setState(() {
          error = 'Failed to load MCQs: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error fetching data: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (error != null) return Center(child: Text(error!));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mcqs.length,
      itemBuilder: (context, index) {
        final q = mcqs[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Q: ${q['question_text']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...List.generate(4, (i) {
                  final isCorrect = i == q['correct_answer_index'];
                  return Row(
                    children: [
                      Icon(isCorrect ? Icons.check_circle : Icons.circle, color: isCorrect ? Colors.green : Colors.grey, size: 16),
                      const SizedBox(width: 8),
                      Expanded(child: Text(q['options'][i])),
                    ],
                  );
                }),
                if (q['subject'] != null && q['subject'].toString().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text("Subject: ${q['subject']}", style: const TextStyle(color: Colors.blueGrey)),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
