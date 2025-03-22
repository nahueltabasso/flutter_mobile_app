import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:techconnect_mobile/config/shared/constans.dart';
import 'package:techconnect_mobile/models/password_dto.dart';
import 'package:techconnect_mobile/presentation/screens/auth/login_screen.dart';
import 'package:techconnect_mobile/presentation/screens/auth/reset_password_screen.dart';
import 'package:techconnect_mobile/presentation/widgets/auth/inputs/email_input.dart';
import 'package:techconnect_mobile/presentation/widgets/auth/inputs/password_login_input.dart';
import 'package:techconnect_mobile/services/auth_service.dart';
import 'package:techconnect_mobile/services/dialog_service.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordState()) {
    on<OnChangedEmail>((event, emit) => _onChangedEmail(event, emit));
    on<OnSubmit>((event, emit) => _onSendForgotPasswordCode(event, emit));
    on<OnChangedNewPassword>((event, emit) => _onChangedNewPassword(event, emit));
    on<OnChangedConfirmPassword>((event, emit) => _onChangedConfirmPassword(event, emit));
    on<OnChangedVerificationCode>((event, emit) => _onChangedVerificationCode(event, emit));
    on<OnResetPassword>((event, emit) => _resetPassword(event, emit));
  }


  void _onChangedEmail(OnChangedEmail event, Emitter<ForgotPasswordState> emit) {
    final email = EmailInput.dirty(value: event.email);
    emit(state.copyWith(
      email: email,
      isValid: Formz.validate([email]),
    ));
  }


  Future<void> _onSendForgotPasswordCode(OnSubmit event, Emitter<ForgotPasswordState> emit) async {
    if (!state.isValid) {
      emit(state.copyWith(forgotPasswordStatus: ForgotPasswordStatus.invalid));
      DialogService.showErrorDialogAlert(event.context, CommonConstant.FORGOT_PASSWORD_ERROR_MESSAGE);
      return;
    }

    emit(state.copyWith(forgotPasswordStatus: ForgotPasswordStatus.posting, isLoading: true));
    final authService = event.context.read<AuthService>();
    String? response = await authService.forgotPassword(state.email.value);

    if (response != null) {
      emit(state.copyWith(forgotPasswordStatus: ForgotPasswordStatus.valid, isLoading: false));
      DialogService.showErrorDialogAlert(event.context, response);
      return;
    }

    emit(state.copyWith(forgotPasswordStatus: ForgotPasswordStatus.valid, isLoading: false));
    Navigator.push(event.context, MaterialPageRoute(builder: (context) => ResetPasswordScreen()));
    DialogService.showSuccessDialogAlert(event.context, 'Codigo Enviado', CommonConstant.FORGOT_PASSWORD_SUCCESS_LEGEND, null);
  }

  void _onChangedNewPassword(OnChangedNewPassword event, Emitter<ForgotPasswordState> emit) {
    final newPassword = PasswordLoginInput.dirty(value: event.newPassword);
    emit(state.copyWith(
      newPassword: newPassword,
      isValid: Formz.validate([newPassword, state.newPassword]),
    ));
  }

  void _onChangedConfirmPassword(OnChangedConfirmPassword event, Emitter<ForgotPasswordState> emit) {
    final confirmPassword = PasswordLoginInput.dirty(value: event.confirmPassword);
    emit(state.copyWith(
      confirmPassword: confirmPassword,
      isValid: Formz.validate([confirmPassword, state.newPassword]),
    ));
  }

  void _onChangedVerificationCode(OnChangedVerificationCode event, Emitter<ForgotPasswordState> emit) {
    final verificationCode = event.verificationCode;
    emit(state.copyWith(
      code: verificationCode,
      isValid: Formz.validate([state.newPassword, state.confirmPassword])
    ));
  }

  Future<void> _resetPassword(OnResetPassword event, Emitter<ForgotPasswordState> emit) async {
    if (state.code == '') {
      emit(state.copyWith(resetPasswordStatus: ResetPasswordStatus.invalid));
      DialogService.showErrorDialogAlert(event.context, CommonConstant.FIELD_CODE_RESET_PASSWORD_ERROR);
      return;
    }
    if (!state.isValid) {
      emit(state.copyWith(resetPasswordStatus: ResetPasswordStatus.invalid));
      DialogService.showErrorDialogAlert(event.context, CommonConstant.RESET_PASSWORD_INVALID_FORM);
      return;
    }

    PasswordDTO passwordDTO = PasswordDTO(code: state.code, 
                                          newPassword: state.newPassword.value,
                                          confirmPassword: state.confirmPassword.value);

    emit(state.copyWith(resetPasswordStatus: ResetPasswordStatus.posting, isLoading: true));
      await Future.delayed(Duration(milliseconds: 1000));
    final authService = event.context.read<AuthService>();
    String? response = await authService.resetPassword(passwordDTO);
    emit(state.copyWith(resetPasswordStatus: ResetPasswordStatus.valid, isLoading: false));
    if (response == null) {
      Navigator.push(event.context, MaterialPageRoute(builder: (context) => LoginScreen()));
      DialogService.showSuccessDialogAlert(event.context, 'Contraseña Cambiada', CommonConstant.RESET_PASSWORD_SUCCESS_SCEEN, null);
    } else {
      DialogService.showErrorDialogAlert(event.context, response);
    }
  }
}
