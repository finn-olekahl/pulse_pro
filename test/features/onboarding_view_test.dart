
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
      try {
        expect(isValidName('John Doe'), isTrue);
      } catch (e) {
        rethrow;
      }
    });

    test('Empty Name', () {
      try {
        expect(isValidName(''), isFalse);
      } catch (e) {
        rethrow;
      }
    });

    test('Short Name', () {
      try {
        expect(isValidName('Jo'), isFalse);
      } catch (e) {
        rethrow;
      }
    });

    test('Valid Gender Selection - Male', () {
      try {
        expect(isGenderSelected('Male'), isTrue);
      } catch (e) {
        rethrow;
      }
    });

    test('Valid Gender Selection - Female', () {
      try {
        expect(isGenderSelected('Female'), isTrue);
      } catch (e) {
        rethrow;
      }
    });

    test('Invalid Gender Selection', () {
      try {
        expect(isGenderSelected('InvalidGender'), isFalse);
      } catch (e) {
        rethrow;
      }
    });

    test('Onboarding Message - Valid Gender', () {
      try {
        expect(getOnboardingMessage('Male'), 'Your Fitness Journey Starts Here.');
      } catch (e) {
        rethrow;
      }
    });

    test('Onboarding Message - Invalid Gender', () {
      try {
        expect(getOnboardingMessage('InvalidGender'), 'Please select a gender.');
      } catch (e) {
        rethrow;
      }
    });
  });
}
