import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'profile_form_state.dart';

class ProfileFormCubit extends Cubit<ProfileFormState> {
  ProfileFormCubit() : super(ProfileFormInitial());
}
