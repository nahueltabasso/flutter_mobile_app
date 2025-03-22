part of 'register_bloc.dart';

enum RegisterFormStatus { invalid, valid, validating, posting }

class RegisterState extends Equatable {

  final RegisterFormStatus status;
  final bool isValid;
  final UsernameLoginInput username;
  final EmailInput email;
  final PasswordLoginInput password;
  final PasswordLoginInput confirmPassword;
  final bool isLoading;

  const RegisterState({
    this.status = RegisterFormStatus.invalid, 
    this.isValid = false, 
    this.username = const UsernameLoginInput.pure(), 
    this.email = const EmailInput.pure(), 
    this.password = const PasswordLoginInput.pure(), 
    this.confirmPassword = const PasswordLoginInput.pure(), 
    this.isLoading = false
  });

  RegisterState copyWith({
    RegisterFormStatus? status,
    bool? isValid,
    UsernameLoginInput? username,
    EmailInput? email,
    PasswordLoginInput? password,
    PasswordLoginInput? confirmPassword,
    bool? isLoading
  }) {
    return RegisterState(
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading
    );
  }
  
  @override
  List<Object> get props => [ status, username, email, password, confirmPassword, isValid, isLoading ];
}

