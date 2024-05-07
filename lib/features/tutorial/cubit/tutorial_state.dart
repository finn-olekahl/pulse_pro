part of 'tutorial_cubit.dart';

sealed class TutorialState extends Equatable {
  const TutorialState();

  @override
  List<Object> get props => [];
}

final class TutorialInitial extends TutorialState {}
