import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

bool isValidName(String name) {
  return name.isNotEmpty && name.length > 2;
}

bool isGenderSelected(String gender) {
  const validGenders = ['Male', 'Female', 'Other'];
  return validGenders.contains(gender);
}

String getOnboardingMessage(String gender) {
  if (isGenderSelected(gender)) {
    return 'Your Fitness Journey Starts Here.';
  } else {
    return 'Please select a gender.';
  }
}

void main() {
  group('Onboarding Logic Tests', () {
    test('Valid Name', () {
      debugPrint('Testing valid name...');
      try {
        expect(isValidName('John Doe'), isTrue);
        debugPrint('Valid name test passed');
      } catch (e) {
        debugPrint('Valid name test failed: $e');
        rethrow;
      }
    });

    test('Empty Name', () {
      debugPrint('Testing empty name...');
      try {
        expect(isValidName(''), isFalse);
        debugPrint('Empty name test passed');
      } catch (e) {
        debugPrint('Empty name test failed: $e');
        rethrow;
      }
    });

    test('Short Name', () {
      debugPrint('Testing short name...');
      try {
        expect(isValidName('Jo'), isFalse);
        debugPrint('Short name test passed');
      } catch (e) {
        debugPrint('Short name test failed: $e');
        rethrow;
      }
    });

    test('Valid Gender Selection - Male', () {
      debugPrint('Testing valid gender selection (Male)...');
      try {
        expect(isGenderSelected('Male'), isTrue);
        debugPrint('Valid gender selection (Male) test passed');
      } catch (e) {
        debugPrint('Valid gender selection (Male) test failed: $e');
        rethrow;
      }
    });

    test('Valid Gender Selection - Female', () {
      debugPrint('Testing valid gender selection (Female)...');
      try {
        expect(isGenderSelected('Female'), isTrue);
        debugPrint('Valid gender selection (Female) test passed');
      } catch (e) {
        debugPrint('Valid gender selection (Female) test failed: $e');
        rethrow;
      }
    });

    test('Invalid Gender Selection', () {
      debugPrint('Testing invalid gender selection...');
      try {
        expect(isGenderSelected('InvalidGender'), isFalse);
        debugPrint('Invalid gender selection test passed');
      } catch (e) {
        debugPrint('Invalid gender selection test failed: $e');
        rethrow;
      }
    });

    test('Onboarding Message - Valid Gender', () {
      debugPrint('Testing onboarding message for valid gender...');
      try {
        expect(getOnboardingMessage('Male'), 'Your Fitness Journey Starts Here.');
        debugPrint('Onboarding message for valid gender test passed');
      } catch (e) {
        debugPrint('Onboarding message for valid gender test failed: $e');
        rethrow;
      }
    });

    test('Onboarding Message - Invalid Gender', () {
      debugPrint('Testing onboarding message for invalid gender...');
      try {
        expect(getOnboardingMessage('InvalidGender'), 'Please select a gender.');
        debugPrint('Onboarding message for invalid gender test passed');
      } catch (e) {
        debugPrint('Onboarding message for invalid gender test failed: $e');
        rethrow;
      }
    });
  });
}
