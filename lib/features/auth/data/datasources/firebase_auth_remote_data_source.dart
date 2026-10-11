import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/config/firebase_runtime_config.dart';
import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/app_user.dart';
import 'auth_remote_data_source.dart';

class FirebaseAuthRemoteDataSource implements AuthRemoteDataSource {
  FirebaseAuthRemoteDataSource(this.auth);
  final FirebaseAuth auth;
  bool _googleInitialized = false;

  AppUser _map(User user, {String? fallbackEmail, String? fallbackName}) => AppUser(
        id: user.uid,
        email: user.email ?? fallbackEmail ?? '',
        fullName: user.displayName ?? fallbackName ?? 'NexaCart User',
      );

  @override
  Future<AppUser?> currentUser() async {
    final user = auth.currentUser;
    if (user == null) return null;
    try {
      await user.reload();
    } on FirebaseAuthException {
      return null;
    }
    final refreshed = auth.currentUser;
    return refreshed == null ? null : _map(refreshed);
  }

  @override
  Future<AppUser> signIn(String email, String password) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(email: email, password: password);
      return _map(credential.user!, fallbackEmail: email);
    } on FirebaseAuthException catch (e) {
      throw AppException(e.message ?? 'Unable to sign in');
    }
  }

  @override
  Future<AppUser> signUp(String fullName, String email, String password) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      await credential.user?.updateDisplayName(fullName);
      await credential.user?.reload();
      final user = auth.currentUser ?? credential.user!;
      return _map(user, fallbackEmail: email, fallbackName: fullName);
    } on FirebaseAuthException catch (e) {
      throw AppException(e.message ?? 'Unable to create account');
    }
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    try {
      if (!_googleInitialized) {
        await GoogleSignIn.instance.initialize(
          clientId: FirebaseRuntimeConfig.googleIosClientId.isEmpty ? null : FirebaseRuntimeConfig.googleIosClientId,
          serverClientId: FirebaseRuntimeConfig.googleServerClientId.isEmpty
              ? null
              : FirebaseRuntimeConfig.googleServerClientId,
        );
        _googleInitialized = true;
      }
      final googleUser = await GoogleSignIn.instance.authenticate();
      final googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);
      final result = await auth.signInWithCredential(credential);
      return _map(result.user!);
    } on GoogleSignInException catch (e) {
      throw AppException(e.description ?? 'Google sign-in was cancelled or failed.');
    } on FirebaseAuthException catch (e) {
      throw AppException(e.message ?? 'Google sign-in failed.');
    }
  }

  @override
  Future<AppUser> signInWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status != LoginStatus.success || result.accessToken == null) {
        throw AppException(result.message ?? 'Facebook sign-in was cancelled.');
      }
      final credential = FacebookAuthProvider.credential(result.accessToken!.tokenString);
      final authResult = await auth.signInWithCredential(credential);
      return _map(authResult.user!);
    } on FirebaseAuthException catch (e) {
      throw AppException(e.message ?? 'Facebook sign-in failed.');
    }
  }

  @override
  Future<void> signOut() async {
    await auth.signOut();
    try { await GoogleSignIn.instance.signOut(); } catch (_) {}
    try { await FacebookAuth.instance.logOut(); } catch (_) {}
  }
}
