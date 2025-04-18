import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:techconnect_mobile/config/routes/app_router.dart';
import 'package:techconnect_mobile/config/theme/app_theme.dart';
import 'package:techconnect_mobile/presentation/blocs/profile/add-location/add_location_bloc.dart';
import 'package:techconnect_mobile/presentation/blocs/profile/complete-profile/complete_profile_bloc.dart';
import 'package:techconnect_mobile/presentation/blocs/profile/invite-friends/invite_friends_bloc.dart';
import 'package:techconnect_mobile/services/auth_service.dart';
import 'package:techconnect_mobile/services/user_profile_service.dart';

void main() => runApp(AppState());


class AppState extends StatelessWidget {
    @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => UserProfileService()),
        BlocProvider(create: (context) => CompleteProfileBloc()),
        BlocProvider(create: (context) => AddLocationBloc()),
        BlocProvider(create: (context) => InviteFriendsBloc(context.read<UserProfileService>())),
      ],
      child: const MyApp(),
    );
  }

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
      routerConfig: appRouter,
    );
  }
}