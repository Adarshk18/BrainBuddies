
import 'package:brainbd/presentation/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:brainbd/presentation/sign_up_sign_in_screen/sign_up_sign_in_screen.dart';
import 'package:brainbd/presentation/sign_in_screen/sign_in_screen.dart';
import 'package:brainbd/presentation/sign_up_screen/sign_up_screen.dart';
import 'package:brainbd/presentation/forgot_password_screen/forgot_password_screen.dart';
import 'package:brainbd/presentation/verification_code_screen/verification_code_screen.dart';
import 'package:brainbd/presentation/reset_password_screen/reset_password_screen.dart';
import 'package:brainbd/presentation/app_navigation_screen/app_navigation_screen.dart';

import '../presentation/account_detail_scren/account_detail_screen.dart';

class AppRoutes {
  static const String signUpSignInScreen = '/sign_up_sign_in_screen';

  static const String signInScreen = '/sign_in_screen';

  static const String signUpScreen = '/sign_up_screen';

  static const String homeScreen = '/home_screen';

  static const String accountDetailsScreen = '/account_details_screen';

  static const String forgotPasswordScreen = '/forgot_password_screen';

  static const String verificationCodeScreen = '/verification_code_screen';

  static const String resetPasswordScreen = '/reset_password_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> get routes => {
        // signUpSignInScreen: SignUpSignInScreen.builder,
        // signInScreen: SignInScreen.builder,
        // signUpScreen: SignUpScreen.builder,
        // forgotPasswordScreen: ForgotPasswordScreen.builder,
        // verificationCodeScreen: VerificationCodeScreen.builder,
        // resetPasswordScreen: ResetPasswordScreen.builder,
        // appNavigationScreen: AppNavigationScreen.builder,
        // initialRoute: SignUpSignInScreen.builder

        signUpSignInScreen: (context) => SignUpSignInScreen(),
        signInScreen: (context) => SignInScreen(),
        homeScreen: (context) => HomeScreen(),
        accountDetailsScreen: (context) => AccountDetailsScreen(),
        signUpScreen: (context) => SignUpScreen(),
        forgotPasswordScreen: (context) => ForgotPasswordScreen(),
        verificationCodeScreen: (context) => VerificationCodeScreen(),
        resetPasswordScreen: (context) => ResetPasswordScreen(),
        appNavigationScreen: (context) => AppNavigationScreen(),
        initialRoute: (context) => SignUpSignInScreen()
      };
}
