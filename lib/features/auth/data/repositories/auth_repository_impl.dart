import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/session_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this.remote, this.local);
  final AuthRemoteDataSource remote;
  final SessionLocalDataSource local;

  Future<AppUser> _remember(Future<AppUser> request, bool rememberMe) async {
    final user = await request;
    if (rememberMe) {
      local.save(user);
    } else {
      local.clear();
    }
    return user;
  }

  @override
  Future<AppUser?> restoreSession() async {
    final rememberedUser = local.read();
    if (rememberedUser == null) {
      // Firebase persists credentials on mobile by default. The user's explicit
      // Remember Me choice is authoritative for NexaCart, so an absent local
      // session intentionally starts the app signed out.
      await remote.signOut();
      return null;
    }

    final providerUser = await remote.currentUser();
    if (providerUser == null || providerUser.id != rememberedUser.id) {
      local.clear();
      await remote.signOut();
      return null;
    }

    // Refresh the local snapshot so updated Firebase name/email is reflected
    // the next time the app opens.
    local.save(providerUser);
    return providerUser;
  }

  @override
  Future<AppUser> signIn({required String email, required String password, required bool rememberMe}) =>
      _remember(remote.signIn(email, password), rememberMe);

  @override
  Future<AppUser> signInWithGoogle({required bool rememberMe}) =>
      _remember(remote.signInWithGoogle(), rememberMe);

  @override
  Future<AppUser> signInWithFacebook({required bool rememberMe}) =>
      _remember(remote.signInWithFacebook(), rememberMe);

  @override
  Future<AppUser> signUp({required String fullName, required String email, required String password}) async {
    final user = await remote.signUp(fullName, email, password);
    // Email/password registration is intentionally separate from login.
    // The new account exists in Firebase, then the user signs in explicitly.
    await remote.signOut();
    local.clear();
    return user;
  }

  @override
  Future<void> signOut() async {
    await remote.signOut();
    local.clear();
  }
}
