import 'package:firebase_auth/firebase_auth.dart';
import '../../Model/person/person_model.dart';
import '../../config/enums/enums.dart';

class AuthRepository {

  String _loginError(String code) {
    switch (code) {
      case 'person-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'person-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'network-request-failed':
        return 'No internet connection. Please check your network.';
      default:
        return 'Login failed. Please try again.';
    }
  }

  String _signUpError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'network-request-failed':
        return 'No internet connection. Please check your network.';
      default:
        return 'Sign up failed. Please try again.';
    }
  }

  Future<(PersonModel?, AuthStates)> checkLogin() async {
    try {
      final user = await FirebaseAuth.instance
          .authStateChanges()
          .first;

      if (user == null) {
        return (null, AuthStates.Unauthenticated);
      }
      PersonModel newModel = PersonModel(
        uid: user.uid,
        email: user.email!,
      );
      print(user.uid);
      return (newModel, AuthStates.Authenticated);
    } catch (e) {
      return (null, AuthStates.Error);
    }
  }
  Future<void> logOutUser() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<(PersonModel?, String?, AuthStates)> loginUser(String email, String password) async {
    try {
      final credentials = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
      if (credentials.user != null) {
        final user = PersonModel(
          uid: credentials.user!.uid,
          email: credentials.user!.email!,
        );
        return (user, 'Welcome back!', AuthStates.Authenticated);
      }
      return (null, 'No account found with these credentials.', AuthStates.Error);
    } on FirebaseAuthException catch (e) {
      return (null, _loginError(e.code), AuthStates.Error);
    } catch (e) {
      return (null, 'Something went wrong. Please try again.', AuthStates.Error);
    }
  }

  Future<(PersonModel?, String?, AuthStates)> signUpUser(String email, String password) async {
    try {
      final credentials = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = PersonModel(
        uid: credentials.user!.uid,
        email: credentials.user!.email!,
      );
      return (user, 'Account created successfully!', AuthStates.Authenticated);
    } on FirebaseAuthException catch (e) {
      return (null, _signUpError(e.code), AuthStates.Error); // ✅ clean message
    } catch (e) {
      return (null, 'Something went wrong. Please try again.', AuthStates.Error);
    }
  }

  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}