import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';
class SignInWithGoogle {
  const SignInWithGoogle(this.repository);
  final AuthRepository repository;
  Future<AppUser> call({required bool rememberMe}) => repository.signInWithGoogle(rememberMe: rememberMe);
}
