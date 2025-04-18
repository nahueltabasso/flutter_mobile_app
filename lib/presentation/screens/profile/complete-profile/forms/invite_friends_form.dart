import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:techconnect_mobile/models/user_profile_dto.dart';
import 'package:techconnect_mobile/presentation/screens/home_screen.dart';
import 'package:techconnect_mobile/presentation/widgets/invite_friend_card.dart';
import 'package:techconnect_mobile/services/dialog_service.dart';
import 'package:techconnect_mobile/services/user_profile_service.dart';

class InviteFriendsForm extends StatelessWidget {
  static const String routeName = '/invite-friends';

  final bool? showWelcomeDialog;

  const InviteFriendsForm({super.key, this.showWelcomeDialog = false});

  Future<List<UserProfileDto>> _loadNearFriends(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    final userProfileService = context.read<UserProfileService>();
    final userProfileId = userProfileService.loggedUserProfile?.id;

    if (userProfileId == null) {
      throw Exception("User profile ID is null");
    }

    final dtoList = await userProfileService.getPossibleFriends(userProfileId);
    return dtoList ?? [];
  }

  void _showWelcomeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bienvenido'),
        content: const Text('Aquí puedes invitar a tus amigos sugeridos.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showHomeDialog(BuildContext context) {
    context.push(HomeScreen.routeName);
    DialogService.showSuccessDialogAlert(context, 'Bienvenido', 'Bienvenido a TechConnect', null);
  }

  @override
  Widget build(BuildContext context) {
    // if (showWelcomeDialog == true) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     _showWelcomeDialog(context);
    //   });
    // }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sugerencia de amigos'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<UserProfileDto>>(
        future: _loadNearFriends(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No hay amigos sugeridos disponibles.'),
            );
          }

          final userProfileList = snapshot.data!;

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child:  ListView.builder(
                    itemCount: userProfileList.length,
                    itemBuilder: (context, index) =>
                        InviteFriendCard(userProfileDto: userProfileList[index]),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        // onPressed: () => HomeScreen.routeName,
                        onPressed: () => _showHomeDialog(context),
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.grey),
                        ),
                        child: const Text(
                          'Omitir',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      ElevatedButton(
                        // onPressed: () => HomeScreen.routeName,
                        onPressed: () => _showHomeDialog(context),
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.lightBlue),
                        ),
                        child: const Text(
                          'Finalizar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}