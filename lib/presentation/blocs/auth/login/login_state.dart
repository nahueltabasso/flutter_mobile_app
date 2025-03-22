part of 'login_bloc.dart';

enum LoginFormStatus { invalid, valid, validating, posting }

class LoginState extends Equatable {

  final LoginFormStatus status;
  final bool isValid;
  final UsernameLoginInput username;
  final PasswordLoginInput password;
  final bool isLoading;

  const LoginState({
    this.status = LoginFormStatus.invalid, 
    this.isValid = false, 
    this.username = const UsernameLoginInput.pure(), 
    this.password = const PasswordLoginInput.pure(),
    this.isLoading = false
  });

  LoginState copyWith({
    LoginFormStatus? status,
    bool? isValid,
    UsernameLoginInput? username,
    PasswordLoginInput? password,
    bool? isLoading
  }) {
    return LoginState(
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      username: username ?? this.username,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading
    );
  }
  
  @override
  List<Object> get props => [status, username, password, isValid, isLoading];
}
