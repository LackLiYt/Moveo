import 'dart:io';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/features/post/controller/post_controller.dart';
import 'package:moveo/core/utils.dart';
import 'package:moveo/theme/pallete.dart';

class CreatePostView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
    builder: (context) => const CreatePostView(),
  );

  const CreatePostView({super.key});

  @override
  ConsumerState<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends ConsumerState<CreatePostView> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isRearCamera = true;
  File? _rearPhoto;
  File? _frontPhoto;
  bool _isLoading = true;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    setState(() => _isLoading = true);
    
    try {
      // Get available cameras
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        if (mounted) {
          showSnackBar(context, 'No cameras found on this device');
          setState(() => _isLoading = false);
        }
        return;
      }

      // Initialize with rear camera first
      await _setupCamera(_isRearCamera);
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Error initializing camera: $e');
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _setupCamera(bool useRearCamera) async {
    if (_cameras == null || _cameras!.isEmpty) {
      if (mounted) {
        showSnackBar(context, 'No cameras available');
        setState(() => _isLoading = false);
      }
      return;
    }

    try {
      // Find the right camera
      CameraDescription? camera;
      if (_cameras!.length == 1) {
        // Only one camera available, use it regardless
        camera = _cameras![0];
      } else {
        // Try to find the requested camera type
        for (var cam in _cameras!) {
          if ((useRearCamera && cam.lensDirection == CameraLensDirection.back) ||
              (!useRearCamera && cam.lensDirection == CameraLensDirection.front)) {
            camera = cam;
            break;
          }
        }
        // Fall back to the first camera if we couldn't find the right one
        camera ??= _cameras![0];
      }

      // Create and initialize the controller with error handling
      _cameraController = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      // Add timeout to initialization
      await _cameraController!.initialize().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Camera initialization timed out');
        },
      );
      
      if (mounted) {
        setState(() {
          _isRearCamera = useRearCamera;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Failed to initialize camera: $e');
        setState(() => _isLoading = false);
      }
      // Re-throw to be handled by the caller
      rethrow;
    }
  }

  Future<void> _takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized || _isLoading) {
      showSnackBar(context, 'Camera is not ready');
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final XFile picture = await _cameraController!.takePicture();
      
      if (_isRearCamera) {
        _rearPhoto = File(picture.path);
      } else {
        _frontPhoto = File(picture.path);
      }
      
      if (mounted) {
        setState(() => _isLoading = false);
      }
      
      // Automatically switch camera if the other photo is not taken yet
      if ((_isRearCamera && _frontPhoto == null) || (!_isRearCamera && _rearPhoto == null)) {
        _switchCamera();
      } else {
        // Optionally, provide feedback if both photos are taken and no switch is needed.
        // For example, show a confirmation or prepare for posting.
      }

    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Error taking picture: $e');
        setState(() => _isLoading = false);
      }
    }
  }
  
  Future<void> _switchCamera() async {
    if (_isLoading) return;
    
    setState(() => _isLoading = true);
    
    try {
      // Properly dispose of the current controller
      if (_cameraController != null) {
        await _cameraController!.dispose();
        _cameraController = null;
      }
      
      // Add a small delay to ensure proper cleanup
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Initialize the new camera
      await _setupCamera(!_isRearCamera);
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Failed to switch camera: $e');
        // Try to recover by reinitializing the current camera
        await _setupCamera(_isRearCamera);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
  void dispose() {
    _cameraController?.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isCapturingComplete = _rearPhoto != null && _frontPhoto != null;
    final bool isPostingLoading = ref.watch(postControllerProvider);
    
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Pallete.backgroundColor : Pallete.whiteColor,
      body: _isLoading || _cameraController == null || !_cameraController!.value.isInitialized
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
                      icon: const Icon(Icons.arrow_back),
                      color: Theme.of(context).brightness == Brightness.dark ? Pallete.whiteColor : Pallete.backgroundColor,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Row(
                      children: [
                        Text(
                          'New post',
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark ? Pallete.whiteColor : Pallete.backgroundColor,
                            fontSize: 16,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Theme.of(context).brightness == Brightness.dark ? Pallete.whiteColor : Pallete.backgroundColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Preview area (with a defined height)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SizedBox.expand(
                      child: _rearPhoto != null && _frontPhoto != null
                        ? _buildPostPreview()
                        : _buildCameraPreview(),
                    ),
                    
                    // Camera Controls and indicators (only in camera mode, positioned at the bottom within the stack)
                    if (!isCapturingComplete)
                      Positioned(
                        bottom: 20.0,
                        left: 0,
                        right: 0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Flash Icon
                                Icon(
                                  Icons.flash_on,
                                  color: Pallete.whiteColor,
                                  size: 30,
                                ),
                                // Flip Camera Icon
                                GestureDetector(
                                  onTap: _switchCamera,
                                  child: Icon(
                                    Icons.flip_camera_ios,
                                    color: Pallete.whiteColor,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Front/Rear indicators
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'front',
                                  style: TextStyle(
                                    color: !_isRearCamera ? Pallete.whiteColor : Pallete.greyColor,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'rear',
                                  style: TextStyle(
                                    color: _isRearCamera ? Pallete.whiteColor : Pallete.greyColor,
                                    fontSize: 16,
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
              
              // Capture Button Area (placed below the preview)
              if (!isCapturingComplete)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Center(
                    child: GestureDetector(
                      onTap: _takePicture,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).brightness == Brightness.dark ? Pallete.whiteColor : Pallete.backgroundColor,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark ? Pallete.whiteColor : Pallete.backgroundColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // Camera controls row (modified to be below text input)
              // We will move camera controls here or adjust their position based on final layout desire.
              // For now, keep the original controls placement or consider integrating into new layout.

              // Original Camera Controls (Consider if still needed in this exact form or should be integrated)
              // The existing floating action button for camera switch will need to be relocated or changed.

            ],
          ),
    );
  }
  
  Widget _buildCameraPreview() {
    return ClipRect(
      child: SizedBox(
        width: double.infinity,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _cameraController!.value.previewSize!.height,
            height: _cameraController!.value.previewSize!.width,
            child: CameraPreview(_cameraController!),
          ),
        ),
      ),
    );
  }
  
  Widget _buildPostPreview() {
    final bool isCapturingComplete = _rearPhoto != null && _frontPhoto != null;
    final bool isPostingLoading = ref.watch(postControllerProvider);
    
    return Column(
      children: [
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
        
        // Caption input and Post button
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Add a caption...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark ? Pallete.darkGreyColor : Pallete.greyColor.withOpacity(0.2),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
                ),
                maxLines: 3,
                style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Pallete.whiteColor : Pallete.backgroundColor)),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: isCapturingComplete && !isPostingLoading ? _sharePost : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallete.blueColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: isPostingLoading
                    ? const CircularProgressIndicator(color: Pallete.whiteColor)
                    : const Text(
                        'Post',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Pallete.whiteColor,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}