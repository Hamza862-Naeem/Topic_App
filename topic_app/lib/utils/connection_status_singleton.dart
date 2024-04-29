import 'dart:async'; //For StreamController/Stream
import 'dart:io'; //InternetAddress utility

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

import '../widgets/elevated_button_without_icon_widget.dart';
import '../widgets/text_style/text_small_bold_widget.dart';


class ConnectionStatusSingleton {
  //This creates the single instance by calling the `_internal` constructor specified below
  static final ConnectionStatusSingleton _singleton =
      ConnectionStatusSingleton._internal();

  ConnectionStatusSingleton._internal();

  //This is what's used to retrieve the instance through the app
  static ConnectionStatusSingleton getInstance() => _singleton;

  //This tracks the current connection status
  bool hasConnection = false;

  //This is how we'll allow subscribing to connection changes
  StreamController connectionChangeController = StreamController.broadcast();

  //flutter_connectivity
  final Connectivity _connectivity = Connectivity();

  //Hook into flutter_connectivity's Stream to listen for changes
  //And check the connection status out of the gate
  void initialize() {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    checkConnection();
  }

  Stream get connectionChange => connectionChangeController.stream;

  //A clean up method to close our StreamController
  //   Because this is meant to exist through the entire application life cycle this isn't
  //   really an issue
  void dispose() {
    connectionChangeController.close();
  }

  //flutter_connectivity's listener
  void _connectionChange(ConnectivityResult result) {
    checkConnection();
  }

  //The test to actually see if there is a connection
  Future<bool> checkConnection() async {
    bool previousConnection = hasConnection;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }

    //The connection status changed send out an update to all listeners
    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }

    return hasConnection;
  }
}

Future<bool> check() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}

void showInternetDialog(
    String title, String content, BuildContext context, Function callback) {
  StylishDialog(
    context: context,
    alertType: StylishDialogType.ERROR,
    titleText: title,
    titleStyle: const TextStyle(
        color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
    contentStyle: const TextStyle(color: Colors.black, fontSize: 12),
    contentText: content,
    dismissOnTouchOutside: false,
    cancelButton: ElevatedButtonWithoutIcon(
      btnText: "Close",
      color: Colors.green,
      callback: () {
        SystemNavigator.pop();
      },
    ),
  ).show();
}

void showLogoutDialog(
    String title, String content, BuildContext context, Function callback) {
  StylishDialog(
    context: context,
    alertType: StylishDialogType.WARNING,
    contentText: content,
    titleStyle: const TextStyle(
        color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
    contentStyle: const TextStyle(color: Colors.black, fontSize: 12),
    dismissOnTouchOutside: false,
    confirmButton: ElevatedButtonWithoutIcon(
      btnText: "Logout",
      color: Colors.green,
      callback: () {
        callback();
      },
    ),
    cancelButton: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pop(context);
      },
      child: const TitleSmallBoldTextWidget(
        title: "Close",
        color: Colors.green,
        size: 14,
        weight: FontWeight.bold,
      ),
    ),
  ).show();
}
