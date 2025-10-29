// presentation/cubits/projects/projects_cubit.dart
import 'package:bloc/bloc.dart';
part 'projects_state.dart';

class ProjectsCubit extends Cubit<ProjectsState> {
  ProjectsCubit() : super(ProjectsState.initial());
}