import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:testapp/helpers/errors/network_exceptions.dart';

abstract class ManufacturerRestInterface {
  Future<Either<NetworkExceptions, dynamic>> readData();
}

class ManufacturerRest implements ManufacturerRestInterface {
  final Dio _dio;

  ManufacturerRest(this._dio);

  @override
  Future<Either<NetworkExceptions, dynamic>> readData() async {
    try {
      _dio.options.headers['requiresToken'] = true;
      final response = await _dio.get(
          'setting/manufacturer/filter?page=1&limit=10&orderDir=asc&orderCol=name');

      final responseData = response.data['data'];
      return Right(responseData);
    } catch (e) {
      return Left(NetworkExceptions.getDioException(e));
    }
  }
}
