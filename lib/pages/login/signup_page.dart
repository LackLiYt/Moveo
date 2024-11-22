import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appwrite/appwrite.dart';
import 'package:moveo/appwrite/auth_api.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  createAccount() async {
    try {
      final AuthAPI appwrite = context.read<AuthAPI>();
      await appwrite.createUser(
        email: emailTextController.text,
        password: passwordTextController.text,
      );
      const snackbar = SnackBar(content: Text('Account created!'));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } on AppwriteException catch (e) {
      _showAlert(title: 'Account creation failed', text: e.message.toString());
    }
  }

  void _showAlert({required String title, required String text}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(55),
        ),
        child: Stack(
          children: [
            const Positioned(
              left: 73,
              top: 100,
              child: Text(
                'moveo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF0437F2),
                  fontSize: 72,
                  fontFamily: 'Montserrat-Bold',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Positioned(
              left: 30,
              top: 250,
              right: 30,
              child: Column(
                children: [
                  TextField(
                    controller: emailTextController,
                    decoration: InputDecoration(
                      hintText: 'phone number, mail',
                      hintStyle: const TextStyle(color: Color(0xFF969090)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E5)),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFEFF2F5),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordTextController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'password',
                      hintStyle: const TextStyle(color: Color(0xFF969090)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E5)),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFEFF2F5),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: createAccount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0437F2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(double.infinity, 40),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 405),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(
                          color: Color(0xFF969090),
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Color(0xFF0437F2),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
