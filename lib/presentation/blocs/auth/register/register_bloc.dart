import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:techconnect_mobile/config/shared/constans.dart';
import 'package:techconnect_mobile/models/new_user_dto.dart';
import 'package:techconnect_mobile/presentation/screens/auth/login_screen.dart';
import 'package:techconnect_mobile/presentation/widgets/auth/inputs/email_input.dart';
import 'package:techconnect_mobile/presentation/widgets/auth/inputs/password_login_input.dart';
import 'package:techconnect_mobile/presentation/widgets/auth/inputs/username_login_input.dart';
import 'package:techconnect_mobile/services/auth_service.dart';
import 'package:techconnect_mobile/services/dialog_service.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterState()) {
    on<OnChangedInputField>((event, emit) => _onChangeInputField(event, emit));
    on<OnSubmit>((event, emit) => onSubmit(event, emit));

  }

  void _onChangeInputField(OnChangedInputField event, Emitter<RegisterState> emit) {
    switch(event.field) {
      case 'username':
        final username = UsernameLoginInput.dirty(value: event.value);
        emit(state.copyWith(
          username: username,
          isValid: Formz.validate([username, state.email, state.password, state.confirmPassword]),
        ));
        break;
      
      case 'email':
        final email = EmailInput.dirty(value: event.value);
        emit(state.copyWith(
          email: email,
          isValid: Formz.validate([state.username, email, state.password, state.confirmPassword]),
          status: RegisterFormStatus.validating,
        ));
        break;

      case 'password':
        final password = PasswordLoginInput.dirty(value: event.value);
        emit(state.copyWith(
          password: password,
          isValid: Formz.validate([state.username, state.email, password, state.confirmPassword]),
          status: RegisterFormStatus.validating,
        ));
        break;

      case 'confirmPassword':
        final confirmPassword = PasswordLoginInput.dirty(value: event.value);
        emit(state.copyWith(
          confirmPassword: confirmPassword,
          isValid: Formz.validate([state.username, state.email, state.password, confirmPassword]),
          status: RegisterFormStatus.validating,
        ));
        break;

      default:
        break;
    }
  }

  Future<void> onSubmit(OnSubmit event, Emitter<RegisterState> emit) async {
    if (!state.isValid) {
      emit(state.copyWith(status: RegisterFormStatus.invalid));
      DialogService.showErrorDialogAlert(event.context, CommonConstant.RESET_PASSWORD_INVALID_FORM);
      return;
    }

    emit(state.copyWith(status: RegisterFormStatus.posting, isLoading: true));

    final newUserDto = NewUserDto(
      username: state.username.value, 
      email: state.email.value, 
      password: state.password.value, 
      confirmPassword: state.confirmPassword.value, 
      googleUser: false, 
      facebookUser: false, 
      appleUser: false, 
      firstLogin: true, 
      roles: null, 
      userLocked: false, 
      failsAttemps: 0);

    final authService = event.context.read<AuthService>();

    String? response = await authService.signUp(newUserDto);
    if (response == null) {
      emit(state.copyWith(status: RegisterFormStatus.valid, isLoading: false));
      Navigator.push(event.context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      DialogService.showSuccessDialogAlert(event.context, 'Registrado', CommonConstant.REGISTER_SUCCESS_MESSAGE, null);
      return;
    }

    // Show the error message
    emit(state.copyWith(status: RegisterFormStatus.valid, isLoading: false));
    DialogService.showErrorDialogAlert(event.context, response);
  }
}
