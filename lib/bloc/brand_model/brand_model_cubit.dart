import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:testapp/data/repositories/brand_repository.dart';

part 'brand_model_state.dart';

class BrandModelCubit extends Cubit<BrandModelState> {
  final BrandRepositoryInterface brandRepository;

  BrandModelCubit({required this.brandRepository}) : super(BrandModelInitial());
}
