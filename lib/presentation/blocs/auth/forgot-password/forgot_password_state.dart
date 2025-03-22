part of 'forgot_password_bloc.dart';


enum ForgotPasswordStatus { invalid, valid, posting }
enum ResetPasswordStatus { invalid, valid, posting }

class ForgotPasswordState extends Equatable {

  final ForgotPasswordStatus forgotPasswordStatus;
  final ResetPasswordStatus resetPasswordStatus;
  final EmailInput email;
  final PasswordLoginInput newPassword;
  final PasswordLoginInput confirmPassword;
  final String code;
  final bool isLoading;
  final bool isValid;

  const ForgotPasswordState({
    this.forgotPasswordStatus = ForgotPasswordStatus.invalid, 
    this.resetPasswordStatus = ResetPasswordStatus.invalid  , 
    this.email = const EmailInput.pure(), 
    this.newPassword = const PasswordLoginInput.pure(),
    this.confirmPassword = const PasswordLoginInput.pure(),
    this.code = '',
    this.isLoading = false,
    this.isValid = false
});


  ForgotPasswordState copyWith({
    ForgotPasswordStatus? forgotPasswordStatus,
    ResetPasswordStatus? resetPasswordStatus,
    EmailInput? email,
    PasswordLoginInput? newPassword,
    PasswordLoginInput? confirmPassword,
    String? code,
    bool? isLoading,
    bool? isValid
  }) {
    return ForgotPasswordState(
      forgotPasswordStatus: forgotPasswordStatus ?? this.forgotPasswordStatus,
      resetPasswordStatus: resetPasswordStatus ?? this.resetPasswordStatus,
      email: email ?? this.email,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      code: code ?? this.code,
      isLoading: isLoading ?? this.isLoading,
      isValid: isValid ?? this.isValid
    );
  }

  @override
  List<Object> get props => [forgotPasswordStatus, resetPasswordStatus, email, newPassword, confirmPassword, code, isLoading, isValid];
}

