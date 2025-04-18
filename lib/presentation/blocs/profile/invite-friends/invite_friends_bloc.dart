import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techconnect_mobile/models/user_profile_dto.dart';
import 'package:techconnect_mobile/services/user_profile_service.dart';

part 'invite_friends_event.dart';
part 'invite_friends_state.dart';

class InviteFriendsBloc extends Bloc<InviteFriendsEvent, InviteFriendsState> {

  final UserProfileService userProfileService;

  InviteFriendsBloc(this.userProfileService) : super(InviteFriendsState()) {
    on<LoadNearFriends>((event, emit) => _onLoadNearFriends(event, emit));
  }

  Future<void> _onLoadNearFriends(LoadNearFriends event, Emitter<InviteFriendsState> emit) async {
    emit(state.copyWith(isLoading: true));
    final userProfileId = userProfileService.loggedUserProfile!.id;

    try {
      print("INVITE FRIENDS BLOC - UserProfileId $userProfileId");
      final userProfilesList = await userProfileService.getPossibleFriends(userProfileId!);
      print("INVITE FRIENDS BLOC - UserProfilesList $userProfilesList");
      emit(state.copyWith(
        userProfileId: userProfileId,
        userProfilesList: userProfilesList,
        isLoading: false,
      ));
    } catch (e) {
      print("Error loading near friends: $e");
      emit(state.copyWith(isLoading: false));
      return;
    }
  }
}
