import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(55),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 73,
              top: 100,
              child: Text(
                'moveo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF0437F2),
                  fontSize: 72,
                  fontFamily: 'Arial Rounded MT Bold',
                  fontWeight: FontWeight.w400,
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
                    decoration: InputDecoration(
                      hintText: 'phone number, mail',
                      hintStyle: TextStyle(color: Color(0xFF969090)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xFFE0E0E5)),
                      ),
                      filled: true,
                      fillColor: Color(0xFFEFF2F5),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'password',
                      hintStyle: TextStyle(color: Color(0xFF969090)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xFFE0E0E5)),
                      ),
                      filled: true,
                      fillColor: Color(0xFFEFF2F5),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Додайте функціонал для реєстрації
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(
                          0xFF0437F2), // Заміна primary на backgroundColor
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(double.infinity, 40),
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(
                          color: Color(0xFF969090),
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
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
