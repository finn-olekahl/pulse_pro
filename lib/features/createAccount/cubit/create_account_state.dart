part of 'create_account_cubit.dart';

sealed class CreateAccountState extends Equatable {
  const CreateAccountState();

  @override
  List<Object> get props => [];
}

final class CreateAccountInitial extends CreateAccountState {}

final class CreatingAccount extends CreateAccountState {}

final class GeneratingSplit extends CreateAccountState {}

final class GeneratingWorkoutPlan extends CreateAccountState {}
