import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io' show Platform;
import '../utils/app_strings.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception(AppStrings.loginCanceled);
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return _auth.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithApple() async {
    if (!Platform.isIOS && !Platform.isMacOS) {
      throw Exception(AppStrings.appleSignInNotAvailable);
    }

    try {
      final AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final credential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      return _auth.signInWithCredential(credential);
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw Exception(AppStrings.loginCanceled);
      } else if (e.code == AuthorizationErrorCode.unknown) {
        throw Exception(AppStrings.appleSignInNotAvailable);
      }
      rethrow;
    }
  }

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Actualizar el perfil del usuario con el nombre
      await userCredential.user?.updateDisplayName(fullName);
      await userCredential.user?.reload();

      // Guardar datos del usuario en Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'fullName': fullName,
        'email': email,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception(AppStrings.weakPassword);
      } else if (e.code == 'email-already-in-use') {
        throw Exception(AppStrings.emailAlreadyInUse);
      } else if (e.code == 'invalid-email') {
        throw Exception(AppStrings.invalidEmail);
      } else {
        throw Exception('${AppStrings.registerError}: ${e.message}');
      }
    } catch (e) {
      throw Exception('${AppStrings.unexpectedError}: $e');
    }
  }

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception(AppStrings.userNotFound);
      } else if (e.code == 'wrong-password') {
        throw Exception(AppStrings.wrongPassword);
      } else if (e.code == 'user-disabled') {
        throw Exception(AppStrings.userDisabled);
      } else if (e.code == 'invalid-email') {
        throw Exception(AppStrings.invalidEmail);
      } else {
        throw Exception('${AppStrings.loginError}: ${e.message}');
      }
    } catch (e) {
      throw Exception('${AppStrings.unexpectedError}: $e');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception(AppStrings.passwordResetError);
      } else if (e.code == 'invalid-email') {
        throw Exception(AppStrings.invalidEmail);
      } else {
        throw Exception('${AppStrings.forgotPasswordError}${e.message}');
      }
    } catch (e) {
      throw Exception('${AppStrings.unexpectedError}: $e');
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
