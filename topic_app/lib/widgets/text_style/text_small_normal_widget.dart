import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TitleSmallNormalTextWidget extends StatelessWidget {
  final String? title;
  final Color? color;
  final double? padding;
  final double? size;
  final FontWeight? weight;
  final TextAlign? align;
  final int? maxLines;
  final TextDecoration? textDecoration;

  const TitleSmallNormalTextWidget({
    Key? key,
    required this.title,
    this.color,
    this.padding,
    this.weight,
    this.size,
    this.align,
    this.maxLines,
    this.textDecoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: padding ?? 0.w),
      child: Text(
        title ?? '',
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines ?? 1,
        softWrap: false,
        textAlign: align ?? TextAlign.start,
        style: TextStyle(
            decoration: textDecoration ?? TextDecoration.none,
            color: color ?? Colors.grey.shade900,
            fontSize: size ?? 15.sp,
            fontWeight: weight ?? FontWeight.w400),
      ),
    );
  }
}
