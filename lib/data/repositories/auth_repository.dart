import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:testapp/data/data_providers/shared_preferences/shared_preferences_wrapper.dart';

import '../../helpers/errors/network_exceptions.dart';
import '../../models/auth.dart';
import '../data_providers/rest/auth_rest.dart';

abstract class AuthRepositoryInterface {
  Future<Either<bool, Auth>> continueSession();
  Future<Either<NetworkExceptions, Auth>> login({
    required String email,
    required String password,
  });
  Future<Either<NetworkExceptions, Map<String, dynamic>?>> logout();
}

class AuthRepository implements AuthRepositoryInterface {
  final AuthRestInterface authRest;
  final SharedPreferencesWrapper authSharedPref;

  AuthRepository({
    required this.authRest,
    required this.authSharedPref,
  });

  @override
  Future<Either<bool, Auth>> continueSession() async {
    Auth auth;
    if (await authSharedPref.hasCache()) {
      final cachedData = await authSharedPref.readData();
      if (cachedData != null) {
        auth = Auth.fromMap(cachedData);
        return Right(auth);
      }
    }
    return const Left(true);
  }

  @override
  Future<Either<NetworkExceptions, Auth>> login({
    required String email,
    required String password,
  }) async {
    Auth auth;

    if (await authSharedPref.hasCache()) {
      final cachedData = await authSharedPref.readData();
      if (cachedData != null) {
        auth = Auth.fromMap(cachedData);
        return Right(auth);
      }
    }

    final response = await authRest.login(email: email, password: password);
    return response.fold((error) async {
      await authSharedPref.removeData();
      return Left(error);
    }, (response) async {
      auth = Auth.fromJson(response);
      await authSharedPref.createData(data: auth);
      return Right(auth);
    });
  }

  @override
  Future<Either<NetworkExceptions, Map<String, dynamic>?>> logout() async {
    await authSharedPref.removeData();
    return const Right(null);
  }
}
