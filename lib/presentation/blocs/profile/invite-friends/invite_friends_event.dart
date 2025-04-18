part of 'invite_friends_bloc.dart';

sealed class InviteFriendsEvent extends Equatable {
  const InviteFriendsEvent();

  @override
  List<Object> get props => [];
}

class LoadNearFriends extends InviteFriendsEvent {}

class SkipInviteFriends extends InviteFriendsEvent {}

class FinishInviteFriends extends InviteFriendsEvent {}
