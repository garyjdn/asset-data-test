import 'package:dartz/dartz.dart';
import 'package:testapp/data/data_providers/rest/brand_rest.dart';
import 'package:testapp/helpers/errors/network_exceptions.dart';

abstract class BrandRepositoryInterface {
  Future<Either<NetworkExceptions, dynamic>> saveData({
    required String guid,
    required String modelGuid,
    required String brand,
  });
}

class BrandRepository implements BrandRepositoryInterface {
  final BrandRestInterface brandRest;

  BrandRepository({required this.brandRest});

  @override
  Future<Either<NetworkExceptions, dynamic>> saveData({
    required String guid,
    required String modelGuid,
    required String brand,
  }) async {
    final resp = await brandRest.saveData(
      guid: guid,
      modelGuid: modelGuid,
      brand: brand,
    );
    return resp.fold(
      (error) => Left(error),
      (response) {
        return Right(response);
      },
    );
  }
}
