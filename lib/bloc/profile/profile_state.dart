part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, loaded, error }

class ProfileState extends Equatable {
  final ProfileStatus profileStatus;
  final UserData userData;
  final CustomError error;

  const ProfileState(
      {required this.profileStatus,
      required this.userData,
      required this.error});

  factory ProfileState.initial() {
    return ProfileState(
      error: const CustomError(),
      profileStatus: ProfileStatus.initial,
      userData: UserData.initialUser(),
    );
  }
  @override
  List<Object> get props => [profileStatus, userData, error];

  ProfileState copyWith({
    ProfileStatus? profileStatus,
    UserData? userData,
    CustomError? error,
  }) {
    return ProfileState(
      profileStatus: profileStatus ?? this.profileStatus,
      userData: userData ?? this.userData,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'ProfileState(status: $profileStatus, userData: $userData, error: $error)';
}
