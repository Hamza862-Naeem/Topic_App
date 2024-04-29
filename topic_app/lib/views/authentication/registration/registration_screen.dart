import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:topic_app/provider/auth/registration_provider.dart';
import '../../../app_constants/color_constants.dart';
import '../../../app_constants/images_constants.dart';
import '../../../app_constants/string_constants.dart';
import '../../../enum/states.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/response_states.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_input_field.dart';
import '../../../widgets/generic_image.dart';
import '../../../widgets/text_style/text_large_bold_widget.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ResponseStatesModel>(registrationProvider,
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
          if (responseStatesModel.data is User) {
            final response = responseStatesModel.data as User;
            if (response != null) {
              _showMsg(responseStatesModel.message);
              _resetForm();
              Navigator.of(context).pushNamed(AppRoutes.otpVerification);
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
              Images().registrationBg,
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
                    height: 5.h,
                  ),
                  TitleLargeBoldTextWidget(
                    title: Strings().createAccountTitle,
                    maxLines: 2,
                    weight: FontWeight.w800,
                    size: 20.sp,
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  CustomInputField(
                    labelText: Strings().name,
                    controller: _nameTextController,
                    keyboardType: TextInputType.name,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  CustomInputField(
                    labelText: Strings().email,
                    controller: _emailTextController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  CustomInputField(
                    labelText: Strings().phoneNumber,
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  CustomInputField(
                    labelText: Strings().password,
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  CustomElevatedButton(
                    callback: () {
                      _registration();
                    },
                    btnText: Strings().registration.toUpperCase(),
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

  void _registration() {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (_nameTextController.text.isEmpty) {
      _showMsg("Please enter your name");
    } else if (_emailTextController.text.isEmpty) {
      _showMsg("Please enter your email address");
    } else if (!emailRegex.hasMatch(_emailTextController.text.toString())) {
      _showMsg("Please enter a valid email");
    } else if (_phoneNumberController.text.isEmpty) {
      _showMsg("Please enter phone number");
    } else if (_passwordController.text.isEmpty) {
      _showMsg("Please enter password");
    } else {
      ref.read(registrationProvider.notifier).registerUser(
          _emailTextController.text.toString(),
          _passwordController.text.toString(),
          _nameTextController.text.toString(),
          _phoneNumberController.text.toString());
    }
  }

  void _resetForm() {
    _passwordController.clear();
    _phoneNumberController.clear();
    _emailTextController.clear();
    _nameTextController.clear();
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
