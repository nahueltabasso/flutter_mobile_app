part of 'forgot_password_bloc.dart';

sealed class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class OnChangedEmail extends ForgotPasswordEvent {
  final String email;

  const OnChangedEmail(this.email);

  @override
  List<Object> get props => [email];
}

class OnSubmit extends ForgotPasswordEvent {
  final BuildContext context;

  const OnSubmit(this.context);

  @override
  List<Object> get props => [context];
}

class OnChangedVerificationCode extends ForgotPasswordEvent {
  final String verificationCode;

  const OnChangedVerificationCode(this.verificationCode);

  @override
  List<Object> get props => [verificationCode];
}

class OnChangedNewPassword extends ForgotPasswordEvent {
  final String newPassword;

  const OnChangedNewPassword(this.newPassword);

  @override
  List<Object> get props => [newPassword];
}

class OnChangedConfirmPassword extends ForgotPasswordEvent {
  final String confirmPassword;

  const OnChangedConfirmPassword(this.confirmPassword);

  @override
  List<Object> get props => [confirmPassword];
}

class OnResetPassword extends ForgotPasswordEvent {
  final BuildContext context;

  const OnResetPassword(this.context);

  @override
  List<Object> get props => [context];
}