import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ElevatedButtonWithoutIcon extends StatefulWidget {
  final Function callback;
  final Color? color;
  final String? btnText;
  final Color? textColor;
  final double? textSize;

  const ElevatedButtonWithoutIcon({
    Key? key,
    required this.callback,
    required this.color,
    required this.btnText,
    this.textColor,
    this.textSize,
  }) : super(key: key);

  @override
  ElevatedButtonWithoutIconState createState() =>
      ElevatedButtonWithoutIconState();
}

class ElevatedButtonWithoutIconState extends State<ElevatedButtonWithoutIcon> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(widget.color!),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    side: BorderSide(color: Colors.transparent)))),
        onPressed: () {
          widget.callback();
        },
        child: Center(
            child: Text(widget.btnText!,
                style: TextStyle(
                    fontSize: widget.textSize ?? 12.sp,
                    height: 1.1,
                    color: widget.textColor ?? Colors.white))));
  }
}
