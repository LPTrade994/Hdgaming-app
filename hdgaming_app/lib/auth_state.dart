part of 'auth_cubit.dart';

enum AuthStatus { unknown, loading, authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? token;

  const AuthState._({required this.status, this.token});

  const AuthState.unknown() : this._(status: AuthStatus.unknown);
  const AuthState.loading() : this._(status: AuthStatus.loading);
  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);
  const AuthState.authenticated(String token)
      : this._(status: AuthStatus.authenticated, token: token);

  @override
  List<Object?> get props => [status, token];
}
