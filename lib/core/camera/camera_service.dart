import 'dart:io';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// High-performance camera service with proper lifecycle management
class CameraService {
  static CameraService? _instance;
  static CameraService get instance => _instance ??= CameraService._();
  
  CameraService._();

  // Camera state
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  CameraDescription? _currentCamera;
  bool _isInitialized = false;
  bool _isInitializing = false;
  
  // Stream controllers for state updates
  final StreamController<CameraState> _stateController = StreamController<CameraState>.broadcast();
  final StreamController<CameraError> _errorController = StreamController<CameraError>.broadcast();
  
  // Getters
  CameraController? get controller => _controller;
  List<CameraDescription>? get cameras => _cameras;
  CameraDescription? get currentCamera => _currentCamera;
  bool get isInitialized => _isInitialized;
  bool get isInitializing => _isInitializing;
  
  // Streams
  Stream<CameraState> get stateStream => _stateController.stream;
  Stream<CameraError> get errorStream => _errorController.stream;

  /// Initialize camera service with proper permission handling
  Future<bool> initialize() async {
    if (_isInitializing || _isInitialized) return _isInitialized;
    
    _isInitializing = true;
    _stateController.add(CameraState.initializing);
    
    try {
      // Check and request camera permissions
      final permissionStatus = await _requestCameraPermissions();
      if (!permissionStatus) {
        _errorController.add(CameraError.permissionDenied());
        return false;
      }

      // Get available cameras
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        _errorController.add(CameraError.noCamerasAvailable());
        return false;
      }

      // Set default camera (rear camera preferred)
      _currentCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras!.first,
      );

      // Initialize camera controller
      await _initializeController();
      
