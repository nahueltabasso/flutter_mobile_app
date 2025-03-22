import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:techconnect_mobile/presentation/screens/auth/login_screen.dart';
import 'package:techconnect_mobile/presentation/screens/home_screen.dart';
import 'package:techconnect_mobile/services/auth_service.dart';

class CheckAuthScreen extends StatelessWidget {

  static const String routeName = '/check-auth';

  const CheckAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: authService.isAuthenticated(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) 
              return Text('Espere');
            
            Future.microtask(() {
              if (snapshot.data == '') {
                context.push(LoginScreen.routeName);
                return Container();
              }
              if (snapshot.data != '') {
                context.push(HomeScreen.routeName);
                return Container();
              }
            });            
            return Container();
          }
        )
      ),
    );
  }
}