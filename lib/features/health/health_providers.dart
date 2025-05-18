import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart';
import 'package:moveo/features/health/health_data.dart';
import 'package:moveo/features/progress/controller/progress_controller.dart';
import 'package:moveo/features/auth/controller/auth_controller.dart';

final healthProvider = Provider((ref) => Health());

final stepDataProvider = FutureProvider<int?>((ref) async {
  final health = ref.watch(healthProvider);
  final steps = await fetchStepData(health);
  
  // Get the current user details
  final userDetails = await ref.watch(currentUserDetailsProvider.future);
  if (userDetails != null && steps != null) {
    // Update progress with the new steps
    await ref.read(progressControllerProvider.notifier).updateProgressForSteps(userDetails, steps);
  }
  
  return steps;
}); 