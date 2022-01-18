part of 'brand_form_cubit.dart';

abstract class BrandFormState extends Equatable {
  const BrandFormState();

  @override
  List<Object> get props => [];
}

class BrandFormInitial extends BrandFormState {}

class BrandFormSubmitInProgress extends BrandFormState {}

class BrandFormSubmiteSuccess extends BrandFormState {
  final String? message;

  const BrandFormSubmiteSuccess(this.message);
}

class BrandFormSubmiteFailure extends BrandFormState {}
