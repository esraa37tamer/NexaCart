import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/app_user.dart';
import 'auth_remote_data_source.dart';

class DemoAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<AppUser?> currentUser() async => null;
  @override
  Future<AppUser> signIn(String email, String password) async {
    throw const AppException('Firebase is not configured. Add Firebase credentials before testing authentication.');
  }
  @override
  Future<AppUser> signInWithGoogle() async => throw const AppException('Google sign-in requires Firebase configuration.');
  @override
  Future<AppUser> signInWithFacebook() async => throw const AppException('Facebook sign-in requires Firebase configuration.');
  @override
  Future<AppUser> signUp(String fullName, String email, String password) async {
    throw const AppException('Firebase is not configured. Add Firebase credentials before creating accounts.');
  }
  @override
  Future<void> signOut() async {}
}
