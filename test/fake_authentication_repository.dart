import 'package:firebase_auth/firebase_auth.dart';
import 'package:pulse_pro/repositories/authentication_repository.dart';

class FakeAuthenticationRepository extends AuthenticationRepository {
  @override
  Future<FirebaseAuthException?> signInWithEmailAndPassword(String email, String password) async {
    // Simulieren eines erfolgreichen oder fehlgeschlagenen Login basierend auf vordefinierten Bedingungen
    if (email == "test@example.com" && password == "password") {
      return null; // Keine Fehler, simuliere erfolgreichen Login
    } else {
      // Simuliere einen Fehler bei der Anmeldung
      return FirebaseAuthException(code: 'ERROR_WRONG_PASSWORD', message: 'Wrong password provided for that user.');
    }
  }

  @override
  Future<void> signOut() async {
    // Keine Aktion benötigt, da dies nur eine Simulation ist
  }

  @override
  Future<FirebaseAuthException?> signInWithGoogle() async {
    // Simuliere erfolgreiche Google-Anmeldung
    return null;
  }

  @override
  Future<FirebaseAuthException?> signInWithApple() async {
    // Simuliere erfolgreiche Apple-Anmeldung
    return null;
  }

  @override
  User? getAuthUser() {
    // Simuliere einen eingeloggten Benutzer
    return null;
  }

  @override
  Future<FirebaseAuthException?> signUpWithEmailAndPassword(String email, String password) async {
    // Simuliere erfolgreiche Registrierung
    return null;
  }
}
