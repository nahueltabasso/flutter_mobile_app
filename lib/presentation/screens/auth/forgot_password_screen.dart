import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:techconnect_mobile/config/shared/constans.dart';
import 'package:techconnect_mobile/config/theme/auth_background.dart';
import 'package:techconnect_mobile/presentation/blocs/auth/forgot-password/forgot_password_bloc.dart';
import 'package:techconnect_mobile/presentation/screens/auth/login_screen.dart';
import 'package:techconnect_mobile/presentation/screens/auth/reset_password_screen.dart';
import 'package:techconnect_mobile/presentation/widgets/card_container.dart';
import 'package:techconnect_mobile/presentation/widgets/custom_form_input.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static const String routeName = '/forgot-password';

  const ForgotPasswordScreen({super.key});

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
                    const SizedBox(height: 10),
                    const Text('Modificar contraseña',
                        style: TextStyle(fontSize: 32)),
                    const SizedBox(height: 15),
                    Text(CommonConstant.LEGEND_FORGOR_PASSWORD_SCREEN,
                        style: Theme.of(context).textTheme.labelLarge,
                        textAlign: TextAlign.left),
                    const SizedBox(height: 30),
                    BlocProvider(
                      create: (context) => ForgotPasswordBloc(),
                      child: _ForgotPasswordScreen(),
                    )
                    // _ForgotPasswordScreen()
                  ],
                ),
              ),
              const SizedBox(height: 50),
              TextButton(
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                        Colors.lightBlue.withOpacity(0.1)),
                    shape: MaterialStateProperty.all(const StadiumBorder())),
                child: const Text('Iniciar Sesion',
                    style: TextStyle(fontSize: 22, color: Colors.lightBlue)),
                onPressed: () => context.push(LoginScreen.routeName),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ForgotPasswordScreen extends StatelessWidget {
  const _ForgotPasswordScreen({super.key});

  void _onSubmit(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<ForgotPasswordBloc>().add(OnSubmit(context));
  }

  @override
  Widget build(BuildContext context) {

    final forgotPasswordForm = context.watch<ForgotPasswordBloc>().state;

    return Container(
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            /* Email Input */
            CustomFormInput(
              autocorrect: false,
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
              hintText: 'joe@gmail.com',
              labelText: 'Email',
              prefixIcon: Icons.email_outlined,
              errorMessage: forgotPasswordForm.email.errorMessage,
              onChanged: (value) => context.read<ForgotPasswordBloc>().add(OnChangedEmail(value)),
            ),
            const SizedBox(height: 5),

            /* Navigate to Reset Password Screen */
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.lightBlue.withOpacity(0.1)),
                      shape: MaterialStateProperty.all(const StadiumBorder()),
                      alignment: Alignment.bottomRight),
                  child: const Text(
                    'Ya tienes tu codigo de verificacion?',
                    style: TextStyle(fontSize: 14, color: Colors.lightBlue),
                  ),
                  onPressed: () => context.push(ResetPasswordScreen.routeName)),
            ),

            const SizedBox(height: 15),

            /* Send Code Button */
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              minWidth: 300.0,
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.lightBlue,
              onPressed: forgotPasswordForm.isLoading ? null : () => _onSubmit(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(!forgotPasswordForm.isLoading ? 'Enviar Codigo' : 'Espere', style: const TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
