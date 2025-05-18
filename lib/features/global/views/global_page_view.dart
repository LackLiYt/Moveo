import 'package:flutter/material.dart';

class GlobalPageView extends StatelessWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const GlobalPageView(),
      );

  const GlobalPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Global'),
      ),
      body: const FourImageButtonsGrid(),
    );
  }
}

class FourImageButtonsGrid extends StatelessWidget {
  const FourImageButtonsGrid({super.key});

  Widget _buildImageButton({
    required String imagePath,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      splashColor: Colors.blue.withAlpha(100),
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        shrinkWrap: true,
        childAspectRatio: 1, // Square buttons
        children: [
          _buildImageButton(
            imagePath: 'assets/global_photos/events.jpg',
            onPressed: () => print('Clicked events'),
          ),
          _buildImageButton(
            imagePath: 'assets/global_photos/events.jpg',
            onPressed: () => print('Clicked button 2'),
          ),
          _buildImageButton(
            imagePath: 'assets/global_photos/events.jpg',
            onPressed: () => print('Clicked button 3'),
          ),
          _buildImageButton(
            imagePath: 'assets/global_photos/events.jpg',
            onPressed: () => print('Clicked button 4'),
          ),
        ],
      ),
    );
  }
}
