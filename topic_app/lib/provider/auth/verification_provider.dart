import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../enum/states.dart';
import '../../repository/user_repository.dart';
import '../../utils/exceptions.dart';
import '../../utils/response_states.dart';

final verificationCodeProvider = StateProvider<String>((ref) => '');
final phoneNumberProvider = StateProvider<String>((ref) => '');
final verificationIdProvider = StateProvider<String>((ref) => '');

final verificationProvider = StateNotifierProvider.autoDispose<
        VerificationProvider,
        ResponseStatesModel>((ref) => VerificationProvider(ref),
    name: "verificationProvider");

class VerificationProvider extends StateNotifier<ResponseStatesModel> {
  final AutoDisposeStateNotifierProviderRef _ref;

  VerificationProvider(this._ref)
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

  Future<void> sendCode() async {
    try {
      state =
          ResponseStatesModel(States.LOADING, "Loading, Please Wait...", null);
      String? response = await _ref.read(userRepository).sendCode();
      if(response == "code_send"){
        state = ResponseStatesModel(
            States.DATA, "Code send successfully", response);
      }else if (response == "timeout"){
        state = ResponseStatesModel(States.ERROR, "Timeout", null);
      }else if(response == "verification_completed"){
        state = ResponseStatesModel(
            States.DATA, "Verification Completed", response);
      }else{
        state = ResponseStatesModel(States.ERROR, response.toString(), null);
      }
    } on DataException catch (error) {

      state = ResponseStatesModel(States.ERROR, error.message, null);
    }
  }

  Future<void> verifiedCode() async {
    try {
      state =
          ResponseStatesModel(States.LOADING, "Loading, Please Wait...", null);
      String? response = await _ref.read(userRepository).verifiedUser();
      if(response == "updated"){
        await _ref.read(userRepository).storeUser();
        state = ResponseStatesModel(
            States.DATA, "User successfully verified", response);
      }else{
        state = ResponseStatesModel(States.ERROR, response.toString(), null);
      }
    } on DataException catch (error) {
      state = ResponseStatesModel(States.ERROR, error.message, null);
    }
  }



}
