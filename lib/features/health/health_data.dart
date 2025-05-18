import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:health/health.dart';

Future<int?> fetchStepData(Health health) async {
  int? steps;

  var types = [
    HealthDataType.STEPS,
  ];
  final now = DateTime.now();
  final midnight = DateTime(now.year, now.month, now.day);

  var permissions = [
    HealthDataAccess.READ,
    HealthDataAccess.WRITE,
  ];

  try {
    // Request authorization
    bool requested = await health.requestAuthorization(types, permissions: permissions);

    if (requested) {
      try {
        if (Platform.isAndroid) {
          // Android implementation
          try {
            // First try to get total steps for today
            steps = await health.getTotalStepsInInterval(midnight, now);
          } catch (e) {
            print("Error getting total steps on Android: $e");
          }

          // If steps is null, try getting the latest step count
          if (steps == null) {
            try {
              final latestSteps = await health.getHealthDataFromTypes(
                types: types,
                startTime: midnight,
                endTime: now,
              );
              if (latestSteps.isNotEmpty) {
                steps = latestSteps.first.value as int?;
              }
            } catch (e) {
              print("Error getting latest steps on Android: $e");
            }
          }
        } else if (Platform.isIOS) {
          // iOS implementation
          try {
            // iOS has better support for getting total steps
            steps = await health.getTotalStepsInInterval(midnight, now);
          } catch (e) {
            print("Error getting steps on iOS: $e");
            
            // Fallback for iOS if the primary method fails
            try {
              final latestSteps = await health.getHealthDataFromTypes(
                types: types,
                startTime: midnight,
                endTime: now,
              );
              if (latestSteps.isNotEmpty) {
                steps = latestSteps.first.value as int?;
              }
            } catch (e) {
              print("Error getting latest steps on iOS: $e");
            }
          }
        }
        
        print("Successfully fetched steps: $steps");
        return steps;
      } catch (error) {
        print("Error fetching steps: $error");
      }
    } else {
      print("Authorization not granted");
    }
  } catch (e) {
    print("Error requesting authorization: $e");
  }

  return null;
}