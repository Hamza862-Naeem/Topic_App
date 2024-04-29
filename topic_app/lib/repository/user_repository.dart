import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topic_app/model/request/user.dart';
import 'package:topic_app/provider/auth/verification_provider.dart';
import '../app_constants/string_constants.dart';
import '../provider/auth/login_provider.dart';
import '../utils/exceptions.dart';

final userRepository = StateProvider((ref) => _UserRepository(ref));
FirebaseFirestore db = FirebaseFirestore.instance;

class _UserRepository {
  Ref ref;

  _UserRepository(this.ref);

  Future<User?> registerUser(
      String email, String password, String name, String phoneNumber) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        UserRequestModel userRequestModel = UserRequestModel(
            id: credential.user!.uid,
            name: name,
            email: email,
            password: password,
            phoneNumber: phoneNumber,
            isValidated: false,
            role: "user");

        db.collection("users").doc(credential.user!.uid).set(
              userRequestModel.toMap(),
            );
        ref.read(phoneNumberProvider.notifier).state = phoneNumber;
        ref.read(userIdProvider.notifier).state = credential.user!.uid;
      }
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw DataException(message: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        throw DataException(
            message: "The account already exists for that email.");
      }
    } catch (e) {
      throw DataException(message: e.toString());
    }
  }

  Future<User?> userLogin(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        ref.read(userIdProvider.notifier).state = credential.user!.uid;
        DocumentSnapshot<Map<String, dynamic>> userData =
            await getUser(credential.user!.uid);
        if (userData != null && userData["isValidated"] == false) {
          ref.read(phoneNumberProvider.notifier).state =
              userData["phoneNumber"];

          throw DataException(message: 'unverified');
        }
      }
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw DataException(message: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw DataException(message: 'Wrong password provided for that user.');
      } else if (e.code == 'invalid-credential') {
        throw DataException(message: 'Email or password are invalid');
      } else {
        throw DataException(message: e.toString());
      }
    }
  }

  Future<String> sendCode() async {
    Completer<String> completer = Completer<String>();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: ref.watch(phoneNumberProvider),
      verificationCompleted: (PhoneAuthCredential credential) {
        completer.complete('verification_completed');
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          completer.complete("The provided phone number is not valid.");
        } else {
          completer.complete(e.toString());
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        ref.read(verificationIdProvider.notifier).state = verificationId;
        completer.complete('code_send');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        completer.complete('timeout');
      },
    );

    return completer.future;
  }

  Future<String> verifiedUser() async {
    Completer<String> completer = Completer<String>();
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: ref.watch(verificationIdProvider),
        smsCode: ref.watch(verificationCodeProvider));
    FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
      var collection =
          await db.collection('users').doc(ref.watch(userIdProvider));

      await collection
          .update({'isValidated': 'true'}) // <-- Updated data
          .then((_) => {
            completer.complete("updated")
          })
          .catchError((error) => {completer.complete(error.toString())});
    });
    return completer.future;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(
      String documentId) async {
    return await db.collection('users').doc(documentId).get();
  }

  Future<void> storeUser() async {
    DocumentSnapshot<Map<String, dynamic>> user =
        await getUser(ref.watch(userIdProvider));
    if (user.data() != null) {
      UserRequestModel userRequestModel =
          UserRequestModel.fromMap(user.data()!);
      String stringUser = userRequestModel.toJson();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(Strings().prefUserData, stringUser);
    }
  }



}
