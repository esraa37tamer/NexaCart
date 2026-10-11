import '../../domain/entities/app_user.dart';
abstract interface class AuthRemoteDataSource {
  Future<AppUser?> currentUser();
  Future<AppUser> signIn(String email, String password);
  Future<AppUser> signInWithGoogle();
  Future<AppUser> signInWithFacebook();
  Future<AppUser> signUp(String fullName, String email, String password);
  Future<void> signOut();
}