      _isInitialized = true;
      _stateController.add(CameraState.ready);
      return true;
      
    } catch (e) {
      _errorController.add(CameraError.initializationFailed(e.toString()));
      return false;
    } finally {
      _isInitializing = false;
    }
  }

  /// Request camera permissions with proper handling
  Future<bool> _requestCameraPermissions() async {
    try {
      // Check current permission status
      PermissionStatus status = await Permission.camera.status;
      
      if (status.isGranted) return true;
      
      // Request permission if not granted
      if (status.isDenied) {
        status = await Permission.camera.request();
        if (status.isGranted) return true;
      }
      
      // Handle permanently denied
      if (status.isPermanentlyDenied) {
        // Open app settings
        await openAppSettings();
        return false;
      }
      
      return false;
    } catch (e) {
      debugPrint('Permission request error: $e');
      return false;
    }
  }

  /// Initialize camera controller with optimized settings
  Future<void> _initializeController() async {
    if (_currentCamera == null) throw Exception('No camera selected');
    
    // Dispose existing controller
    await _disposeController();
    
    // Create new controller with optimized settings
    _controller = CameraController(
      _currentCamera!,
      ResolutionPreset.medium, // Balanced performance and quality
      enableAudio: false, // Disable audio for better performance
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Initialize with timeout
    await _controller!.initialize().timeout(
      const Duration(seconds: 10),
      onTimeout: () => throw TimeoutException('Camera initialization timed out'),
    );

    // Set optimal settings
    await _optimizeCameraSettings();
  }

  /// Optimize camera settings for performance
  Future<void> _optimizeCameraSettings() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    
    try {
      // Set flash mode based on camera type
      if (_currentCamera?.lensDirection == CameraLensDirection.front) {
        await _controller!.setFlashMode(FlashMode.off);
      } else {
        await _controller!.setFlashMode(FlashMode.auto);
      }
      
      // Set focus mode for better image quality
      await _controller!.setFocusMode(FocusMode.auto);
      
      // Set exposure mode
      await _controller!.setExposureMode(ExposureMode.auto);
      
    } catch (e) {
      debugPrint('Failed to optimize camera settings: $e');
    }
  }

  /// Switch between cameras
  Future<bool> switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) return false;
    
    try {
      _stateController.add(CameraState.switching);
      
      // Find next camera
      final currentIndex = _cameras!.indexOf(_currentCamera!);
      final nextIndex = (currentIndex + 1) % _cameras!.length;
      _currentCamera = _cameras![nextIndex];
      
      // Reinitialize controller
      await _initializeController();
      
      _stateController.add(CameraState.ready);
      return true;
      
    } catch (e) {
      _errorController.add(CameraError.switchFailed(e.toString()));
      return false;
    }
  }

  /// Take a picture with error handling
  Future<File?> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      _errorController.add(CameraError.notReady());
      return null;
    }
    
    try {
      _stateController.add(CameraState.capturing);
      
      final XFile picture = await _controller!.takePicture();
      final file = File(picture.path);
      
      _stateController.add(CameraState.ready);
      return file;
      
    } catch (e) {
      _errorController.add(CameraError.captureFailed(e.toString()));
      return null;
    }
  }

  /// Toggle flash mode
  Future<bool> toggleFlash() async {
    if (_controller == null || !_controller!.value.isInitialized) return false;
    
    try {
      final currentMode = _controller!.value.flashMode;
      FlashMode newMode;
      
      switch (currentMode) {
        case FlashMode.off:
          newMode = FlashMode.auto;
          break;
        case FlashMode.auto:
          newMode = FlashMode.always;
          break;
        case FlashMode.always:
          newMode = FlashMode.torch;
          break;
        case FlashMode.torch:
          newMode = FlashMode.off;
          break;
        default:
          newMode = FlashMode.off;
      }
      
      await _controller!.setFlashMode(newMode);
      return true;
      
    } catch (e) {
      _errorController.add(CameraError.flashToggleFailed(e.toString()));
      return false;
    }
  }

  /// Get current flash mode
  FlashMode? getFlashMode() {
    return _controller?.value.flashMode;
  }

  /// Check if flash is available
  bool get isFlashAvailable {
    return _controller?.value.flashMode != FlashMode.off;
  }

  /// Get camera preview size
  Size? getPreviewSize() {
    if (_controller?.value.previewSize == null) return null;
    
    final previewSize = _controller!.value.previewSize!;
    return Size(previewSize.width, previewSize.height);
  }

  /// Dispose camera controller properly
  Future<void> _disposeController() async {
    if (_controller != null) {
      try {
        await _controller!.dispose();
      } catch (e) {
        debugPrint('Error disposing camera controller: $e');
      }
      _controller = null;
    }
  }

  /// Dispose entire camera service
  Future<void> dispose() async {
    _isInitialized = false;
    _isInitializing = false;
    
    await _disposeController();
    
    await _stateController.close();
    await _errorController.close();
    
    _instance = null;
  }

  /// Reset camera service
  Future<void> reset() async {
    await dispose();
    _instance = null;
  }
}

/// Camera states
enum CameraState {
  initializing,
  ready,
  capturing,
  switching,
  error,
}

/// Camera errors
class CameraError {
  final String message;
  final CameraErrorType type;
  
  const CameraError._(this.type, this.message);
  
  factory CameraError.permissionDenied() => const CameraError._(CameraErrorType.permissionDenied, 'Camera permission denied');
  factory CameraError.noCamerasAvailable() => const CameraError._(CameraErrorType.noCamerasAvailable, 'No cameras available');
  factory CameraError.initializationFailed(String error) => CameraError._(CameraErrorType.initializationFailed, 'Initialization failed: $error');
  factory CameraError.notReady() => const CameraError._(CameraErrorType.notReady, 'Camera not ready');
  factory CameraError.captureFailed(String error) => CameraError._(CameraErrorType.captureFailed, 'Capture failed: $error');
  factory CameraError.switchFailed(String error) => CameraError._(CameraErrorType.switchFailed, 'Camera switch failed: $error');
  factory CameraError.flashToggleFailed(String error) => CameraError._(CameraErrorType.flashToggleFailed, 'Flash toggle failed: $error');
}

/// Camera error types
enum CameraErrorType {
  permissionDenied,
  noCamerasAvailable,
  initializationFailed,
  notReady,
  captureFailed,
  switchFailed,
  flashToggleFailed,
}
