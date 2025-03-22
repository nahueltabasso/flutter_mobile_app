part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class OnChangedInputField extends RegisterEvent {

  final String value;
  final String field;

  const OnChangedInputField(this.value, this.field);

  @override
  List<Object> get props => [value, field];
}


class OnSubmit extends RegisterEvent {
  final BuildContext context;

  const OnSubmit(this.context);

  @override
  List<Object> get props => [context];
}