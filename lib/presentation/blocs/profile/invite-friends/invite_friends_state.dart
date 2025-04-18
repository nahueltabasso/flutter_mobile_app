part of 'invite_friends_bloc.dart';

class InviteFriendsState extends Equatable {

  final int userProfileId;
  final List<UserProfileDto> userProfilesList;
  final bool isLoading;

  const InviteFriendsState({
    this.userProfileId = 0, 
    this.userProfilesList = const [], 
    this.isLoading = false
  });

  InviteFriendsState copyWith({
    int? userProfileId,
    List<UserProfileDto>? userProfilesList,
    bool? isLoading,
  }) {
    return InviteFriendsState(
      userProfileId: userProfileId ?? this.userProfileId,
      userProfilesList: userProfilesList ?? this.userProfilesList,
      isLoading: isLoading ?? this.isLoading,
    );
  }
  
  @override
  List<Object> get props => [userProfileId, userProfilesList, isLoading];
}

