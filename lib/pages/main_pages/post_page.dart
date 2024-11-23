import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  TextEditingController postTextController = TextEditingController();
  late CameraController _cameraController;
  late List<CameraDescription> cameras;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);

    _cameraController = CameraController(frontCamera, ResolutionPreset.medium);
    await _cameraController.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'New post',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.center, // Centering all children horizontally
          children: [
            // Main Camera and Selfie Camera Section
            if (_isCameraInitialized)
              Stack(
                children: [
                  // Main Camera Preview: takes up 2/3 of the screen vertically
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        20), // Rounded corners for the main camera
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 1.6 / 3,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFD8DAEB)),
                      ),
                      child: CameraPreview(
                          _cameraController), // Main Camera Preview
                    ),
                  ),
                  // Selfie Camera Preview: pinned to the top-left corner of the main camera
                  Positioned(
                    top: 10, // Slight margin from top
                    left: 10, // Slight margin from left
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          10), // Rounded corners for selfie preview
                      child: Container(
                        width: 100, // Smaller size for selfie preview
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFD8DAEB)),
                        ),
                        child: CameraPreview(
                            _cameraController), // Selfie Camera Preview
                      ),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 20),
            // Post Text Field Section
            Container(
              width: 360,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0xFFD8DAEB)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: postTextController,
                  decoration: InputDecoration(
                    hintText: 'Write something about....',
                    hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                  ),
                  maxLines: 3,
                  maxLength: 300, // Limit to 300 characters
                  textAlign: TextAlign.start, // Text alignment
                  textDirection:
                      TextDirection.ltr, // Left to right text direction
                  buildCounter: (BuildContext context,
                      {int? currentLength, int? maxLength, bool? isFocused}) {
                    return Text(
                      '$currentLength/$maxLength',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            // Action buttons (Edit photo, Add music, etc.)
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centering the buttons
              children: [
                _buildActionButton('Edit photo'),
                SizedBox(width: 10),
                _buildActionButton('Add music'),
                SizedBox(width: 10),
                _buildActionButton('Tag friends'),
                SizedBox(width: 10),
                _buildActionButton('Add location'),
              ],
            ),
            SizedBox(height: 20),
            // Post button
            ElevatedButton(
              onPressed: () {
                // Implement post action here
              },
              child: Text('Post'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Color(0xFFE3EAF0),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF102471),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
