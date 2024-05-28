// Datei: onboarding_view_test.dart

// Funktion zur Namensvalidierung
import 'package:flutter_test/flutter_test.dart';

bool isValidName(String name) {
  return name.isNotEmpty && name.length > 2;
}

// Funktion zur Geschlechtsauswahl
bool isGenderSelected(String gender) {
  const validGenders = ['Male', 'Female', 'Other'];
  return validGenders.contains(gender);
}

// Funktion zur Erstellung der Onboarding-Nachricht
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
      print('Testing valid name...');
      try {
        expect(isValidName('John Doe'), isTrue);
        print('Valid name test passed');
      } catch (e) {
        print('Valid name test failed: $e');
        rethrow;
      }
    });

    test('Empty Name', () {
      print('Testing empty name...');
      try {
        expect(isValidName(''), isFalse);
        print('Empty name test passed');
      } catch (e) {
        print('Empty name test failed: $e');
        rethrow;
      }
    });

    test('Short Name', () {
      print('Testing short name...');
      try {
        expect(isValidName('Jo'), isFalse);
        print('Short name test passed');
      } catch (e) {
        print('Short name test failed: $e');
        rethrow;
      }
    });

    test('Valid Gender Selection - Male', () {
      print('Testing valid gender selection (Male)...');
      try {
        expect(isGenderSelected('Male'), isTrue);
        print('Valid gender selection (Male) test passed');
      } catch (e) {
        print('Valid gender selection (Male) test failed: $e');
        rethrow;
      }
    });

    test('Valid Gender Selection - Female', () {
      print('Testing valid gender selection (Female)...');
      try {
        expect(isGenderSelected('Female'), isTrue);
        print('Valid gender selection (Female) test passed');
      } catch (e) {
        print('Valid gender selection (Female) test failed: $e');
        rethrow;
      }
    });

    test('Invalid Gender Selection', () {
      print('Testing invalid gender selection...');
      try {
        expect(isGenderSelected('InvalidGender'), isFalse);
        print('Invalid gender selection test passed');
      } catch (e) {
        print('Invalid gender selection test failed: $e');
        rethrow;
      }
    });

    test('Onboarding Message - Valid Gender', () {
      print('Testing onboarding message for valid gender...');
      try {
        expect(getOnboardingMessage('Male'), 'Your Fitness Journey Starts Here.');
        print('Onboarding message for valid gender test passed');
      } catch (e) {
        print('Onboarding message for valid gender test failed: $e');
        rethrow;
      }
    });

    test('Onboarding Message - Invalid Gender', () {
      print('Testing onboarding message for invalid gender...');
      try {
        expect(getOnboardingMessage('InvalidGender'), 'Please select a gender.');
        print('Onboarding message for invalid gender test passed');
      } catch (e) {
        print('Onboarding message for invalid gender test failed: $e');
        rethrow;
      }
    });
  });
}
