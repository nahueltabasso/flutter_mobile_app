import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:techconnect_mobile/config/theme/auth_background.dart';
import 'package:techconnect_mobile/presentation/blocs/auth/register/register_bloc.dart';
import 'package:techconnect_mobile/presentation/screens/auth/login_screen.dart';
import 'package:techconnect_mobile/presentation/widgets/card_container.dart';
import 'package:techconnect_mobile/presentation/widgets/custom_form_input.dart';

class RegisterScreen extends StatelessWidget {
  static const String routeName = '/register';

  const RegisterScreen({super.key});

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
                    Text('Crear Cuenta', style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 30),
                    BlocProvider(
                      create: (context) => RegisterBloc(),
                      child: _RegisterForm(),
                    ),
                    const SizedBox(height: 30),
                    TextButton(
                      style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(
                              Colors.lightBlue.withOpacity(0.1)),
                          shape:
                              MaterialStateProperty.all(const StadiumBorder())),
                      child: const Text('Ya estas registrado?', style: TextStyle(fontSize: 22, color: Colors.lightBlue)),
                      onPressed: () => context.push(LoginScreen.routeName),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final registerForm = context.watch<RegisterBloc>().state;

    return Container(
      child: Form(
        child: Column(
          children: [
            /* Username Input */
            CustomFormInput(
              autocorrect: false,
              obscureText: false,
              keyboardType: TextInputType.text,
              hintText: 'joe',
              labelText: 'Nombre de Usuario',
              prefixIcon: Icons.account_circle,
              errorMessage: registerForm.username.errorMessage,
              onChanged: (value) => context
                  .read<RegisterBloc>()
                  .add(OnChangedInputField(value, 'username')),
            ),

            const SizedBox(height: 20),

            /* Email Input */
            CustomFormInput(
              keyboardType: TextInputType.emailAddress,
              hintText: 'joe@gmail.com',
              labelText: 'Email',
              prefixIcon: Icons.alternate_email_sharp,
              errorMessage: registerForm.email.errorMessage,
              onChanged: (value) => context
                  .read<RegisterBloc>()
                  .add(OnChangedInputField(value, 'email')),
            ),

            const SizedBox(height: 20),

            /* Password Input */
            CustomFormInput(
              keyboardType: TextInputType.text,
              obscureText: true,
              hintText: '********',
              labelText: 'Contraseña',
              prefixIcon: Icons.lock,
              errorMessage: registerForm.password.errorMessage,
              onChanged: (value) => context
                  .read<RegisterBloc>()
                  .add(OnChangedInputField(value, 'password')),
            ),

            const SizedBox(height: 20),

            /* Confirm Password Input */
            CustomFormInput(
              keyboardType: TextInputType.text,
              obscureText: true,
              hintText: '********',
              labelText: 'Confirmar Contraseña',
              prefixIcon: Icons.lock,
              errorMessage: registerForm.confirmPassword.errorMessage,
              onChanged: (value) => context
                  .read<RegisterBloc>()
                  .add(OnChangedInputField(value, 'confirmPassword')),
            ),

            const SizedBox(height: 30),

            /* Register Button */
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              minWidth: 300.0,
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.lightBlue,
              onPressed: registerForm.isLoading ? null : () async {
                FocusScope.of(context).unfocus();
                context.read<RegisterBloc>().add(OnSubmit(context));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(registerForm.isLoading ? 'Espere' : 'Registrarse', style: const TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
