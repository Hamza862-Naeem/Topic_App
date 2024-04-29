import 'package:flutter/material.dart';
import 'package:topic_app/views/authentication/login/login_screen.dart';
import 'package:topic_app/views/authentication/login/reset_Password.dart';
import 'package:topic_app/views/authentication/registration/registration_screen.dart';
import 'package:topic_app/views/authentication/verification/otp_verification_screen.dart';
import 'package:topic_app/views/dashboard/dashboard_screen.dart';
import 'package:topic_app/views/dashboard/design.dart';
import 'package:topic_app/views/dashboard/registered_topics.dart';
import 'package:topic_app/views/splash/splash_screen.dart';

import 'app_routes.dart';
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (BuildContext context) => const LoginScreen(),
        );
      case AppRoutes.dashboard:
        return MaterialPageRoute(
          builder: (BuildContext context) => const DashBoardScreen(),
        );
      case AppRoutes.registration:
        return MaterialPageRoute(
          builder: (BuildContext context) => const RegistrationScreen(),
        );
      case AppRoutes.otpVerification:
        return MaterialPageRoute(
          builder: (BuildContext context) => const OtpVerificationScreen(),
        );
      case AppRoutes.forgotPassword:
        return MaterialPageRoute(
          builder: (BuildContext context) => ForgotPassword(),
        );
      case AppRoutes.design:
        return MaterialPageRoute(
          builder: (BuildContext context) => RegisteredTopics(),
        );
      default:
      // By default, navigate to the splash screen
        return MaterialPageRoute(
          builder: (BuildContext context) => const SplashScreen(),
        );
    }
  }
}
