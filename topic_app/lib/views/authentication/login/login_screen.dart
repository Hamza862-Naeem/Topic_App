import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:topic_app/provider/auth/login_provider.dart';
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
import '../../../widgets/text_style/text_small_bold_widget.dart';
import 'reset_Password.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen<ResponseStatesModel>(loginProvider,
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
              if(responseStatesModel.message == "unverified"){
                Navigator.of(context)
                    .pushNamed(AppRoutes.otpVerification);
              }else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(responseStatesModel.message),
                ));
              }
              break;
            case States.DATA:
              EasyLoading.dismiss();
              if (responseStatesModel.data is User) {
                final response = responseStatesModel.data as User;
                if (response != null) {
                  _showMsg(responseStatesModel.message);
                  _resetForm();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.dashboard, (Route<dynamic> route) => false);
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
              Images().loginBg,
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: GenericImage(
                      imagePath: Images().appLogo,
                      width: 30.h,
                      height: 30.h,
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  TitleLargeBoldTextWidget(
                    title: Strings().welcome,
                  ),
                  TitleSmallBoldTextWidget(
                    title: Strings().enterEmailPwd,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 4.h,
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
                      _login();
                    },
                    btnText: Strings().login.toUpperCase(),
                    isIconRequired: false,
                    textColor: Colors.white,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),

                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.registration);
                      },
                      child: TitleSmallBoldTextWidget(
                        title: Strings().createAccount,
                        color: AppColors().hintColor,
                      ),
                    ),

                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap:(){
                        _forgotPassword(context);
                      },
                      child: const TitleSmallBoldTextWidget(
                        title: 'Forgot Password?',
                        color: Colors.blue,
                      )
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
  void _forgotPassword(BuildContext context){
    Navigator.of(context).pushNamed(AppRoutes.forgotPassword);
  }


  void _login() {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (_emailTextController.text.isEmpty) {
      _showMsg("Please enter your email address");
    } else if (!emailRegex.hasMatch(_emailTextController.text.toString())) {
      _showMsg("Please enter a valid email");
    } else if (_passwordController.text.isEmpty) {
      _showMsg("Please enter password");
    } else {
      ref.read(loginProvider.notifier).loginUser(
        _emailTextController.text.toString(),
        _passwordController.text.toString());
    }

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

void _resetForm() {
  _passwordController.clear();
  _emailTextController.clear();
}

}

