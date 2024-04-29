import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
      ProviderBase provider,
      Object? previousValue,
      Object? newValue,
      ProviderContainer container,
      ) {
    if (kDebugMode) {
      print('''
      {
  "provider": "${provider.name ?? provider.runtimeType}",
  "previous vale": "$previousValue",
  "newValue": "$newValue"
       }''');
    }
  }
}