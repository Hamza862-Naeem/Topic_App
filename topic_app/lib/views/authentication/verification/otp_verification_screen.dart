import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:topic_app/provider/auth/verification_provider.dart';
import 'package:topic_app/widgets/text_style/text_small_normal_widget.dart';
import '../../../app_constants/color_constants.dart';
import '../../../app_constants/images_constants.dart';
import '../../../app_constants/string_constants.dart';
import '../../../enum/states.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/connection_status_singleton.dart';
import '../../../utils/response_states.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/generic_image.dart';
import '../../../widgets/text_style/text_large_bold_widget.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  OtpVerificationScreenState createState() => OtpVerificationScreenState();
}

class OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      check().then((value) async {
        if (value) {
          ref.read(verificationProvider.notifier).sendCode();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(Strings().noInternetAvailableMsg)));
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ResponseStatesModel>(verificationProvider,
        (previous, responseStatesModel) async {
      switch (responseStatesModel.states) {
        case States.LOADING:
          EasyLoading.show(
            status: 'Loading...',
            maskType: EasyLoadingMaskType.black,
          );
          break;
        case States.ERROR:
          EasyLoading.dismiss();

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(responseStatesModel.message),
          ));

          break;
        case States.DATA:
          EasyLoading.dismiss();
          if (responseStatesModel.data is String) {
            if (responseStatesModel.data.toString() == "updated") {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.dashboard, (Route<dynamic> route) => false);
            } else {
              _showMsg(responseStatesModel.message.toString());
            }
          }
          break;
        default:
          EasyLoading.dismiss();
          break;
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              Images().otpBg,
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 4.h,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.zero,
                      height: 5.5.h,
                      width: 5.5.h,
                      decoration: BoxDecoration(
                        color: AppColors().mediumGray,
                        borderRadius:
                            BorderRadius.circular(12.h), // Set the radius here
                      ),
                      alignment: Alignment.center,
                      // Align child in the center
                      child: GenericImage(
                        imagePath: Images().backImg,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  TitleLargeBoldTextWidget(
                    title: Strings().verificationCode,
                    maxLines: 2,
                    weight: FontWeight.w800,
                    size: 20.sp,
                  ),
                  TitleSmallNormalTextWidget(
                    title: Strings().verificationDescription,
                    maxLines: 2,
                    weight: FontWeight.w400,
                    size: 16.sp,
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.black,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(12),
                      fieldHeight: 40,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                    ),
                    animationDuration: Duration(milliseconds: 300),
                    onChanged: (value) {
                      ref.read(verificationCodeProvider.notifier).state = value;
                    },
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  CustomElevatedButton(
                    callback: () {
                      check().then((value) async {
                        if (value) {
                          ref.read(verificationProvider.notifier).verifiedCode();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(Strings().noInternetAvailableMsg)));
                        }
                      });

                    },
                    btnText: Strings().verify.toUpperCase(),
                    isIconRequired: false,
                    textColor: Colors.white,
                    color: Colors.black,
                  ),
                ],
              )),
        ),
      ),
    );
  }

  void _showMsg(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
