import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:videoplayer/model/custom_error.dart';
import 'package:videoplayer/repository/auth_repository.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final AuthRepository authRepository;
  SignInCubit({required this.authRepository}) : super(SignInState.initial());
  Future<void> signInWithGoogle() async {
    emit(state.copyWith(signInStatus: SignInStatus.submitting));

    try {
      await authRepository.signInWithGoogle();

      emit(state.copyWith(signInStatus: SignInStatus.success));
    } on CustomError catch (e) {
      emit(
        state.copyWith(
          signInStatus: SignInStatus.error,
          error: e,
        ),
      );
    }
  }
}
