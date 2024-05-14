import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthenticationRepository {
  User? getAuthUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    if (googleAuth?.accessToken == null || googleAuth?.idToken == null) return;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signInWithApple() async {
    try {
      final appleIdCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'dev.nordify.wayawarelogin',
          redirectUri: Uri.parse(
            'https://lotspot-app.firebaseapp.com/__/auth/handler',
          ),
        ),
      );

      if (appleIdCredential.identityToken == null) return;

      final credential = OAuthProvider('apple.com').credential(
        idToken: appleIdCredential.identityToken,
        accessToken: appleIdCredential.authorizationCode,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } on SignInWithAppleAuthorizationException catch (_) {}
  }

  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();
  }

  Future<void> signInOrSignUpWithEmailAndPassword(
      String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (signUpError) {
      if (signUpError.code == 'email-already-in-use') {
        try {
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password);
        } on FirebaseAuthException catch (signInError) {
          switch (signInError.code) {
            case 'wrong-password':
              print('Wrong password provided.');
              break;
            case 'invalid-email':
              print('The email address is not valid.');
              break;
            case 'user-disabled':
              print('The user account has been disabled by an administrator.');
              break;
            case 'too-many-requests':
              print('Too many requests. Try again later.');
              break;
            default:
              print(
                  'Something went wrong during sign in: ${signInError.message}');
              break;
          }
        }
      } else {
        switch (signUpError.code) {
          case 'weak-password':
            print('The password provided is too weak.');
            break;
          default:
            print(
                'Something went wrong during sign up: ${signUpError.message}');
            break;
        }
      }
    }
  }
}
