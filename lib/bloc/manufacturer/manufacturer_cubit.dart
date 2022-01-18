import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:testapp/data/repositories/manufacturer_repository.dart';
import 'package:testapp/models/manufacturer.dart';

part 'manufacturer_state.dart';

class ManufacturerCubit extends Cubit<ManufacturerState> {
  final ManufacturerRepositoryInterface manufacturerRepository;

  ManufacturerCubit({required this.manufacturerRepository})
      : super(ManufacturerInitial());

  void fetchData() async {
    emit(ManufacturerLoadInProgress());
    final resp = await manufacturerRepository.readData();
    resp.fold(
      (error) {
        emit(ManufacturerLoadFailure());
      },
      (manufacturers) {
        emit(ManufacturerLoadSuccess(manufacturers));
      },
    );
  }
}
