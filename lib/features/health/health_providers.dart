import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart';
import 'package:moveo/features/health/health_data.dart';
import 'package:moveo/features/progress/controller/progress_controller.dart';

final healthProvider = Provider((ref) => Health());

final stepDataProvider = FutureProvider<int?>((ref) async {
  final health = ref.watch(healthProvider);
  final steps = await fetchStepData(health);
  
  if (steps != null) {
    // Update progress with the new steps
    await ref.read(progressControllerProvider.notifier).updateProgressForSteps(steps);
  }
  
  return steps;
});

final dailyStepsProvider = FutureProvider<int?>((ref) async {
  final health = ref.watch(healthProvider);
  final steps = await fetchDailyStepData(health);
  
  if (steps != null) {
    // Update progress with the new steps
    await ref.read(progressControllerProvider.notifier).updateProgressForSteps(steps);
  }
  
  return steps;
});

final weeklyStepsProvider = FutureProvider<int?>((ref) async {
  final health = ref.watch(healthProvider);
  return await fetchWeeklyStepData(health);
});

final monthlyStepsProvider = FutureProvider<int?>((ref) async {
  final health = ref.watch(healthProvider);
  return await fetchMonthlyStepData(health);
}); 