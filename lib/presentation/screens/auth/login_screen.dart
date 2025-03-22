import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:techconnect_mobile/config/theme/auth_background.dart';
import 'package:techconnect_mobile/presentation/blocs/auth/login/login_bloc.dart';
import 'package:techconnect_mobile/presentation/screens/auth/forgot_password_screen.dart';
import 'package:techconnect_mobile/presentation/screens/auth/register_screen.dart';
import 'package:techconnect_mobile/presentation/widgets/card_container.dart';
import 'package:techconnect_mobile/presentation/widgets/custom_form_input.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 250,
          ),
          CardContainer(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text('Bienvenido', style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 15),
                Text('Accede a tu cuenta', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 30),
                BlocProvider(
                  create: (context) => LoginBloc(),
                  child: _LoginForm(),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          TextButton(
            style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(
                    Colors.lightBlue.withOpacity(0.1)),
                shape: MaterialStateProperty.all(const StadiumBorder())),
            child: const Text('Crear una nueva cuenta', style: TextStyle(fontSize: 22, color: Colors.lightBlue)),
            onPressed: () => context.push(RegisterScreen.routeName),
          )
        ],
      ),
    )));
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    super.key,
  });

  void _login(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<LoginBloc>().add(OnSubmit(context));
  }

  @override
  Widget build(BuildContext context) {
    final loginForm = context.watch<LoginBloc>().state;

    return Container(
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            /* Username Input Field */
            CustomFormInput(
              labelText: 'Nombre de usuario',
              hintText: 'joe',
              prefixIcon: Icons.alternate_email_sharp,
              autocorrect: false,
              obscureText: false,
              errorMessage: loginForm.username.errorMessage,
              onChanged: (value) => context.read<LoginBloc>().add(UsernameChanged(value)),
            ),
            const SizedBox(height: 30),

            /* Password Input Field */
            CustomFormInput(
              labelText: 'Contraseña',
              hintText: '********',
              prefixIcon: Icons.lock_outline,
              autocorrect: false,
              obscureText: true,
              errorMessage: loginForm.password.errorMessage,
              onChanged: (value) => context.read<LoginBloc>().add(PasswordChanged(value)),
            ),
            const SizedBox(height: 15),

            /* Navigate to Forgot Password Screen */
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.lightBlue.withOpacity(0.1)),
                      shape: MaterialStateProperty.all(const StadiumBorder()),
                      alignment: Alignment.bottomRight),
                  child: const Text(
                    'Olvidaste tu contraseña?',
                    style: TextStyle(fontSize: 14, color: Colors.lightBlue),
                  ),
                  onPressed: () => context.push(ForgotPasswordScreen.routeName)),
            ),
            const SizedBox(
              height: 10,
            ),

            /* Login Button */
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              minWidth: 300.0,
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.lightBlue,
              onPressed: loginForm.isLoading ? null : () => _login(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(loginForm.isLoading ? 'Espere' : 'Login', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 50)
          ],
        ),
      ),
    );
  }
}
