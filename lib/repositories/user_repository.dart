import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_pro/bloc/app_state_bloc.dart';
import 'package:pulse_pro/shared/models/workout_plan.dart';
import 'package:uuid/uuid.dart';

class UserRepository {
  Future<bool> userExists(String userId) async {
    final data =
        await FirebaseFirestore.instance.collection('user').doc(userId).get();
    return data.exists;
  }

  Future<void> createUserObject(BuildContext context,
      {required String name,
      required int birthdate,
      required double weight,
      required int height,
      required String gender}) async {
    print("test1");
    try {
      if (context.read<AppStateBloc>().state is! AppStateLoggedIn) {
        return;
      }

      print("test2");

      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: 'europe-west1')
              .httpsCallable('createUserObject');

      print("test3");

      // Prepare the data
      final Map<String, dynamic> data = {
        'email': FirebaseAuth.instance.currentUser?.email,
        'name': name,
        'birthdate': birthdate,
        'weight': weight,
        'height': height,
        'gender': gender,
      };

      print("test4");

      final HttpsCallableResult result = await callable.call(data);

      print("test5");
      print(result.data['message']);
    } on FirebaseFunctionsException catch (e) {
      print('Error: ${e.code} - ${e.message}');
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<List<List<String>>> generateSplit(context,
      {required String gender,
      required String workoutGoal,
      required String workoutIntensity,
      required int maxTimesPerWeek,
      required int timePerDay,
      required List<String> injuries,
      required List<String> muscleFocus,
      required String sportOrientation,
      required String workoutExperience}) async {
    List<List<String>> split = [];

    try {
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: 'europe-west1')
              .httpsCallable('createSplit');

      // Prepare the data
      final Map<String, dynamic> data = {
        'gender': gender,
        'workout_goal': workoutGoal,
        'workout_intensity': workoutIntensity,
        'max_times_per_week': maxTimesPerWeek,
        'time_per_day': timePerDay * 60 * 1000,
        'injuries': injuries,
        'muscle_focus': muscleFocus,
        'sportOrientation': sportOrientation,
        'workout_experience': workoutExperience,
      };

      final HttpsCallableResult result = await callable.call(data);

      split = jsonDecode(result.data['message']);

      print(result.data['message']);
    } on FirebaseFunctionsException catch (e) {
      print('Error: ${e.code} - ${e.message}');
    } catch (e) {
      print('Error: $e');
    }

    return split;
  }

  Future<WorkoutPlan> generateWorkoutPlan(context,
      {required List<List<String>> split,
      required String workoutGoal,
      required String gender,
      required String workoutIntensity,
      required int timePerDay,
      required List<String> injuries,
      required List<String> muscleFocus,
      required String sportOrientation,
      required String workoutExperience}) async {
    Map<String, dynamic> json = {};

    try {
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: 'europe-west1')
              .httpsCallable('createWorkoutPlan');

      // Prepare the data
      final Map<String, dynamic> data = {
        'split': split,
        'gender': gender,
        'workout_goal': workoutGoal,
        'workout_intensity': workoutIntensity,
        'time_per_day': timePerDay * 60 * 1000,
        'injuries': injuries,
        'muscle_focus': muscleFocus,
        'sportOrientation': sportOrientation,
        'workout_experience': workoutExperience,
      };

      final HttpsCallableResult result = await callable.call(data);

      json = jsonDecode(result.data['message']);

      print(result.data['message']);
    } on FirebaseFunctionsException catch (e) {
      print('Error: ${e.code} - ${e.message}');
    } catch (e) {
      print('Error: $e');
    }

    return WorkoutPlan.fromJson(Uuid().v4(), json);
  }

  Future<void> updateWorkoutPlans(
      String userId, Map<String, WorkoutPlan> workoutPlans) async {
    await FirebaseFirestore.instance.collection('user').doc(userId).update({
      'workout_plans':
          workoutPlans.map((key, value) => MapEntry(key, value.toJson()))
    });
  }
}


enum SportOrientation {
  none,
  archery,
  badminton,
  baseball,
  basketball,
  boxing,
  climbing,
  cricket,
  crossfit,
  cycling,
  fencing,
  fieldHockey,
  football,
  golf,
  gymnastics,
  handball,
  hiking,
  hockey,
  iceHockey,
  judo,
  karate,
  kickboxing,
  lacrosse,
  martialArts,
  mountainBiking,
  netball,
  parkour,
  rowing,
  rugby,
  running,
  sailing,
  skiing,
  snowboarding,
  squash,
  surfing,
  swimming,
  tableTennis,
  taekwondo,
  tennis,
  triathlon,
  volleyball,
  waterPolo,
  weightlifting,
  wrestling
}
