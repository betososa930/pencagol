import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'dart:io' show Platform;

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  FirebaseAuth get _auth => FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Inicio de sesión cancelado');
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
      throw Exception('Apple Sign-In solo está disponible en iOS y macOS');
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
        throw Exception('Inicio de sesión cancelado');
      } else if (e.code == AuthorizationErrorCode.unknown) {
        throw Exception('Error desconocido al iniciar sesión con Apple');
      }
      rethrow;
    }
  }

  Future<UserCredential> signInWithMeta() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final AccessToken? accessToken = result.accessToken;

        if (accessToken == null) {
          throw Exception('No se pudo obtener el token de acceso');
        }

        final credential = FacebookAuthProvider.credential(
          accessToken.tokenString,
        );

        return _auth.signInWithCredential(credential);
      } else if (result.status == LoginStatus.cancelled) {
        throw Exception('Inicio de sesión cancelado');
      } else {
        throw Exception('Error al iniciar sesión con Meta: ${result.message}');
      }
    } catch (e) {
      throw Exception('Error al iniciar sesión con Meta: $e');
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await FacebookAuth.instance.logOut();
    await _auth.signOut();
  }
}
