import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:testapp/helpers/errors/network_exceptions.dart';

abstract class BrandRestInterface {
  Future<Either<NetworkExceptions, dynamic>> saveData({
    required String guid,
    required String modelGuid,
    required String brand,
  });
}

class BrandRest implements BrandRestInterface {
  final Dio _dio;

  BrandRest(this._dio);

  @override
  Future<Either<NetworkExceptions, dynamic>> saveData({
    required String guid,
    required String modelGuid,
    required String brand,
  }) async {
    try {
      _dio.options.headers['requiresToken'] = true;
      final formData = FormData.fromMap({
        'brands': [
          {'name': brand}
        ],
        'manufacturer_guid': guid,
        'manufacturer_model_guid': modelGuid,
        'name': brand,
      });
      final response =
          await _dio.post('setting/manufacturer/brand', data: formData);

      final responseData = response.data['message'];
      return Right(responseData);
    } catch (e) {
      return Left(NetworkExceptions.getDioException(e));
    }
  }
}
