import 'package:equatable/equatable.dart';
import '../../domain/entities/app_user.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, registrationSuccess, failure }

class AuthState extends Equatable {
  const AuthState({this.status = AuthStatus.initial, this.user, this.message});
  final AuthStatus status;
  final AppUser? user;
  final String? message;
  @override
  List<Object?> get props => [status, user, message];
}
