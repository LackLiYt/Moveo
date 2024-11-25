import 'package:flutter/material.dart';

class ImageTap extends StatefulWidget {
  final String url;
  final String text;

  ImageTap({required this.url, required this.text});
  @override
  _ImageTapState createState() => _ImageTapState();
}

class _ImageTapState extends State<ImageTap> {
  // This flag tracks whether the image is tapped or not
  bool _isImageTapped = false;
  late String url;
  late String text;

  @override
  void initState() {
    super.initState();
    url = widget.url;
    text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return  _isImageTapped
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _isImageTapped = false; // Update state when tapped
                  });
                },
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, size: 50, color: Colors.blue),
                  SizedBox(width: 10),
                  Text(
                    text,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ],
              )
            )
            : GestureDetector(
                onTap: () {
                  setState(() {
                    _isImageTapped = true; // Update state when tapped
                  });
                },
                child: Image.network(url,
                  width: 400,
                  height: 500,
                  fit: BoxFit.cover,)// Error icon if image fails
            );
  }
}
