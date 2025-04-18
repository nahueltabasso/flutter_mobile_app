import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techconnect_mobile/models/user_profile_dto.dart';
import 'package:techconnect_mobile/presentation/blocs/profile/invite-friends/invite_friends_bloc.dart';
import 'package:techconnect_mobile/presentation/widgets/circle_avatar_photo.dart';
import 'package:techconnect_mobile/presentation/widgets/username_text.dart';
import 'package:techconnect_mobile/services/dialog_service.dart';
import 'package:techconnect_mobile/services/user_profile_service.dart';

// ignore: must_be_immutable
class InviteFriendCard extends StatelessWidget {

  final UserProfileDto userProfileDto;
  // bool? flagButton = true;
  final ValueNotifier<bool> flagButtonNotifier = ValueNotifier<bool>(true);

  InviteFriendCard({super.key, required this.userProfileDto}) {
    // flagButton = true;
  }

  void _inviteFriend(BuildContext context) {
    // Implement the logic to invite a friend
    print("Inviting friend: ${userProfileDto.firstName}");
    final userProfileService = context.read<UserProfileService>();
    final fromUser = userProfileService.loggedUserProfile;
    context.read<InviteFriendsBloc>().add(InviteFriend(fromUser!, userProfileDto));
    flagButtonNotifier.value = false;
    final msg = 'La solicitud de amistad a ${userProfileDto.firstName} se ha enviado correctamente';
    DialogService.showSuccessDialogAlert(context, 'Solicitud enviada!', msg, null);

  }

  String truncateWithEllipsis(int cutoff, String text) {
    return (text.length <= cutoff) ? text : '${text.substring(0, cutoff)}...';
  }

  @override
  Widget build(BuildContext context) {
    print("InviteFriendCard - userProfileDto: ${userProfileDto.toJson()}");
    return Column(
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatarPhoto(imagePath: userProfileDto.profilePhoto ?? '', radius: 30),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 24, top: 0, bottom: 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UsernameText(
                      username: "${userProfileDto.firstName} ${userProfileDto.lastName}",
                      color: Colors.lightBlue,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                    
                    const SizedBox(height: 10),

                    Text(
                truncateWithEllipsis(30, 'Enviar una solicitud a ${userProfileDto.firstName}'),
                      style: const TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w400)
                    )
                  ],
                ),
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.only(top: 13, bottom: 21),
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.lightBlue
                  ),
                  onPressed: flagButtonNotifier.value != true ? null : () => _inviteFriend(context),
                  child: flagButtonNotifier.value == true ? const Text('Enviar solicitud') : const Text('Solicitud enviada'), 
                ),
              )
            ],
          ),
        ),

        const Divider(height: 1, color: Colors.grey)
      ],
    );
  }
}