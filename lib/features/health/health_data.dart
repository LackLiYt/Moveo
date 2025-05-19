import 'dart:async';
import 'dart:io';

import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestHealthPermissions() async {
  final types = [
    HealthDataType.STEPS,
    HealthDataType.WEIGHT,
    HealthDataType.HEIGHT,
    HealthDataType.BLOOD_OXYGEN,
    HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
    HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    HealthDataType.BODY_TEMPERATURE,
    HealthDataType.BODY_FAT_PERCENTAGE,
    HealthDataType.HEART_RATE,
    HealthDataType.RESTING_HEART_RATE,
    HealthDataType.WAIST_CIRCUMFERENCE,
  ];

  final permissions = await Permission.activityRecognition.request();
  if (permissions.isGranted) {
    return true;
  }
  return false;
}

Future<int?> fetchStepData(Health health) async {
  final now = DateTime.now();
  final midnight = DateTime(now.year, now.month, now.day);
  
  try {
    final steps = await health.getTotalStepsInInterval(midnight, now);
    return steps;
  } catch (e) {
    print('Error fetching step data: $e');
    return null;
  }
}

Future<int?> fetchDailyStepData(Health health) async {
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  
  try {
    final steps = await health.getTotalStepsInInterval(startOfDay, now);
    return steps;
  } catch (e) {
    print('Error fetching daily step data: $e');
    return null;
  }
}

Future<int?> fetchWeeklyStepData(Health health) async {
  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  final startOfDay = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
  
  try {
    final steps = await health.getTotalStepsInInterval(startOfDay, now);
    return steps;
  } catch (e) {
    print('Error fetching weekly step data: $e');
    return null;
  }
}

Future<int?> fetchMonthlyStepData(Health health) async {
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  
  try {
    final steps = await health.getTotalStepsInInterval(startOfMonth, now);
    return steps;
  } catch (e) {
    print('Error fetching monthly step data: $e');
    return null;
  }
}