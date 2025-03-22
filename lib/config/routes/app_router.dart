import 'package:go_router/go_router.dart';
import 'package:techconnect_mobile/presentation/screens/auth/check_auth_screen.dart';
import 'package:techconnect_mobile/presentation/screens/auth/forgot_password_screen.dart';
import 'package:techconnect_mobile/presentation/screens/auth/login_screen.dart';
import 'package:techconnect_mobile/presentation/screens/auth/register_screen.dart';
import 'package:techconnect_mobile/presentation/screens/auth/reset_password_screen.dart';
import 'package:techconnect_mobile/presentation/screens/home_screen.dart';

final appRouter = GoRouter(
  initialLocation: CheckAuthScreen.routeName,
  routes: [
    GoRoute(path: LoginScreen.routeName, builder: (context, state) => const LoginScreen()),
    GoRoute(path: RegisterScreen.routeName, builder: (context, state) => const RegisterScreen()),
    GoRoute(path: ForgotPasswordScreen.routeName, builder: (context, state) => const ForgotPasswordScreen()), 
    GoRoute(path: ResetPasswordScreen.routeName, builder: (context, state) => const ResetPasswordScreen()),
    GoRoute(path: CheckAuthScreen.routeName, builder: (context, state) => const CheckAuthScreen()),
    GoRoute(path: HomeScreen.routeName, builder: (context, state) => const HomeScreen()),
  ]
);