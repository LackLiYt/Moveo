import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const CreatePostScreen(),
      );
  const CreatePostScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
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

    _cameraController = CameraController(frontCamera, ResolutionPreset.high);
    await _cameraController.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
    postTextController.dispose();
    _cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.close, size: 30),
        ),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_isCameraInitialized)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 1.6 / 3,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFD8DAEB)),
                      ),
                      child: CameraPreview(_cameraController),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFD8DAEB)),
                        ),
                        child: CameraPreview(_cameraController),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            Container(
              width: 360,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFD8DAEB)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: postTextController,
                  decoration: InputDecoration(
                    hintText: 'Write about something....',
                    hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                  ),
                  maxLines: 3,
                  maxLength: 300,
                  textAlign: TextAlign.start,
                  textDirection: TextDirection.ltr,
                  buildCounter: (BuildContext context,
                      {int? currentLength, int? maxLength, bool? isFocused}) {
                    return Text(
                      '$currentLength/$maxLength',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Action buttons (Edit photo, Add music, etc.)
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Centering the buttons
              children: [
                _buildActionButton('Edit photo'),
                const SizedBox(width: 10),
                _buildActionButton('Add music'),
                const SizedBox(width: 10),
                _buildActionButton('Tag friends'),
                const SizedBox(width: 10),
                _buildActionButton('Add location'),
              ],
            ),
            const SizedBox(height: 20),
            // Post button
            ElevatedButton(
              onPressed: () {
                // Implement post action here
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Post'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE3EAF0),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF102471),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
