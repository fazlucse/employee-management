// presentation/cubits/profile/profile_cubit.dart
import 'package:bloc/bloc.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState.initial());
}