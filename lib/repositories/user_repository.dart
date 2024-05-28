import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:pulse_pro/shared/models/day_entry.dart';
import 'package:pulse_pro/shared/models/workout_plan.dart';
import 'package:uuid/uuid.dart';

class UserRepository {
  Future<bool> userExists(String userId) async {
    final data = await FirebaseFirestore.instance.collection('user').doc(userId).get();
    return data.exists;
  }

  Future<void> createUserObject(
      {required String name,
      required int birthdate,
      required double weight,
      required int height,
      required String gender}) async {
    try {
      HttpsCallable callable = FirebaseFunctions.instanceFor(region: 'europe-west1').httpsCallable('createUserObject');

      // Prepare the data
      final Map<String, dynamic> data = {
        'email': FirebaseAuth.instance.currentUser?.email,
        'name': name,
        'birthdate': birthdate,
        'weight': weight,
        'height': height,
        'gender': gender,
      };
    
      await callable.call(data);
    } on FirebaseFunctionsException catch (e) {
      debugPrint('Error: ${e.code} - ${e.message}');
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<List<List<String>>> generateSplit(
      {required String gender,
      required int height,
      required double weight,
      required int birthdate,
      required String workoutGoal,
      required String workoutIntensity,
      required int maxTimesPerWeek,
      required int timePerDay,
      required List<String> injuries,
      required List<String> muscleFocus,
      required String sportOrientation,
      required String workoutExperience}) async {
    HttpsCallable callable = FirebaseFunctions.instanceFor(region: 'europe-west1').httpsCallable('createSplit');

    // Prepare the data
    final Map<String, dynamic> data = {
      'gender': gender,
      'height': height,
      'weight': weight,
      'birthdate': birthdate,
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
    log(result.data.toString());

    final jsonString = cleanJsonString(result.data['response'][0]['text']['value']);
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    List<List<String>> split = (jsonMap['split'] as List<dynamic>)
        .map((item) => (item as List<dynamic>).map((element) => element as String).toList())
        .toList();

    return split;
  }

  Future<WorkoutPlan> generateWorkoutPlan(
      {required List<List<String>> split,
      required String workoutGoal,
      required String gender,
      required int height,
      required double weight,
      required int birthdate,
      required String workoutIntensity,
      required int timePerDay,
      required List<String> injuries,
      required List<String> muscleFocus,
      required String sportOrientation,
      required String workoutExperience}) async {
    HttpsCallable callable = FirebaseFunctions.instanceFor(region: 'europe-west1').httpsCallable('createWorkoutPlan');

    // Prepare the data
    final Map<String, dynamic> data = {
      'split': split,
      'gender': gender,
      'height': height,
      'weight': weight,
      'birthdate': birthdate,
      'workout_goal': workoutGoal,
      'workout_intensity': workoutIntensity,
      'time_per_day': timePerDay * 60 * 1000,
      'injuries': injuries,
      'muscle_focus': muscleFocus,
      'sportOrientation': sportOrientation,
      'workout_experience': workoutExperience,
    };

    final HttpsCallableResult result = await callable.call(data);
    log(result.data.toString());

    final jsonString = cleanJsonString(result.data['response'][0]['text']['value']);
    Map<String, dynamic> jsonRaw = jsonDecode(jsonString);

    Map<String, dynamic> json = {
      'id': '"${const Uuid().v4()}"',
      'params': {
        'injuries': injuries,
        'muscle_focus': muscleFocus,
        'time_per_day': timePerDay,
        'workout_goal': workoutGoal,
        'workout_intensity': workoutIntensity,
      },
      'split': jsonRaw
    };

    final WorkoutPlan workoutPlan = WorkoutPlan.fromJson(const Uuid().v4(), json);

    return workoutPlan;
  }

  Future<void> updateWorkoutPlans(String userId, Map<String, WorkoutPlan> workoutPlans) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .update({'workout_plans': workoutPlans.map((key, value) => MapEntry(key, value.toJson()))});
  }

  Future<void> updateCurrentWorkoutPlan(String userId, String id) async {
    await FirebaseFirestore.instance.collection('user').doc(userId).update({'current_workout_plan': id});
  }

  Future<void> addHistoryDayEntry(String userId, HistoryDayEntry historyDayEntry) async {
    final userDoc = await FirebaseFirestore.instance.collection('user').doc(userId).get();
    if (!userDoc.exists) return;

    final history = userDoc.data()?['history'] as List<dynamic>? ?? [];
    await FirebaseFirestore.instance.collection('user').doc(userId).update({'history': [...history, historyDayEntry.toJson()]});
  }

  dynamic cleanJsonString(String jsonString) {
    const pattern = r'^```json\s*(.*?)\s*```$';
    final regex = RegExp(pattern, dotAll: true);
    final match = regex.firstMatch(jsonString);

    if (match != null && match.groupCount >= 1) {
      return match.group(1)!.trim();
    }

    return jsonString.trim();
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
