import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quotify/config/SP/sp.dart';
import 'package:quotify/config/constants/colors.dart';
import 'package:quotify/config/constants/spacing.dart';
import 'package:quotify/provider/login_provider.dart';
import 'package:quotify/provider/user_provider.dart';
import 'package:quotify/screens/landing/landing_screen.dart';
import 'package:quotify/screens/onboard/onboard_select_category_screen.dart';
import 'package:quotify/services/sign_in_services.dart';
import 'package:quotify/utilities/user_util.dart';
import 'package:quotify/widgets/custom_icon_btn.dart';
import 'package:quotify/widgets/custom_page_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginArguments {
  final bool isOnboarding;
  LoginArguments({this.isOnboarding = true});
}

class LoginScreen extends StatefulWidget {
  final LoginArguments arguments;
  const LoginScreen({super.key, required this.arguments});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: deviceSize.width,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _topSection(deviceSize),
                _centerSection(context),
                _bottomSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topSection(Size deviceSize) {
    return Expanded(
      flex: 2,
      child: SvgPicture.asset(
        'assets/images/login_bg_image.svg',
        width: deviceSize.width * 0.7,
      ),
    );
  }

  Widget _bottomSection(BuildContext context) {
    log("${widget.arguments.isOnboarding.toString()} is onboarding");
    return Consumer<LoginProvider>(builder: (context, dataClass, _) {
      return Column(
        children: [
          AppSpacing.height40,
          // CustomIconBtn(
          //   onPressed: () {},
          //   backgroundColor: AppColors.facebookBlue,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       SvgPicture.asset('assets/images/fb.svg'),
          //       AppSpacing.width20,
          //       Text(
          //         'Login with Facebook',
          //         style: Theme.of(context)
          //             .textTheme
          //             .bodyMedium
          //             ?.copyWith(color: AppColors.white),
          //       ),
          //     ],
          //   ),
          // ),
          AppSpacing.height20,
          CustomIconBtn(
            onPressed: () async {
              log('auth start');
              Response? response = await googleSignIn(context);
              log('auth end');
              if (response != null && response.statusCode == 200) {
                final sp = await SharedPreferences.getInstance();
                sp.setBool(SP.isOnBorded, true);
                Future.delayed(const Duration(microseconds: 5), () {
                  if (widget.arguments.isOnboarding) {
                    Navigator.pushReplacement(
                      context,
                      CustomPageRoute(
                        child: const OnboardSelectCategoryScreen(
                          isOnBoarded: false,
                        ),
                      ),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      CustomPageRoute(child: const LandingScreen()),
                    );
                  }
                });
              }
            },
            backgroundColor: const Color(0xffF3F3F3),
            child: Row(
              spacing: 15,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/images/google_icon.svg'),
                Text(
                  'Login with Google',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.black),
                ),
                if (dataClass.isLoading)
                  Container(
                    width: 24,
                    height: 24,
                    padding: const EdgeInsets.all(2.0),
                    child: const CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 3,
                    ),
                  )
                else
                  Container(
                      width: 24,
                      height: 24,
                      padding: const EdgeInsets.all(2.0),
                      child: const SizedBox())
              ],
            ),
          ),
          AppSpacing.height40,
          if (widget.arguments.isOnboarding)
            TextButton(
              onPressed: () async {
                final sp = await SharedPreferences.getInstance();
                sp.setBool(SP.isOnBorded, true);
                Future.delayed(Duration.zero, () {
                  Navigator.pushReplacement(
                    context,
                    CustomPageRoute(
                      child: const OnboardSelectCategoryScreen(
                        isOnBoarded: false,
                      ),
                    ),
                  );
                });
              },
              child: Text(
                'Skip',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
        ],
      );
    });
  }

  Widget _centerSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text('Create An Account', style: textTheme.titleLarge),
        Text(
          'You can create your account with any of\n your social profile or you can try with your\n phone number.',
          style: textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Future<Response?> googleSignIn(BuildContext context) async {
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    Provider.of<UserProvider>(context, listen: false);
    final useData = UserData();
    Response? loginResponse;
    loginProvider.setLoading(true);
    final _res = await SignInServices.googleLogin();
    print("------- res $_res");
    if (_res != null) {
      var userName = _res.displayName?.split(' ');
      Map<String, dynamic> data = {
        'first_name': userName?[0],
        'email': _res.email,
        'isd_code': '',
        'phone_number': '',
        'address': '',
        'password': '',
        'profile_image': _res.photoUrl,
        'provider': 'google',
        'provider_user_id': _res.id,
      };
      if (_res.displayName != null) {
        if (_res.displayName!.length > 1) {
          data.addAll({'last_name': userName?[1]});
        }
      }
      loginResponse = await loginProvider.login(data);
      print('here3');
      if (loginResponse != null && loginResponse.statusCode == 200) {
        final resString = jsonEncode(loginResponse.data);
        await useData.setTokenData(resString);
        Provider.of<UserProvider>(context, listen: false).getUserPorifile();
      } else {
        Future.delayed(Duration.zero, () {
          showSnackBar(context);
        });
      }
    }
    loginProvider.setLoading(false);
    return loginResponse;
  }

  showSnackBar(BuildContext context) {
    SnackBar snackBar = const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Unable to login, something went wrong!'));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
