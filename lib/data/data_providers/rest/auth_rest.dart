import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../helpers/errors/network_exceptions.dart';

abstract class AuthRestInterface {
  Future<Either<NetworkExceptions, Map<String, dynamic>>> login({
    required String email,
    required String password,
  });
}

class AuthRest implements AuthRestInterface {
  final Dio _dio;

  AuthRest(this._dio);

  @override
  Future<Either<NetworkExceptions, Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    Response response;
    try {
      final formData = FormData.fromMap({
        'email': email,
        'password': password,
        'expire': 4000,
        'type': 'manual',
      });
      response = await _dio.post('a/hash-login', data: formData);

      final responseData = response.data;
      return Right(responseData);
    } catch (e) {
      return Left(NetworkExceptions.getDioException(e));
    }
  }
}
