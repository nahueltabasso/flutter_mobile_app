part of 'complete_profile_bloc.dart';

sealed class CompleteProfileEvent extends Equatable {
  const CompleteProfileEvent();

  @override
  List<Object> get props => [];
}

class StepChanged extends CompleteProfileEvent {
  final int step;

  const StepChanged(this.step);

  @override
  List<Object> get props => [step];
}

class NextStep extends CompleteProfileEvent {}

class PreviousStep extends CompleteProfileEvent {}

class SaveProfile extends CompleteProfileEvent {}
