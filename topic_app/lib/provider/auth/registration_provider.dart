import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:topic_app/repository/user_repository.dart';
import 'package:topic_app/utils/response_states.dart';

import '../../enum/states.dart';
import '../../utils/exceptions.dart';

final registrationProvider = StateNotifierProvider.autoDispose<
        RegistrationProvider,
        ResponseStatesModel>((ref) => RegistrationProvider(ref),
    name: "registrationProvider");

class RegistrationProvider extends StateNotifier<ResponseStatesModel> {
  final AutoDisposeStateNotifierProviderRef _ref;

  RegistrationProvider(this._ref)
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

  Future<void> registerUser(
      String email, String password, String name, String phoneNumber) async {
    try {
      state =
          ResponseStatesModel(States.LOADING, "Loading, Please Wait...", null);
      User? response = await _ref
          .read(userRepository)
          .registerUser(email, password, name, phoneNumber);
      state = ResponseStatesModel(
          States.DATA, "User registered successfully", response);
    } on DataException catch (error) {
      state = ResponseStatesModel(States.ERROR, error.message, null);
    }
  }
}
