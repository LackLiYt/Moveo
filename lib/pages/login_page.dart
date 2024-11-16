import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appwrite/appwrite.dart';
import 'package:moveo/appwrite/auth_api.dart';
import 'package:moveo/pages/forgotpassword_page.dart';
import 'package:moveo/pages/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  signIn() async {
    try {
      final AuthAPI appwrite = context.read<AuthAPI>();
      await appwrite.createEmailSession(
        email: emailTextController.text,
        password: passwordTextController.text,
      );
    } on AppwriteException catch (e) {
      _showAlert(title: 'Login failed', text: e.message.toString());
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
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center elements vertically
          children: [
            const SizedBox(height: 200),
            const Text(
              'moveo',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF0437F2),
                fontSize: 72,
                fontFamily: 'Montserrat-Bold',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20), // Space between 'moveo' and text fields
            Column(
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
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotPasswordPage(),
                      ),
                    ),
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: Color(0xFF0437F2),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                    height: 20), // Space between button and text fields
                ElevatedButton(
                  onPressed: signIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0437F2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(double.infinity, 40),
                  ),
                  child: const Text(
                    'Log in',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const Spacer(), // Pushes "Don't have an account?" to the bottom
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Don’t have an account?',
                  style: TextStyle(
                    color: Color(0xFF969090),
                    fontSize: 14,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  ),
                  child: const Text(
                    'Sign up',
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
    );
  }
}
