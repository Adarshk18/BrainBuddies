import 'package:brainbd/core/app_export.dart';
import 'package:brainbd/core/utils/validation_functions.dart';
import 'package:brainbd/widgets/app_bar/appbar_leading_iconbutton.dart';
import 'package:brainbd/widgets/app_bar/appbar_title.dart';
import 'package:brainbd/widgets/app_bar/custom_app_bar.dart';
import 'package:brainbd/widgets/custom_elevated_button.dart';
import 'package:brainbd/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../home_screen/home_screen.dart';
import '../services/firebase_auth_methods.dart';
import 'models/sign_in_model.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  SignInScreenState createState() => SignInScreenState();
}

// ignore_for_file: must_be_immutable
class SignInScreenState extends State<SignInScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignInModel signInModelObj = SignInModel();

  bool isShowPassword = true;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void changePasswordVisibility() {
    isShowPassword = !isShowPassword;
  }

  void loginUser() async {
    try {
      // Sign in with email and password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Check if the user is not null (exists in Firebase Authentication)
      if (FirebaseAuth.instance.currentUser != null) {
        // Navigate to the home screen
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      } else {
        // If the user is null, show an error dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Login Failed"),
              content: Text("Invalid email or password. Please check your credentials."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Login Error: $e');
      // Handle login failure if needed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Login Failed",style: TextStyle(color: Colors.red),),
            content: Text("Invalid credentials. Please check your email and password."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 25.v),
            child: Container(
              margin: EdgeInsets.only(bottom: 5.v),
              padding: EdgeInsets.symmetric(horizontal: 16.h),
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                          width: 164.h,
                          child: Text("lbl_welcome_back".tr,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.headlineMedium!
                                  .copyWith(height: 1.50)))),
                  SizedBox(height: 30.v),
                  _buildWelcomeBack(context),
                  SizedBox(height: 20.v),
                  _buildSignInPassword(context),
                  SizedBox(height: 13.v),
                  Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                          onTap: () {
                            onTapTxtForgotPassword(context);
                          },
                          child: Text("lbl_forgot_password".tr,
                              style: theme.textTheme.titleSmall))),
                  SizedBox(height: 50.v),
                  _buildLoginButton(context),
                  SizedBox(height: 16.v),
                  GestureDetector(
                      onTap: () {
                        onTapTxtDonthaveanaccount(context);
                      },
                      child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: "msg_don_t_have_an_account2".tr,
                                style: CustomTextStyles.bodyMediumff979797),
                            TextSpan(
                                text: "lbl_register".tr,
                                style: CustomTextStyles.titleSmallff000000)
                          ]),
                          textAlign: TextAlign.left)),
                  SizedBox(height: 31.v),
                  _buildFrameSeventeen(context),
                  SizedBox(height: 20.v),
                  _buildFrame(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
        leadingWidth: 56.h,
        leading: AppbarLeadingIconButton(
            imagePath: ImageConstant.imgArrowDown,
            margin: EdgeInsets.only(left: 16.h, top: 5.v, bottom: 5.v),
            onTap: () {
              onTapArrowDown(context);
            }),
        centerTitle: true,
        title: AppbarTitle(text: "lbl_let_s_sign_in".tr));
  }

  /// Section Widget
  Widget _buildWelcomeBack(BuildContext context) {
    return CustomTextFormField(
      controller: emailController,
      hintText: "lbl_email".tr,
      validator: (value) {
        if (value == null || !isValidEmail(value, isRequired: true)) {
          return "err_msg_please_enter_valid_text".tr;
        }
        return null;
      },
      onChanged: (text) {},
    );
  }

  /// Section Widget
  Widget _buildSignInPassword(BuildContext context) {
    return CustomTextFormField(
      controller: passwordController,
      hintText: "lbl_password".tr,
      textInputAction: TextInputAction.done,
      textInputType: TextInputType.visiblePassword,
      suffix: InkWell(
        onTap: changePasswordVisibility,
        child: Container(
          margin: EdgeInsets.fromLTRB(30.h, 18.v, 16.h, 18.v),
          child: CustomImageView(
              imagePath: ImageConstant.imgIcon,
              height: 16.adaptSize,
              width: 16.adaptSize),
        ),
      ),
      suffixConstraints: BoxConstraints(maxHeight: 52.v),
      validator: (value) {
        if (value == null || (!isValidPassword(value, isRequired: true))) {
          return "err_msg_please_enter_valid_password".tr;
        }
        return null;
      },
      obscureText: !isShowPassword,
      contentPadding: EdgeInsets.only(left: 16.h, top: 14.v, bottom: 14.v),
      onChanged: (text) {},
    );
  }

  /// Section Widget
  Widget _buildLoginButton(BuildContext context) {
    return CustomElevatedButton(
      text: "lbl_login".tr,
      onPressed: loginUser,
    );
  }

  /// Section Widget
  Widget _buildOrContinueWithButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.v),
      child: SizedBox(
        width: 140.h,
        child: Center(
          child: Text(
            "msg_or_continue_with".tr,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildFrameSeventeen(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
          padding: EdgeInsets.symmetric(vertical: 10.v),
          child: SizedBox(width: 100.h, child: Divider())),
      _buildOrContinueWithButton(context),
      Padding(
          padding: EdgeInsets.symmetric(vertical: 10.v),
          child: SizedBox(width: 100.h, child: Divider()))
    ]);
  }

  /// Section Widget
  Widget _buildGoogleButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<FirebaseAuthMethods>().signInWithGoogle(context);
      },
      child: Container(
        padding: EdgeInsets.only(right: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0), // Adjust as needed
          color: Colors.grey[100], // Background color
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomImageView(
              imagePath: ImageConstant.imgGoogle,
              height: 40.adaptSize,
              width: 40.adaptSize,
            ),
            SizedBox(width: 10), // Adjust spacing between icon and text
            Text(
              "lbl_google".tr,
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }


  /// Section Widget
  Widget _buildTwitterButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle Twitter button tap
      },
      child: Container(
        margin: EdgeInsets.only(left: 11.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0), // Adjust as needed
          color: Colors.grey[100], // Background color
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(right: 8.h),
              child: CustomImageView(
                imagePath: ImageConstant.imgTwitter,
                height: 40.adaptSize,
                width: 40.adaptSize,
              ),
            ),

            Text(
              "lbl_twitter".tr,
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }


  /// Section Widget
  Widget _buildFrame(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_buildGoogleButton(context), _buildTwitterButton(context)]);
  }

  /// Navigates to the previous screen.
  onTapArrowDown(BuildContext context) {
    NavigatorService.goBack();
  }

  /// Navigates to the forgotPasswordScreen when the action is triggered.
  onTapTxtForgotPassword(BuildContext context) {
    NavigatorService.pushNamed(
      AppRoutes.forgotPasswordScreen,
    );
  }

  /// Navigates to the signUpScreen when the action is triggered.
  onTapTxtDonthaveanaccount(BuildContext context) {
    NavigatorService.pushNamed(
      AppRoutes.signUpScreen,
    );
  }
}
