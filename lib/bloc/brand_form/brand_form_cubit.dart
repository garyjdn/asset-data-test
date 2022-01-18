import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:testapp/data/repositories/brand_repository.dart';

part 'brand_form_state.dart';

class BrandFormCubit extends Cubit<BrandFormState> {
  final BrandRepositoryInterface brandRepository;

  BrandFormCubit({required this.brandRepository}) : super(BrandFormInitial());

  Future<void> saveData({
    required String guid,
    required String modelGuid,
    required String brand,
  }) async {
    emit(BrandFormSubmitInProgress());
    final resp = await brandRepository.saveData(
      guid: guid,
      modelGuid: modelGuid,
      brand: brand,
    );
    resp.fold(
      (error) {
        emit(BrandFormSubmiteFailure());
      },
      (resp) {
        emit(BrandFormSubmiteSuccess(resp));
      },
    );
  }
}
