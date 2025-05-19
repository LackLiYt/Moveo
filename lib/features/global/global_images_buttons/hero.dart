import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moveo/constants/ui_constants.dart';

class Hero_Page extends StatelessWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const Hero_Page(),
      );

  const Hero_Page({super.key});

  @override
  Widget build(BuildContext context) {
    final appBar = UiConstants.appBar(context);
    return Scaffold(
      appBar: appBar,
      body: const HeroScreen(),
    );
  }
}

class HeroScreen extends StatelessWidget {
  const HeroScreen({super.key});

  Widget _buildTile({
    required String imagePath,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade700, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'image': 'assets/global_hero/shoes.jpg',
        'label': 'Shoes',
      },
      {
        'image': 'assets/global_hero/clothes.jpg',
        'label': 'Clothes',
      },
      {
        'image': 'assets/global_hero/cap.jpg',
        'label': 'Caps',
      },
      // Add more if needed
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.9,
        children: items.map((item) {
          return _buildTile(
            imagePath: item['image']!,
            label: item['label']!,
            onTap: () => print('Tapped ${item['label']}'),
          );
        }).toList(),
      ),
    );
  }
}
