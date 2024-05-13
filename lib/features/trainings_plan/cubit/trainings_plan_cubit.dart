import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'trainings_plan_state.dart';

class TrainingsPlanCubit extends Cubit<TrainingsPlanState> {
  TrainingsPlanCubit() : super(TrainingsPlanInitial());
}
