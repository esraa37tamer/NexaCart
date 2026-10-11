import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';
class SignIn {
  const SignIn(this.repository);
  final AuthRepository repository;
  Future<AppUser> call(String email, String password, {required bool rememberMe}) =>
      repository.signIn(email: email, password: password, rememberMe: rememberMe);
}
