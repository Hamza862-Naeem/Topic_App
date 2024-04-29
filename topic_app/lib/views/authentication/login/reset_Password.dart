import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:topic_app/app_constants/string_constants.dart';
import 'package:topic_app/widgets/custom_input_field.dart';

import '../../../app_constants/color_constants.dart';
import '../../../app_constants/images_constants.dart';
import '../../../widgets/generic_image.dart';

class ForgotPassword extends StatefulWidget {
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }

  Future<void> _resetPassword(String email) async {
    try {

      await _auth.sendPasswordResetEmail(email: email);

      // Show success message
      _showToast(context, 'Password reset email sent successfully.');
    } catch (error) {
      // Handle error
      print('Error sending password reset email: $error');
      // Show error message
      _showToast(context, 'Failed to send password reset email. Please try again.');
    }
  }

  Future<void> forgotpassword(String email) async {
    if (email.isEmpty) {
      // Show alert if email field is empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please enter an email address.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Send password reset email
      try {
        await _auth.sendPasswordResetEmail(email: email);
        _showToast(context, 'Password reset email sent successfully.');
      } catch (error) {
        print('Error sending password reset email: $error');
        _showToast(context, 'Failed to send password reset email. Please try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: GenericImage(
            imagePath: Images().backImg,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            children: [
              GenericImage(
                imagePath: Images().appLogo,
                width: 30.h,
                height: 30.h,
              ),
              CustomInputField(
                labelText: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                obscureText: false,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  String email = _emailController.text.trim();
                  forgotpassword(email);
                  Navigator.pop(context);
                },
                child: Text(
                  'Reset Password',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
