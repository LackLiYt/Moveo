import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'camera_service.dart';

/// Camera state notifier provider
final cameraProvider = StateNotifierProvider<CameraNotifier, CameraViewState>((ref) {
  return CameraNotifier();
});

/// Camera view state
class CameraViewState {
  final bool isInitialized;
  final bool isInitializing;
  final bool isCapturing;
  final bool isSwitching;
  final CameraController? controller;
  final List<CameraDescription>? cameras;
  final CameraDescription? currentCamera;
  final CameraError? error;
  final File? lastCapturedImage;

  const CameraViewState({
    this.isInitialized = false,
    this.isInitializing = false,
    this.isCapturing = false,
    this.isSwitching = false,
    this.controller,
    this.cameras,
    this.currentCamera,
    this.error,
    this.lastCapturedImage,
  });

  CameraViewState copyWith({
    bool? isInitialized,
    bool? isInitializing,
    bool? isCapturing,
    bool? isSwitching,
    CameraController? controller,
    List<CameraDescription>? cameras,
    CameraDescription? currentCamera,
    CameraError? error,
    File? lastCapturedImage,
    bool clearError = false,
    bool clearImage = false,
  }) {
    return CameraViewState(
      isInitialized: isInitialized ?? this.isInitialized,
      isInitializing: isInitializing ?? this.isInitializing,
      isCapturing: isCapturing ?? this.isCapturing,
      isSwitching: isSwitching ?? this.isSwitching,
      controller: controller ?? this.controller,
      cameras: cameras ?? this.cameras,
      currentCamera: currentCamera ?? this.currentCamera,
      error: clearError ? null : (error ?? this.error),
      lastCapturedImage: clearImage ? null : (lastCapturedImage ?? this.lastCapturedImage),
    );
  }
}

/// Camera notifier for state management
class CameraNotifier extends StateNotifier<CameraViewState> {
  CameraNotifier() : super(const CameraViewState()) {
    _initializeCamera();
  }

  /// Initialize camera
  Future<void> _initializeCamera() async {
    state = state.copyWith(isInitializing: true);
    
    final success = await CameraService.instance.initialize();
    
    if (success) {
      state = state.copyWith(
        isInitialized: true,
        isInitializing: false,
        controller: CameraService.instance.controller,
        cameras: CameraService.instance.cameras,
        currentCamera: CameraService.instance.currentCamera,
      );
      
      // Listen to camera service streams
      _listenToCameraService();
    } else {
      state = state.copyWith(
        isInitializing: false,
        error: CameraError.initializationFailed('Failed to initialize camera'),
      );
    }
  }

  /// Listen to camera service state changes
  void _listenToCameraService() {
    CameraService.instance.stateStream.listen((cameraState) {
      switch (cameraState) {
        case CameraState.initializing:
          state = state.copyWith(isInitializing: true);
          break;
        case CameraState.ready:
          state = state.copyWith(
            isInitializing: false,
            isCapturing: false,
            isSwitching: false,
            controller: CameraService.instance.controller,
            currentCamera: CameraService.instance.currentCamera,
          );
          break;
        case CameraState.capturing:
          state = state.copyWith(isCapturing: true);
          break;
        case CameraState.switching:
          state = state.copyWith(isSwitching: true);
          break;
        case CameraState.error:
          // Handle error state
          break;
      }
    });

    CameraService.instance.errorStream.listen((error) {
      state = state.copyWith(
        error: error,
        isInitializing: false,
        isCapturing: false,
        isSwitching: false,
      );
    });
  }

  /// Switch camera
  Future<void> switchCamera() async {
    if (state.isSwitching || state.isInitializing) return;
    
    state = state.copyWith(isSwitching: true);
    
    final success = await CameraService.instance.switchCamera();
    
    if (success) {
      state = state.copyWith(
        isSwitching: false,
        controller: CameraService.instance.controller,
        currentCamera: CameraService.instance.currentCamera,
      );
    } else {
      state = state.copyWith(isSwitching: false);
    }
  }

  /// Take picture
  Future<File?> takePicture() async {
    if (state.isCapturing || !state.isInitialized) return null;
    
    final image = await CameraService.instance.takePicture();
    
    if (image != null) {
      state = state.copyWith(lastCapturedImage: image);
    }
    
    return image;
  }

  /// Toggle flash
  Future<void> toggleFlash() async {
    if (!state.isInitialized) return;
    
    await CameraService.instance.toggleFlash();
    
    // Update state with new controller
    state = state.copyWith(controller: CameraService.instance.controller);
  }

  /// Get current flash mode
  FlashMode? getFlashMode() {
    return CameraService.instance.getFlashMode();
  }

  /// Check if flash is available
  bool get isFlashAvailable {
    return CameraService.instance.isFlashAvailable;
  }

  /// Get preview size
  Size? getPreviewSize() {
    return CameraService.instance.getPreviewSize();
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Clear last captured image
  void clearLastImage() {
    state = state.copyWith(clearImage: true);
  }

  /// Reset camera
  Future<void> reset() async {
    await CameraService.instance.reset();
    state = const CameraViewState();
    _initializeCamera();
  }

  @override
  void dispose() {
    // Don't dispose the camera service here as it's a singleton
    super.dispose();
  }
}
