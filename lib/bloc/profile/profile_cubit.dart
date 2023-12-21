import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:videoplayer/model/models.dart';
import 'package:videoplayer/repository/profile_repository.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;
  ProfileCubit({required this.profileRepository})
      : super(ProfileState.initial());

  Future<UserData> getProfile({required String uid}) async {
    emit(state.copyWith(profileStatus: ProfileStatus.loading));

    try {
      final UserData userData = await profileRepository.getProfile(uid: uid);
      emit(state.copyWith(
        profileStatus: ProfileStatus.loaded,
        userData: userData,
      ));
      return userData; // Return the UserData
    } on CustomError catch (e) {
      emit(state.copyWith(
        profileStatus: ProfileStatus.error,
        error: e,
      ));
      rethrow; // Rethrow the error so it can be caught in _fetchVideos
    }
  }

  // Function to add video URLs to user profile
  Future<void> addVideoUrls(
      {required String uid, required List<String> videoUrls}) async {
    emit(state.copyWith(profileStatus: ProfileStatus.loading));
    try {
      // Call your repository method to add video URLs
      await profileRepository.addVideoUrlsToUserProfile(
        uid: uid,
        videoUrls: videoUrls,
      );
      // Fetch the updated profile data after adding video URLs
      UserData userData = await profileRepository.getProfile(uid: uid);
      emit(state.copyWith(
        profileStatus: ProfileStatus.loaded,
        userData: userData,
      ));
    } on CustomError catch (e) {
      emit(state.copyWith(
        profileStatus: ProfileStatus.error,
        error: e,
      ));
    }
  }
}
