import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:topic_app/model/request/topics.dart';
import 'package:topic_app/repository/main_repository.dart';
import 'package:topic_app/repository/user_repository.dart';
import 'package:topic_app/utils/response_states.dart';
import 'package:topic_app/views/dashboard/registered_topics.dart';

import '../../enum/states.dart';
import '../../utils/exceptions.dart';





final topicProvider = StateNotifierProvider.autoDispose<
    TopicProvider,
        ResponseStatesModel>((ref) => TopicProvider(ref),
    name: "topicProvider");

class TopicProvider extends StateNotifier<ResponseStatesModel> {
  final AutoDisposeStateNotifierProviderRef _ref;

  TopicProvider(this._ref)
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

// this is for register topic method
  Future<void> registerTopic(String title, String description,
      File? avatarImage, String? parentId, String relatedTopic) async {
    try {
      state =
          ResponseStatesModel(States.LOADING, "Loading, Please Wait...", null);
      String? response = await _ref
          .read(registeredRepository)
          .registerTopics(title, description, avatarImage, parentId,relatedTopic);

      state = ResponseStatesModel(
          States.DATA, "Topic Added Successfully", response);
    } on DataException catch (error) {
      state = ResponseStatesModel(States.ERROR, error.message, null);
    }


  }


//fetch data from firebase
  Future<List<TopicRequestModel>?> getData() async {
    try {
      state =
          ResponseStatesModel(
              States.LOADING, "Loading, Please Wait...", null);
      List<TopicRequestModel> response = await _ref
          .read(registeredRepository)
          .getData();

      state = ResponseStatesModel(
          States.DATA, "Get Topic Successfully", response);
    } on DataException catch (error) {
      state = ResponseStatesModel(States.ERROR, error.message, null);
    }
  }


}

final listOFTopics = StateProvider<List<TopicRequestModel>>((ref) => []);

final selectedTopics = StateProvider<List<TopicRequestModel>>((ref) => []);


final selectedParentIdProvider = StateProvider<List<TopicRequestModel>>((ref) => []);


//final relatedTopics = StateProvider<List<TopicRequestModel>>((ref) => []);