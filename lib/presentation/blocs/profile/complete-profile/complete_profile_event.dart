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

class SaveProfile extends CompleteProfileEvent {
  final BuildContext context;

  const SaveProfile(this.context);

  @override
  List<Object> get props => [context];
}

class OnChangedInputField extends CompleteProfileEvent {

  final String value;
  final String field;

  const OnChangedInputField(this.value, this.field);

  @override
  List<Object> get props => [value, field];
}

class SetUserEmail extends CompleteProfileEvent {
  final BuildContext context;

  const SetUserEmail(this.context);

  @override
  List<Object> get props => [context];
}

class OnChangedBirthDate extends CompleteProfileEvent {
  final DateTime date;

  const OnChangedBirthDate(this.date);

  @override
  List<Object> get props => [date];
}

class SetProfilePhoto extends CompleteProfileEvent {
  final File photo;

  const SetProfilePhoto(this.photo);

  @override
  List<Object> get props => [photo];
}