
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:topic_app/widgets/text_style/text_small_normal_widget.dart';

class CustomElevatedButton extends StatefulWidget {
  final Function? callback;
  final Color? color;
  final Color? textColor;
  final String? btnText;
  final bool? isIconRequired;
  final bool? isPrefixIcon;
  final bool isTextBold;
  final IconData? icons;
  final double? fontSize;

  const CustomElevatedButton(
      {Key? key,
      required this.callback,
      required this.textColor,
      required this.color,
      required this.btnText,
      required this.isIconRequired,
      this.isPrefixIcon = false,
      this.isTextBold = false,
      this.fontSize,
      this.icons})
      : super(key: key);

  @override
  CustomElevatedButtonState createState() => CustomElevatedButtonState();
}

class CustomElevatedButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(widget.color!),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.h)),
                    side: BorderSide(color: Colors.transparent)))),
        onPressed: () {
          widget.callback!();
        },
        child: Padding(
          padding: EdgeInsets.all(0.5.h),
          child: Stack(
            alignment: Alignment.center,
            children: [
              widget.isPrefixIcon!
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        widget.icons,
                        color: Colors.white,
                        size: 24,
                      ),
                    )
                  : Container(),
              Align(
                  alignment: Alignment.center,
                  child: TitleSmallNormalTextWidget(
                      title: widget.btnText!,
                      size: widget.fontSize ?? 16.sp,
                      weight:
                          widget.isTextBold ? FontWeight.w800 : FontWeight.w300,
                      color: widget.textColor)),
              widget.isIconRequired!
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        widget.icons,
                        color: Colors.white,
                        size: 24,
                      ),
                    )
                  : Container(),
            ],
          ),
        ));
  }
}
