import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techconnect_mobile/models/friend_request_dto.dart';
import 'package:techconnect_mobile/models/user_profile_dto.dart';
import 'package:techconnect_mobile/services/user_profile_service.dart';

part 'invite_friends_event.dart';
part 'invite_friends_state.dart';

class InviteFriendsBloc extends Bloc<InviteFriendsEvent, InviteFriendsState> {

  final UserProfileService userProfileService;

  InviteFriendsBloc(this.userProfileService) : super(InviteFriendsState()) {
    on<LoadNearFriends>((event, emit) => _onLoadNearFriends(event, emit));
    on<InviteFriend>((event, emit) => _onInviteFriend(event, emit));
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


  Future<void> _onInviteFriend(InviteFriend event, Emitter<InviteFriendsState> emit) async {
    print("Entra onInviteFriend");
    emit(state.copyWith(isLoading: true));

    FriendRequestDto? friendRequestDto = FriendRequestDto(
      id: null,
      fromUser: event.fromUser,
      fromEmail: event.fromUser.email, 
      toUser: event.toUser, 
      toEmail: event.toUser.email, 
      status: false,
      createAt: null);

    try {
      friendRequestDto = await userProfileService.sendFriendRequest(friendRequestDto);
      print("Friend request response : ${friendRequestDto!.toJson()}");
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      print("Error inviting friend: $e");
      emit(state.copyWith(isLoading: false));
    }
  }
}
