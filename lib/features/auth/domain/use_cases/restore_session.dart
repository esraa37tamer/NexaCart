import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';
class RestoreSession {
  const RestoreSession(this.repository);
  final AuthRepository repository;
  Future<AppUser?> call() => repository.restoreSession();
}
