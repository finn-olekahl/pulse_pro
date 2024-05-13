import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pulse_pro/bloc/app_state_bloc.dart';

part 'trainings_plan_state.dart';

class TrainingsPlanCubit extends Cubit<TrainingsPlanState> {
  TrainingsPlanCubit({required this.appStateBloc}) : super(TrainingsPlanInitial()) {
    _subscription = appStateBloc.stream.listen((state) {
      if (state is! AppStateLoggedIn) return;
    });
  }

  final AppStateBloc appStateBloc;
  late final StreamSubscription _subscription;

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
