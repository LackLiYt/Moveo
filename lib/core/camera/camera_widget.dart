import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'camera_provider.dart';
import 'camera_service.dart';

/// High-performance camera widget with proper lifecycle management
class CameraWidget extends ConsumerStatefulWidget {
  final Function(File) onImageCaptured;
  final bool enableFlash;
  final bool enableCameraSwitch;
  final ResolutionPreset resolution;
  final Widget? overlay;
  final VoidCallback? onCameraError;

  const CameraWidget({
    super.key,
    required this.onImageCaptured,
    this.enableFlash = true,
    this.enableCameraSwitch = true,
    this.resolution = ResolutionPreset.medium,
    this.overlay,
    this.onCameraError,
  });

  @override
  ConsumerState<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends ConsumerState<CameraWidget>
    with WidgetsBindingObserver {
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _isDisposed = true;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle changes for camera
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      // Pause camera when app goes to background
      _pauseCamera();
    } else if (state == AppLifecycleState.resumed) {
      // Resume camera when app comes to foreground
      _resumeCamera();
    }
  }

  void _pauseCamera() {
    // Camera service handles this automatically
  }

  void _resumeCamera() {
    // Camera service handles this automatically
  }

  Future<void> _takePicture() async {
    final image = await ref.read(cameraProvider.notifier).takePicture();
    if (image != null && !_isDisposed) {
      widget.onImageCaptured(image);
    }
  }

  Future<void> _switchCamera() async {
    if (widget.enableCameraSwitch) {
      await ref.read(cameraProvider.notifier).switchCamera();
    }
  }

  Future<void> _toggleFlash() async {
    if (widget.enableFlash) {
      await ref.read(cameraProvider.notifier).toggleFlash();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cameraState = ref.watch(cameraProvider);

    // Handle errors
    if (cameraState.error != null) {
      widget.onCameraError?.call();
      return _buildErrorView(cameraState.error!);
    }

    // Handle loading states
    if (cameraState.isInitializing) {
      return _buildLoadingView();
    }

    // Handle camera not ready
    if (!cameraState.isInitialized || cameraState.controller == null) {
      return _buildNotReadyView();
    }

    return _buildCameraView(cameraState);
  }

  Widget _buildErrorView(CameraError error) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Camera Error',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.message,
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(cameraProvider.notifier).reset();
              },
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              'Initializing Camera...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotReadyView() {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Text(
          'Camera not ready',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildCameraView(CameraViewState state) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Camera preview
        _buildCameraPreview(state.controller!),
        
        // Overlay
        if (widget.overlay != null) widget.overlay!,
        
        // Camera controls
        _buildCameraControls(state),
        
        // Capture button
        _buildCaptureButton(state),
      ],
    );
  }

  Widget _buildCameraPreview(CameraController controller) {
    return ClipRect(
      child: SizedBox(
        width: double.infinity,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: controller.value.previewSize!.height,
            height: controller.value.previewSize!.width,
            child: CameraPreview(controller),
          ),
        ),
      ),
    );
  }

  Widget _buildCameraControls(CameraViewState state) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      right: 16,
      child: Column(
        children: [
          // Flash toggle
          if (widget.enableFlash && state.controller?.value.flashMode != FlashMode.off)
            _buildControlButton(
              icon: _getFlashIcon(state.controller?.value.flashMode),
              onTap: _toggleFlash,
            ),
          
          const SizedBox(height: 16),
          
          // Camera switch
          if (widget.enableCameraSwitch && (state.cameras?.length ?? 0) > 1)
            _buildControlButton(
              icon: Icons.flip_camera_ios,
              onTap: _switchCamera,
            ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildCaptureButton(CameraViewState state) {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 32,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: state.isCapturing ? null : _takePicture,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 4,
              ),
            ),
            child: Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: state.isCapturing ? Colors.grey : Colors.white,
                  shape: BoxShape.circle,
                ),
                child: state.isCapturing
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getFlashIcon(FlashMode? flashMode) {
    switch (flashMode) {
      case FlashMode.off:
        return Icons.flash_off;
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.always:
        return Icons.flash_on;
      case FlashMode.torch:
        return Icons.flash_on;
      default:
        return Icons.flash_off;
    }
  }
}
