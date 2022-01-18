part of 'manufacturer_cubit.dart';

abstract class ManufacturerState extends Equatable {
  const ManufacturerState();

  @override
  List<Object> get props => [];
}

class ManufacturerInitial extends ManufacturerState {}

class ManufacturerLoadInProgress extends ManufacturerState {}

class ManufacturerLoadSuccess extends ManufacturerState {
  final List<Manufacturer> manufacturers;

  const ManufacturerLoadSuccess(this.manufacturers);
}

class ManufacturerLoadFailure extends ManufacturerState {
  final String? message;

  const ManufacturerLoadFailure({this.message});
}
