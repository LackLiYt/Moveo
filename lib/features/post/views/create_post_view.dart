import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:moveo/features/post/views/controller/post_controller.dart';
import 'package:path_provider/path_provider.dart';

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
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  bool _isCameraInitialized = false;
  bool _isPosting = false;
  File? _rearCameraPhoto;
  File? _frontCameraPhoto;
  CameraDescription? _frontCamera;
  CameraDescription? _rearCamera;
  
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      // Get available cameras
      cameras = await availableCameras();
      if (cameras == null || cameras!.isEmpty) {
        print("No cameras available");
        return;
      }
      
      // Find front and rear cameras
      _frontCamera = cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras!.first,
      );
      
      _rearCamera = cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras!.first,
      );

      // Initialize with front camera first
      _cameraController = CameraController(_frontCamera!, ResolutionPreset.medium);
      await _cameraController!.initialize();
      
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
      
      // Create temporary files for photos
      await _createTempPhotoFiles();
      
    } catch (e) {
      print('Camera initialization error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Camera error: $e')),
        );
      }
    }
  }
  
  Future<void> _createTempPhotoFiles() async {
    try {
      final tempDir = await getTemporaryDirectory();
      _rearCameraPhoto = File('${tempDir.path}/rear_camera_photo.jpg');
      _frontCameraPhoto = File('${tempDir.path}/front_camera_photo.jpg');
    } catch (e) {
      print('Error creating temp files: $e');
    }
  }
  
  Future<void> _takePhoto(bool isRearCamera) async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    
    try {
      // Take photo
      final xFile = await _cameraController!.takePicture();
      
      // Determine which file to save to
      final targetFile = isRearCamera ? _rearCameraPhoto : _frontCameraPhoto;
      
      if (targetFile != null) {
        // Create a copy of the image file
        final bytes = await File(xFile.path).readAsBytes();
        await targetFile.writeAsBytes(bytes);
        
        // Update UI
        setState(() {});
      }
    } catch (e) {
      print('Error taking photo: $e');
    }
  }
  
  Future<void> _switchCamera() async {
    if (_cameraController == null || 
        cameras == null || 
        cameras!.isEmpty || 
        _frontCamera == null || 
        _rearCamera == null) {
      return;
    }
    
    // Determine which camera to switch to
    final isCurrentlyFront = 
        _cameraController!.description.lensDirection == CameraLensDirection.front;
    final newCamera = isCurrentlyFront ? _rearCamera! : _frontCamera!;
    
    // Dispose current controller
    await _cameraController!.dispose();
    
    // Create new controller with other camera
    _cameraController = CameraController(newCamera, ResolutionPreset.medium);
    
    // Initialize new controller
    try {
      await _cameraController!.initialize();
      setState(() {});
    } catch (e) {
      print('Error switching camera: $e');
    }
  }

  @override
  void dispose() {
    postTextController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }
  
  void _sharePost() async {
    if (_rearCameraPhoto == null || !_rearCameraPhoto!.existsSync() ||
        _frontCameraPhoto == null || !_frontCameraPhoto!.existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please take both photos before posting')),
      );
      return;
    }
    
    setState(() {
      _isPosting = true;
    });
    
    try {
      // Call the controller to share the post
      await ref.read(PostControllerProvider.notifier).sharePost(
        rearCameraPhoto: _rearCameraPhoto!,
        frontCameraPhoto: _frontCameraPhoto!,
        text: postTextController.text,
        context: context,
      );
      
      // Go back to previous screen after posting
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPosting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;
    
    // Adaptive text color based on theme
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close, size: 30, color: textColor),
        ),
        centerTitle: true,
        title: Text(
          'New Post',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_isCameraInitialized && _cameraController != null)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: double.infinity,
                        height: screenSize.height * 0.4,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFD8DAEB)),
                        ),
                        child: CameraPreview(_cameraController!),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: screenSize.width * 0.25,
                          height: screenSize.width * 0.25,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFD8DAEB)),
                          ),
                          child: _rearCameraPhoto != null && _rearCameraPhoto!.existsSync()
                              ? Image.file(_rearCameraPhoto!, fit: BoxFit.cover)
                              : Container(color: Colors.grey),
                        ),
                      ),
                    ),
                    // Camera controls
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Take photo button
                          FloatingActionButton(
                            heroTag: "takephoto",
                            onPressed: () => _takePhoto(_cameraController!.description.lensDirection == CameraLensDirection.back),
                            backgroundColor: Colors.white,
                            child: const Icon(Icons.camera, color: Colors.black),
                          ),
                          // Switch camera button
                          FloatingActionButton(
                            heroTag: "switchcamera",
                            onPressed: _switchCamera,
                            backgroundColor: Colors.white,
                            child: const Icon(Icons.flip_camera_ios, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: TextField(
                  controller: postTextController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: 'Write about something...',
                    hintStyle: TextStyle(
                      color: textColor.withOpacity(0.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: const Color(0xFFD8DAEB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  maxLines: 3,
                  maxLength: 300,
                  buildCounter: (BuildContext context,
                      {int? currentLength, int? maxLength, bool? isFocused}) {
                    return Text(
                      '${currentLength ?? 0}/${maxLength ?? 300}',
                      style: TextStyle(
                        color: textColor.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildActionButton('Edit photo', screenSize, textColor),
                    const SizedBox(width: 10),
                    _buildActionButton('Add music', screenSize, textColor),
                    const SizedBox(width: 10),
                    _buildActionButton('Tag friends', screenSize, textColor),
                    const SizedBox(width: 10),
                    _buildActionButton('Add location', screenSize, textColor),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isPosting ? null : _sharePost,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: isDarkMode ? Colors.blue : Colors.blue,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey,
                ),
                child: _isPosting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, Size screenSize, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE3EAF0),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color(0xFF102471),
          fontSize: screenSize.width * 0.03,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}