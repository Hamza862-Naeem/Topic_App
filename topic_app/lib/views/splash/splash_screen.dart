import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topic_app/widgets/text_style/text_large_bold_widget.dart';

import '../../app_constants/images_constants.dart';
import '../../app_constants/string_constants.dart';
import '../../routes/app_routes.dart';
import '../../utils/connection_status_singleton.dart';
import '../../widgets/generic_image.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5), () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      check().then((internet) {
        if (internet) {
          final String? userData = prefs.getString(Strings().prefUserData);
     //>>>     print('User data from SharedPreferences: $userData');
          if (userData != null) {


            Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.dashboard, (Route<dynamic> route) => false);
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.login, (Route<dynamic> route) => false);
          }
        } else {
          showInternetDialog(Strings().noInternetAvailableMsg,
              Strings().checkInternetMsg, context, () {
            Navigator.pop(context);
          });
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              Images().splashBg,
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 3.h,
                  ),
                  GenericImage(
                    imagePath: Images().appLogo,
                    width: 40.h,
                    height: 40.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
