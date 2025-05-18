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
      appBar: AppBar(
        title: Text(_isRearCamera 
          ? (_rearPhoto == null ? 'Take Rear Photo' : 'Rear Photo Taken') 
          : (_frontPhoto == null ? 'Take Front Photo' : 'Front Photo Taken')),
        actions: [
          if (isCapturingComplete)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: !isPostingLoading ? _sharePost : null,
            ),
        ],
      ),
      body: _isLoading || _cameraController == null || !_cameraController!.value.isInitialized
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              // Preview area
              Expanded(
                child: _rearPhoto != null && _frontPhoto != null
                  ? _buildPostPreview()
                  : _buildCameraPreview(),
              ),
              
              // Text input (only when both photos are taken)
              if (isCapturingComplete)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Add a caption (optional)',
                      border: const OutlineInputBorder(),
                      fillColor: Theme.of(context).brightness == Brightness.dark ? Pallete.backgroundColor : Pallete.whiteColor,
                      filled: true,
                      hintStyle: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark ? Pallete.greyColor : Pallete.darkGreyColor,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark ? Pallete.whiteColor : Pallete.backgroundColor,
                    ),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    autofocus: false,
                    onChanged: (value) {
                      // Force a rebuild to ensure text is captured
                      setState(() {});
                    },
                  ),
                ),
              
              // Photo info
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Chip(
                      label: Text('Rear: ${_rearPhoto != null ? "✓" : "×"}'),
                      backgroundColor: _rearPhoto != null ? Colors.green.shade100 : Colors.red.shade100,
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      label: Text('Front: ${_frontPhoto != null ? "✓" : "×"}'),
                      backgroundColor: _frontPhoto != null ? Colors.green.shade100 : Colors.red.shade100,
                    ),
                  ],
                ),
              ),
            ],
          ),
      bottomNavigationBar: _isLoading || isPostingLoading
        ? const LinearProgressIndicator()
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (!isCapturingComplete)
                  FloatingActionButton(
                    heroTag: 'take_photo',
                    onPressed: _takePicture,
                    child: const Icon(Icons.camera),
                  ),
                if (!isCapturingComplete)
                  FloatingActionButton(
                    heroTag: 'switch_camera',
                    onPressed: _switchCamera,
                    child: Icon(_isRearCamera ? Icons.camera_front : Icons.camera_rear),
                  ),
                if (isCapturingComplete)
                  FloatingActionButton(
                    heroTag: 'retake_photos',
                    onPressed: () {
                      setState(() {
                        _rearPhoto = null;
                        _frontPhoto = null;
                      });
                      _initializeCamera();
                    },
                    child: const Icon(Icons.refresh),
                  ),
                if (isCapturingComplete)
                  FloatingActionButton(
                    heroTag: 'share_post',
                    onPressed: _sharePost,
                    child: const Icon(Icons.send),
                  ),
              ],
            ),
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
    return Column(
      children: [
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Main (rear) photo
              Image.file(
                _rearPhoto!,
                fit: BoxFit.cover,
              ),
              
              // Selfie overlay
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
      ],
    );
  }
}