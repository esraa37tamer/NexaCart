import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/restore_session.dart';
import '../../domain/use_cases/sign_in.dart';
import '../../domain/use_cases/sign_in_with_facebook.dart';
import '../../domain/use_cases/sign_in_with_google.dart';
import '../../domain/use_cases/sign_out.dart';
import '../../domain/use_cases/sign_up.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this.signInUseCase,
    this.signInWithGoogleUseCase,
    this.signInWithFacebookUseCase,
    this.signUpUseCase,
    this.signOutUseCase,
    this.restoreSessionUseCase,
  ) : super(const AuthState());

  final SignIn signInUseCase;
  final SignInWithGoogle signInWithGoogleUseCase;
  final SignInWithFacebook signInWithFacebookUseCase;
  final SignUp signUpUseCase;
  final SignOut signOutUseCase;
  final RestoreSession restoreSessionUseCase;

  Future<void> restoreSession() async {
    final user = await restoreSessionUseCase();
    emit(AuthState(
      status: user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated,
      user: user,
    ));
  }

  Future<bool> signIn(String email, String password, {required bool rememberMe}) async {
    emit(const AuthState(status: AuthStatus.loading));
    try {
      final user = await signInUseCase(email, password, rememberMe: rememberMe);
      emit(AuthState(status: AuthStatus.authenticated, user: user));
      return true;
    } catch (e) {
      emit(AuthState(status: AuthStatus.failure, message: e.toString()));
      return false;
    }
  }

  Future<bool> signInWithGoogle({required bool rememberMe}) => _social(
        () => signInWithGoogleUseCase(rememberMe: rememberMe),
      );

  Future<bool> signInWithFacebook({required bool rememberMe}) => _social(
        () => signInWithFacebookUseCase(rememberMe: rememberMe),
      );

  Future<bool> _social(Future<dynamic> Function() action) async {
    emit(const AuthState(status: AuthStatus.loading));
    try {
      final user = await action();
      emit(AuthState(status: AuthStatus.authenticated, user: user));
      return true;
    } catch (e) {
      emit(AuthState(status: AuthStatus.failure, message: e.toString()));
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    emit(const AuthState(status: AuthStatus.loading));
    try {
      final user = await signUpUseCase(name, email, password);
      emit(AuthState(
        status: AuthStatus.registrationSuccess,
        user: user,
        message: 'Account created successfully. Sign in with your new account.',
      ));
      return true;
    } catch (e) {
      emit(AuthState(status: AuthStatus.failure, message: e.toString()));
      return false;
    }
  }

  Future<void> signOut() async {
    await signOutUseCase();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
