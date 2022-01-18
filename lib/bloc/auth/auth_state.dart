part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class NotAuthenticated extends AuthState {}

class Authenticating extends AuthState {}

class Authenticated extends AuthState {
  final Auth authData;

  Authenticated({required this.authData});
}

class AuthenticationFailure extends AuthState {
  final NetworkExceptions error;

  AuthenticationFailure({required this.error});
}

class AuthUnexpectedError extends AuthState {
  final NetworkExceptions networkExceptions;

  AuthUnexpectedError(this.networkExceptions);
}
