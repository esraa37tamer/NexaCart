import '../entities/app_user.dart';

abstract interface class AuthRepository {
  Future<AppUser?> restoreSession();
  Future<AppUser> signIn({required String email, required String password, required bool rememberMe});
  Future<AppUser> signInWithGoogle({required bool rememberMe});
  Future<AppUser> signInWithFacebook({required bool rememberMe});
  Future<AppUser> signUp({required String fullName, required String email, required String password});
  Future<void> signOut();
}
