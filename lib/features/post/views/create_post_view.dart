import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:moveo/features/post/controller/post_controller.dart';
import 'package:moveo/core/utils.dart';
import 'package:moveo/theme/pallete.dart';
import 'package:moveo/core/camera/camera.dart';

class CreatePostView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
    builder: (context) => const CreatePostView(),
  );

  const CreatePostView({super.key});

  @override
  ConsumerState<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends ConsumerState<CreatePostView> {
  File? _rearPhoto;
  File? _frontPhoto;
  bool _isLoading = false;
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onImageCaptured(File image) {
    if (_rearPhoto == null) {
      setState(() => _rearPhoto = image);
    } else if (_frontPhoto == null) {
      setState(() => _frontPhoto = image);
    }
  }

  void _retakePhoto(bool isRear) {
    setState(() {
      if (isRear) {
        _rearPhoto = null;
      } else {
        _frontPhoto = null;
      }
    });
  }

  void _sharePost() {
    if (_rearPhoto == null || _frontPhoto == null) {
      showSnackBar(context, 'Please take both front and rear photos');
      return;
    }
    
    try {
      ref.read(postControllerProvider.notifier).sharePost(
        rearCameraPhoto: _rearPhoto!,
        frontCameraPhoto: _frontPhoto!,
        text: _textController.text.isNotEmpty ? _textController.text.trim() : null,
        context: context,
      );
    } catch (e) {
      showSnackBar(context, 'Error sharing post: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isCapturingComplete = _rearPhoto != null && _frontPhoto != null;
    final bool isPostingLoading = ref.watch(postControllerProvider);
    
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Pallete.backgroundColor : Pallete.whiteColor,
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              // Custom Header (matching the photo)
              Padding(
                padding: const EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).brightness == Brightness.dark ? Pallete.whiteColor : Pallete.backgroundColor,
                      ),
                    ),
                    Text(
                      'Create Post',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark ? Pallete.whiteColor : Pallete.backgroundColor,
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),

              // Preview area (with a defined height)
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SizedBox.expand(
                      child: isCapturingComplete
                        ? _buildPostPreview()
                        : _buildCameraView(),
                    ),
                  ],
                ),
              ),

              // Bottom controls
              if (isCapturingComplete) _buildBottomControls(),
            ],
          ),
    );
  }
  
  Widget _buildCameraView() {
    return Column(
      children: [
        // Camera instructions
        Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            _rearPhoto == null 
                ? 'Take a photo with the rear camera'
                : 'Now take a photo with the front camera',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).brightness == Brightness.dark 
                  ? Pallete.whiteColor 
                  : Pallete.backgroundColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        
        // Camera widget
        Expanded(
          child: CameraWidget(
            onImageCaptured: _onImageCaptured,
            enableFlash: true,
            enableCameraSwitch: true,
            resolution: ResolutionPreset.medium,
            onCameraError: () {
              showSnackBar(context, 'Camera error occurred. Please try again.');
            },
          ),
        ),
        
        // Photo indicators
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPhotoIndicator('Rear', _rearPhoto != null),
              _buildPhotoIndicator('Front', _frontPhoto != null),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoIndicator(String label, bool isCompleted) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: isCompleted ? Colors.green : Colors.grey,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: Icon(
            isCompleted ? Icons.check : Icons.camera_alt,
            color: Colors.white,
            size: 30,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isCompleted ? Colors.green : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  Widget _buildPostPreview() {
    return Column(
      children: [
        // Photo preview
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                _rearPhoto!,
                fit: BoxFit.cover,
              ),
              
              Positioned(
                right: 16,
                bottom: 16,
                width: 120,
                height: 160,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.file(
                      _frontPhoto!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Caption input
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark 
                ? Pallete.backgroundColor 
                : Pallete.whiteColor,
            border: Border(
              top: BorderSide(
                color: Colors.grey.withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
          child: TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: 'Add a caption...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
            maxLines: 3,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Retake photos button
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  _rearPhoto = null;
                  _frontPhoto = null;
                });
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? Pallete.whiteColor 
                      : Pallete.backgroundColor,
                ),
              ),
              child: Text(
                'Retake Photos',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? Pallete.whiteColor 
                      : Pallete.backgroundColor,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Share post button
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _sharePost,
              style: ElevatedButton.styleFrom(
                backgroundColor: Pallete.blueColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Share Post',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}