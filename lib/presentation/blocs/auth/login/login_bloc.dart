import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:techconnect_mobile/config/shared/constans.dart';
import 'package:techconnect_mobile/presentation/screens/home_screen.dart';
import 'package:techconnect_mobile/presentation/screens/profile/complete-profile/complete_profile_screen.dart';
import 'package:techconnect_mobile/presentation/widgets/auth/inputs/password_login_input.dart';
import 'package:techconnect_mobile/presentation/widgets/auth/inputs/username_login_input.dart';
import 'package:techconnect_mobile/services/auth_service.dart';
import 'package:techconnect_mobile/services/dialog_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState()) {
    on<UsernameChanged>((event, emit) => _onChangedUsername(event, emit)); 
    on<PasswordChanged>((event, emit) => onChangedPasword(event, emit));
    on<OnSubmit>((event, emit) => onSubmit(event, emit));
  }

  void _onChangedUsername(UsernameChanged event, Emitter<LoginState> emit) {
    final username = UsernameLoginInput.dirty(value: event.username);
    emit(state.copyWith(
      username: username,
      isValid: Formz.validate([username, state.password]),
      status: LoginFormStatus.validating
    ));
  }

  void onChangedPasword(PasswordChanged event, Emitter<LoginState> emit) {
    final password = PasswordLoginInput.dirty(value: event.password);
    emit(state.copyWith(
      password: password,
      isValid: Formz.validate([state.username, password]),
      status: LoginFormStatus.validating
    ));
  }

  Future<void> onSubmit(OnSubmit event, Emitter<LoginState> emit) async {
    if (!state.isValid) {
      print("Error: Form is not valid");
      emit(state.copyWith(status: LoginFormStatus.invalid));
      DialogService.showErrorDialogAlert(event.context, CommonConstant.LOGIN_ERROR_MESSAGE);
      return;
    }
    emit(state.copyWith(
      status: LoginFormStatus.posting,
      isLoading: true
    ));

    await Future.delayed(const Duration(seconds: 1));

    // Instance of authservice
    final authService = event.context.read<AuthService>();

    String? response = await authService.signIn(state.username.value, state.password.value);
    if (response != null) {
      emit(state.copyWith(
        status: LoginFormStatus.valid,
        isLoading: false
      ));
      DialogService.showErrorDialogAlert(event.context, response);
      return;
    }
    emit(state.copyWith(
      status: LoginFormStatus.valid,
      isLoading: false
    ));

    Navigator.push(event.context, MaterialPageRoute(builder: (context) => CompleteProfileScreen()));
    DialogService.showSuccessDialogAlert(event.context, 'Bienvenido', CommonConstant.LOGIN_SUCCESS_MESSAGE, null);
  }

}
