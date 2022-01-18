import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/repositories/auth_repository.dart';
import '../../helpers/errors/network_exceptions.dart';
import '../../models/auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthRepositoryInterface authRepository;

  AuthCubit({required this.authRepository}) : super(NotAuthenticated());

  void continueSession() async {
    final resp = await authRepository.continueSession();

    resp.fold(
      (_) => emit(NotAuthenticated()),
      (auth) => emit(Authenticated(authData: auth)),
    );
  }

  void login({
    required String email,
    required String password,
  }) async {
    emit(Authenticating());

    final resp = await authRepository.login(
      email: email,
      password: password,
    );

    resp.fold((error) {
      emit(AuthenticationFailure(error: error));
      emit(NotAuthenticated());
    }, (auth) {
      emit(Authenticated(authData: auth));
    });
  }

  void logout() async {
    final response = await authRepository.logout();

    response.fold(
      (error) {
        if (state is Authenticated) {
          Authenticated currentAuthState = state as Authenticated;
          emit(AuthUnexpectedError(error));
          emit(currentAuthState);
        }
      },
      (_) {
        emit(NotAuthenticated());
      },
    );
  }
}
