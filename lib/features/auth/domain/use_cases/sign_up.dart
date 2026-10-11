import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';
class SignUp {
  const SignUp(this.repository);
  final AuthRepository repository;
  Future<AppUser> call(String name, String email, String password) => repository.signUp(fullName: name, email: email, password: password);
}
