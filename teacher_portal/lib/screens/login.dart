import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:local_auth/local_auth.dart';

class LoginScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;
  final LocalAuthentication auth = LocalAuthentication();

  Future<void> checkStudent() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    String fullName =
        "${firstNameController.text.trim()} ${lastNameController.text.trim()}";

    String apiUrl = dotenv.env['IPv4'] ?? '';
    String apiPort = dotenv.env['API_PORT'] ?? '8000';

    if (apiUrl.isEmpty) {
      setState(() {
        errorMessage = "API URL is not configured!";
        isLoading = false;
      });
      return;
    }

    final response = await http.post(
      Uri.parse("$apiUrl:$apiPort/teachers/check_teacher/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": fullName}),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data["exists"] == true) {
        widget.onLoginSuccess(data);
      } else {
        setState(() {
          errorMessage = "Teacher not found!";
        });
      }
    } else {
      setState(() {
        errorMessage = "Teacher not found.";
      });
    }
  }

  Future<void> authenticateWithBiometrics() async {
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      bool isDeviceSupported = await auth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        setState(() {
          errorMessage = "Biometric authentication not supported";
        });
        return;
      }

      bool authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to log in',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (authenticated) {
        // Proceed with API login automatically or skip to success
        checkStudent(); // or pass cached data if already known
      }
    } catch (e) {
      setState(() {
        errorMessage = "Biometric authentication error: $e";
      });
    }
  }

  @override
  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(
                labelText: "Enter your first name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(
                labelText: "Enter your last name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : checkStudent,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Login"),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: authenticateWithBiometrics,
              icon: const Icon(Icons.fingerprint),
              label: const Text("Login with Biometrics"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            ]
          ],
        ),
      ),
    ),
  );
}

}
