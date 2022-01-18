import 'package:dartz/dartz.dart';

import '../../helpers/errors/network_exceptions.dart';
import '../../models/manufacturer.dart';
import '../data_providers/rest/manufacturer_rest.dart';

abstract class ManufacturerRepositoryInterface {
  Future<Either<NetworkExceptions, List<Manufacturer>>> readData();
}

class ManufacturerRepository implements ManufacturerRepositoryInterface {
  final ManufacturerRestInterface manufacturerRest;

  ManufacturerRepository({required this.manufacturerRest});

  @override
  Future<Either<NetworkExceptions, List<Manufacturer>>> readData() async {
    final resp = await manufacturerRest.readData();
    return resp.fold(
      (error) => Left(error),
      (response) {
        final List<Manufacturer> manufacturers = response
            .map<Manufacturer>((man) => Manufacturer.fromMap(man))
            .toList();
        return Right(manufacturers);
      },
    );
  }
}
