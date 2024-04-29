import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:topic_app/app_constants/string_constants.dart';
import 'package:topic_app/firebase_options.dart';
import 'package:topic_app/routes/app_routes.dart';
import 'package:topic_app/routes/route_generator.dart';
import 'package:topic_app/utils/logger.dart';

import 'app_constants/color_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: AppColors().primaryColor));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((value) =>
      runApp(ProviderScope(observers: [AppLogger()], child: const MyApp())));
}

Future init() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return ResponsiveSizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: Strings().appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors().primaryColor,
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
          appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(color: Colors.grey.shade500)),
        ),
        initialRoute: AppRoutes.initial,
        onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings),
        builder: EasyLoading.init(),
      );
    });
  }
}
