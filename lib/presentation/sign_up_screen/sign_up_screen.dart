import 'dart:io';
import 'package:brainbd/core/app_export.dart';
import 'package:brainbd/core/utils/validation_functions.dart';
import 'package:brainbd/widgets/app_bar/appbar_leading_iconbutton.dart';
import 'package:brainbd/widgets/app_bar/appbar_title.dart';
import 'package:brainbd/widgets/app_bar/custom_app_bar.dart';
import 'package:brainbd/widgets/custom_elevated_button.dart';
import 'package:brainbd/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as picker;

// import '../services/firebase_auth_methods.dart';
import '../services/firebase_auth_methods.dart';
import 'models/sign_up_model.dart';
import '../services/firebase_storage_service.dart';
import '../services/firebase_firestore_service.dart';

class SignUpScreen extends StatefulWidget {
  static String routeName = '/signup-email-password';
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

// ignore_for_file: must_be_immutable
class SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController createAccountController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  SignUpModel signUpModelObj = SignUpModel();

  bool isShowPassword = true;

  @override
  void dispose() {
    super.dispose();
    createAccountController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
  }

  void changePasswordVisibility() {
    setState(() {
      isShowPassword = !isShowPassword;
    });
  }

  void signUpUser() async {
    try {
      await FirebaseAuthMethods(FirebaseAuth.instance)
          .signUpWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
        context: context,
      );

      // Upload profile picture to Firebase Storage
      if (signUpModelObj.profilePicture != null) {
        String imageUrl = await FirebaseStorageService.uploadProfilePicture(
          signUpModelObj.profilePicture!,
          FirebaseAuth.instance.currentUser!.uid,
        );

        print('Image uploaded to Firebase Storage. Download URL: $imageUrl');

        // Store the image URL in Firebase Firestore
        await FirebaseFirestoreService.storeUserProfilePicture(
          FirebaseAuth.instance.currentUser!.uid,
          imageUrl,
        );

        print('Image URL stored in Cloud Firestore.');
      }

      createAccountController.clear();
      emailController.clear();
      passwordController.clear();
      confirmpasswordController.clear();

      // If the registration is successful, show a dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("Registration successful!"),
            actions: [
              TextButton(
                onPressed: () {
                  // Reset the form and dismiss the dialog
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Sign Up Error: $e');
      // Handle sign-up failure if needed
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
            padding: EdgeInsets.only(top: 26.v),
            child: Container(
              margin: EdgeInsets.only(bottom: 5.v),
              padding: EdgeInsets.symmetric(horizontal: 16.h),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 166.h,
                      child: Text(
                        "lbl_create_account".tr,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.headlineMedium!
                            .copyWith(height: 1.50),
                      ),
                    ),
                  ),
                  SizedBox(height: 29.v),
                  _buildCreateAccount(context),
                  SizedBox(height: 20.v),
                  _buildEmail(context),
                  SizedBox(height: 20.v),
                  _buildPassword(context),
                  SizedBox(height: 30.v),
                  _buildRegister(context),
                  SizedBox(height: 16.v),
                  GestureDetector(
                    onTap: () {
                      onTapTxtAlreadyhavean(context);
                    },
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "msg_already_have_an2".tr,
                          style: CustomTextStyles.bodyMediumff979797,
                        ),
                        TextSpan(
                          text: "lbl_login".tr,
                          style: CustomTextStyles.titleSmallff000000,
                        ),
                      ]),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 31.v),
                  _buildSignUp(context),
                  SizedBox(height: 20.v),
                  _buildFrame(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 56.h,
      leading: AppbarLeadingIconButton(
        imagePath: ImageConstant.imgArrowDown,
        margin: EdgeInsets.only(left: 16.h, top: 5.v, bottom: 5.v),
        onTap: () {
          onTapArrowDown(context);
        },
      ),
      centerTitle: true,
      title: AppbarTitle(text: "lbl_let_s_sign_up".tr),
    );
  }

  Widget _buildCreateAccount(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        GestureDetector(
          onTap: _pickProfilePicture,
          child: Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: signUpModelObj.profilePicture != null
                    ? FileImage(signUpModelObj.profilePicture!)
                        as ImageProvider<Object>?
                    : AssetImage('assets/images/profilePic.jpg'),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        CustomTextFormField(
          controller: createAccountController,
          hintText: "lbl_name".tr,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "err_msg_please_enter_valid_text".tr;
            }
            return null;
          },
          onChanged: (text) {},
        ),
      ],
    );
  }

  void _pickProfilePicture() async {
    final pickedFile = await picker.ImagePicker()
        .pickImage(source: picker.ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        signUpModelObj.profilePicture = File(pickedFile.path);
      });
    }
  }

  Widget _buildEmail(BuildContext context) {
    return CustomTextFormField(
      controller: emailController,
      hintText: "lbl_email".tr,
      textInputType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || (!isValidEmail(value, isRequired: true))) {
          return "err_msg_please_enter_valid_email".tr;
        }
        return null;
      },
      onChanged: (text) {},
    );
  }

  Widget _buildPassword(BuildContext context) {
    return Column(
      children: [
        CustomTextFormField(
          controller: passwordController,
          hintText: "lbl_password".tr,
          textInputAction: TextInputAction.done,
          textInputType: TextInputType.visiblePassword,
          suffix: InkWell(
            onTap: changePasswordVisibility,
            child: Container(
              margin: EdgeInsets.fromLTRB(30.h, 18.v, 16.h, 18.v),
              child: Icon(
                isShowPassword ? Icons.visibility : Icons.visibility_off,
                size: 16.adaptSize,
              ),
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
        ),
        SizedBox(height: 20),
        CustomTextFormField(
          controller: confirmpasswordController,
          hintText: "Confirm Password".tr,
          textInputAction: TextInputAction.done,
          textInputType: TextInputType.visiblePassword,
          suffix: InkWell(
            onTap: changePasswordVisibility,
            child: Container(
              margin: EdgeInsets.fromLTRB(30.h, 18.v, 16.h, 18.v),
              child: Icon(
                isShowPassword ? Icons.visibility : Icons.visibility_off,
                size: 16.adaptSize,
              ),
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
        ),
      ],
    );
  }

  Widget _buildRegister(BuildContext context) {
    return CustomElevatedButton(
      text: "lbl_register".tr,
      onPressed: signUpUser,
    );
  }

  Widget _buildFrame(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildGoogle(context),
        _buildTwitter(context),
      ],
    );
  }

  Widget _buildFrameSeventeen(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.v),
      child: SizedBox(
        width: 160.h,
        child: Center(
          child: Text(
            "msg_or_continue_with".tr,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUp(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 19.v),
            child: SizedBox(width: 105.h, child: Divider()),
          ),
        ),
        _buildFrameSeventeen(context),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 19.v),
            child: SizedBox(width: 105.h, child: Divider()),
          ),
        ),
      ],
    );
  }

  Widget _buildGoogle(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: 4.h),
        child: GestureDetector(
          onTap: () {
            context.read<FirebaseAuthMethods>().signInWithGoogle(context);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0), // Adjust as needed
              color: Colors.grey[100], // Background color
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgGoogle,
                  height: 30.adaptSize,
                  width: 30.adaptSize,
                ),
                SizedBox(width: 8.0), // Adjust spacing between icon and text
                Text(
                  "lbl_google".tr,
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildTwitter(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Handle Twitter button tap
        },
        child: Container(
          margin: EdgeInsets.only(left: 11.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0), // Adjust as needed
            color: Colors.grey[100], // Background color
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.only(right: 4.h),
                child: CustomImageView(
                  imagePath: ImageConstant.imgTwitter,
                  height: 30.adaptSize,
                  width: 30.adaptSize,
                ),
              ),
              Text(
                "lbl_twitter".tr,
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }


  onTapArrowDown(BuildContext context) {
    NavigatorService.goBack();
  }

  onTapTxtAlreadyhavean(BuildContext context) {
    NavigatorService.pushNamed(AppRoutes.signInScreen);
  }
}
