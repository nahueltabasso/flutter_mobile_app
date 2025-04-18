part of 'invite_friends_bloc.dart';

sealed class InviteFriendsEvent extends Equatable {
  const InviteFriendsEvent();

  @override
  List<Object> get props => [];
}

class LoadNearFriends extends InviteFriendsEvent {}

class InviteFriend extends InviteFriendsEvent {

  final UserProfileDto fromUser;
  final UserProfileDto toUser;

  const InviteFriend(this.fromUser, this.toUser);

  @override
  List<Object> get props => [fromUser, toUser];
}

