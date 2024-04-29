
import '../enum/states.dart';

class ResponseStatesModel {
  ResponseStatesModel(this.states, this.message, this.data);
  States states;
  String message;
  dynamic data;
}