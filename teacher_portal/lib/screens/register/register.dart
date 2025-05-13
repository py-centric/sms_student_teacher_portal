import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  final Map<String, dynamic> teacherData;

  const RegisterScreen({super.key, required this.teacherData});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Register Screen (Coming Soon)',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
