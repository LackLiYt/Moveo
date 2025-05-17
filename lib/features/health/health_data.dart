import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health/health.dart';

  Future<int?> fetchStepData(Health health) async{
    int? steps;

    var types = [
      HealthDataType.STEPS,
    ];
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    var permissions = [
      HealthDataAccess.READ
    ];

    bool requested = await health.requestAuthorization(types, permissions: permissions);

    if (requested){
      try{
        steps = await health.getTotalStepsInInterval(midnight, now);
        return steps;
      }catch(error){
        print("Error: $error");
      }

      print("Total number of steps: $steps");



  }
}