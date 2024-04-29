import 'package:flutter/material.dart';

class AppColors {
  Color primaryColor = const Color(0xFF2E4683);
  var secondaryColor = const Color(0xFF2887B9);
  var redColor = const Color(0xFFe84241);
  var greenColor = const Color(0xFF13d933);
  var orangeColor = const Color(0xFFf5a224);
  var hintColor = const Color(0xFFC7CCD2);
  var secondaryTextColor = const Color(0xFFa4a4a4);
  Color appBarHomeColor = const Color(0xFFF6F9FF);

  var greyColor = HexColor.fromHex('#EEEFF3');
  var mediumGray = HexColor.fromHex('#D9D9D9');
  var lightBlueColor = HexColor.fromHex('#F6F9FF');
  var lightGreyColor = HexColor.fromHex('#757897');
  var lightRed = HexColor.fromHex('#C0432D');
  var green = HexColor.fromHex('#109D59');
  var subjectBg = HexColor.fromHex('#e3f2fd');
  Color color1 = const Color(0xFF757897);
  Color color2 = const Color(0xFFEEF3FC);
  Color color3 = const Color(0xFF3F3D56);
  Color color4 = const Color(0xFFFBF1F1);
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
