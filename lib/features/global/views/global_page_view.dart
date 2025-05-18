import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Global page',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Global'),
        ),
        body: Center(
          child: FourImageButtonsGrid(),
        ),
      ),
    );
  }
}
class FourImageButtonsGrid extends StatelessWidget {
  Widget _buildImageButton({
    required String imagePath,
    required VoidCallback onPressed,
    double width = 120,
    double height = 120,
    double padding = 8.0,
  }) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: InkWell(
        onTap: onPressed,
        splashColor: Colors.blue.withAlpha(100),
        borderRadius: BorderRadius.circular(12), // Опціонально, для круглих бризок
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.asset(
              imagePath,
              width: width,
              height: height,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // Центрування стовпця по вертикалі
      crossAxisAlignment: CrossAxisAlignment.center, // Центрування рядків по горизонталі
      mainAxisSize: MainAxisSize.min, // Щоб Column займав мінімально необхідну висоту
      children: <Widget>[
        // Перший ряд з двома кнопками
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Центрування кнопок у рядку
          mainAxisSize: MainAxisSize.min, // Щоб Row займав мінімально необхідну ширину
          children: <Widget>[
            _buildImageButton(
              imagePath: 'assets/global_photos/events.png', // Замініть на ваш шлях
              onPressed: () {
                print('Clicked events');
                // Ваша дія для кнопки 1
              },
            ),
            _buildImageButton(
              imagePath: 'assets/global_photos/events.png', // Замініть на ваш шлях
              onPressed: () {
                print('Натиснуто кнопку 2');
                // Ваша дія для кнопки 2
              },
            ),
          ],
        ),
        // Другий ряд з двома кнопками
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Центрування кнопок у рядку
          mainAxisSize: MainAxisSize.min, // Щоб Row займав мінімально необхідну ширину
          children: <Widget>[
            _buildImageButton(
              imagePath: 'assets/global_photos/events.png', // Замініть на ваш шлях
              onPressed: () {
                print('Натиснуто кнопку 3');
                // Ваша дія для кнопки 3
              },
            ),
            _buildImageButton(
              imagePath: 'assets/global_photos/events.png', // Замініть на ваш шлях
              onPressed: () {
                print('Натиснуто кнопку 4');
                // Ваша дія для кнопки 4
              },
            ),
          ],
        ),
      ],
    );
  }
}