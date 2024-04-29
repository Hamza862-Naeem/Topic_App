import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:topic_app/repository/user_repository.dart';
import 'package:topic_app/utils/response_states.dart';

import '../../enum/states.dart';
import '../../utils/exceptions.dart';

final loginProvider = StateNotifierProvider.autoDispose<
    LoginProvider,
        ResponseStatesModel>((ref) => LoginProvider(ref),
    name: "loginProvider");

class LoginProvider extends StateNotifier<ResponseStatesModel> {
  final AutoDisposeStateNotifierProviderRef _ref;

  LoginProvider(this._ref)
      : super(ResponseStatesModel(States.IDLE, "", null));

  void isLoading(String loadingMessage) {
    state = ResponseStatesModel(States.LOADING, loadingMessage, null);
  }

  void isError(String errorMessage) {
    state = ResponseStatesModel(States.ERROR, errorMessage, null);
  }

  void isSuccess(String successMessage) {
    state = ResponseStatesModel(States.DATA, successMessage, null);
  }

  Future<void> loginUser(
      String email, String password) async {
    try {
      state =
          ResponseStatesModel(States.LOADING, "Loading, Please Wait...", null);
      User? response = await _ref
          .read(userRepository)
          .userLogin(email, password);

      await _ref.read(userRepository).storeUser();
      state = ResponseStatesModel(
          States.DATA, "User login successfully", response);
    } on DataException catch (error) {
      state = ResponseStatesModel(States.ERROR, error.message, null);
    }
  }
}
final userIdProvider = StateProvider<String>((ref) => '');