import 'package:flutter/material.dart';

class CarouselImage extends StatefulWidget {
  final List<String> imageLinks;
  const CarouselImage({
    super.key,
    required this.imageLinks,
    });

  @override
  State<CarouselImage> createState() => _CarouselImageState();
}

class _CarouselImageState extends State<CarouselImage> {
  final int _current = 0;
  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Column()
      ],
    );
  }
}