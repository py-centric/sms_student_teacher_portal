import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CreateMCQForm extends StatefulWidget {
  const CreateMCQForm({super.key});

  @override
  State<CreateMCQForm> createState() => _CreateMCQFormState();
}

class _CreateMCQFormState extends State<CreateMCQForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = List.generate(4, (_) => TextEditingController());
  int? _correctOptionIndex;
  final TextEditingController _subjectController = TextEditingController();

  bool _isSubmitting = false;
  String? _errorMessage;
  String? _successMessage;

  Future<void> _submitQuestion() async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
      _successMessage = null;
    });

    String apiUrl = dotenv.env['IPv4'] ?? '';
    String apiPort = dotenv.env['API_PORT'] ?? '8000';
    final url = Uri.parse('$apiUrl:$apiPort/mcq/questions/');

    final body = {
      "question_text": _questionController.text,
      "options": _optionControllers.map((controller) => controller.text).toList(),
      "correct_answer_index": _correctOptionIndex,
      "subject": _subjectController.text.isEmpty ? null : _subjectController.text,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        setState(() {
          _successMessage = "Question saved successfully!";
          _formKey.currentState?.reset();
          _correctOptionIndex = null;
          for (final c in _optionControllers) {
            c.clear();
          }
          _questionController.clear();
          _subjectController.clear();
        });
      } else {
        final responseJson = json.decode(response.body);
        setState(() {
          _errorMessage = responseJson['detail'] ?? 'Failed to save question';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Create Question", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextFormField(
              controller: _questionController,
              decoration: const InputDecoration(
                labelText: 'Question',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) => value == null || value.trim().isEmpty ? 'Question is required' : null,
            ),
            const SizedBox(height: 16),
            const Text("Options"),
            ...List.generate(4, (index) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextFormField(
                  controller: _optionControllers[index],
                  decoration: InputDecoration(
                    labelText: 'Option ${index + 1}',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Option is required' : null,
                ),
              );
            }),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _correctOptionIndex,
              decoration: const InputDecoration(
                labelText: 'Correct Option',
                border: OutlineInputBorder(),
              ),
              items: List.generate(4, (index) {
                return DropdownMenuItem(
                  value: index,
                  child: Text('Option ${index + 1}'),
                );
              }),
              onChanged: (value) {
                setState(() {
                  _correctOptionIndex = value;
                });
              },
              validator: (value) => value == null ? 'Please select the correct option' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject (Optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          _submitQuestion();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Save Question",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            if (_successMessage != null)
              Text(_successMessage!, style: const TextStyle(color: Colors.green)),
            if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
