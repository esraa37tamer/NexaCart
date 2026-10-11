import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';
class SignInWithFacebook {
  const SignInWithFacebook(this.repository);
  final AuthRepository repository;
  Future<AppUser> call({required bool rememberMe}) => repository.signInWithFacebook(rememberMe: rememberMe);
}
