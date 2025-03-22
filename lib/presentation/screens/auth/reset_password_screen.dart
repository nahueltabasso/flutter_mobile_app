import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:techconnect_mobile/config/shared/constans.dart';
import 'package:techconnect_mobile/config/theme/auth_background.dart';
import 'package:techconnect_mobile/presentation/blocs/auth/forgot-password/forgot_password_bloc.dart';
import 'package:techconnect_mobile/presentation/screens/auth/login_screen.dart';
import 'package:techconnect_mobile/presentation/widgets/card_container.dart';
import 'package:techconnect_mobile/presentation/widgets/custom_form_input.dart';

class ResetPasswordScreen extends StatelessWidget {
  static const String routeName = '/reset-password';

  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
            child: Column(
          children: [
            const SizedBox(height: 250),
            CardContainer(
              child: Column(
                children: [
                  const Text('Restablecer Contraseña',
                      style: TextStyle(fontSize: 28)),
                  const SizedBox(height: 15),
                  Text(
                    CommonConstant.LEGEND_RESET_PASSWORD_SCREEN,
                    style: Theme.of(context).textTheme.labelLarge,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 30),
                  BlocProvider(
                    create: (context) => ForgotPasswordBloc(),
                    child: _ResetPasswordForm(),
                  ),
                  // _ResetPasswordForm(),
                  const SizedBox(height: 50),
                  TextButton(
                    style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(
                            Colors.lightBlue.withOpacity(0.1)),
                        shape:
                            MaterialStateProperty.all(const StadiumBorder())),
                    child: const Text(
                      'Iniciar Sesion',
                      style: TextStyle(fontSize: 22, color: Colors.lightBlue),
                    ),
                    onPressed: () => context.push(LoginScreen.routeName),
                  )
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}

class _ResetPasswordForm extends StatelessWidget {
  const _ResetPasswordForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final resetPasswordForm = context.watch<ForgotPasswordBloc>().state;

    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          /* Verification code input */
          CustomFormInput(
            autocorrect: false,
            keyboardType: TextInputType.number,
            hintText: '123456',
            labelText: 'Codigo de Verificacion',
            prefixIcon: Icons.verified,
            errorMessage: null,
            onChanged: (value) => context
                .read<ForgotPasswordBloc>()
                .add(OnChangedVerificationCode(value)),
          ),
          const SizedBox(height: 30),

          /* Password input */
          CustomFormInput(
            obscureText: true,
            keyboardType: TextInputType.text,
            hintText: '**********',
            labelText: 'Contraseña Nueva',
            prefixIcon: Icons.lock_outline,
            errorMessage: resetPasswordForm.newPassword.errorMessage,
            onChanged: (value) => context
                .read<ForgotPasswordBloc>()
                .add(OnChangedNewPassword(value)),
          ),
          const SizedBox(height: 30),

          /* Confirm password input */
          CustomFormInput(
            obscureText: true,
            keyboardType: TextInputType.text,
            hintText: '**********',
            labelText: 'Confirmar Contraseña',
            prefixIcon: Icons.lock_outline,
            errorMessage: resetPasswordForm.confirmPassword.errorMessage,
            onChanged: (value) => context
                .read<ForgotPasswordBloc>()
                .add(OnChangedConfirmPassword(value)),
          ),
          const SizedBox(height: 30),

          /* Reset Password Button */
          MaterialButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            minWidth: 300.0,
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.lightBlue,
            onPressed: resetPasswordForm.isLoading ? null : () async {
              FocusScope.of(context).unfocus();
              context.read<ForgotPasswordBloc>().add(OnResetPassword(context));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
              child: Text(!resetPasswordForm.isLoading ? 'Modificar Contraseña' : 'Espere', style: const TextStyle(color: Colors.white),),
            ),
          ),

        ],
      ),
    );
  }
}
