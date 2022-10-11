import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pepala/core/routes.dart';
import 'package:pepala/core/providers/auth/google_auth.dart';
import 'package:pepala/widgets/custom_icons.dart';
import 'package:pepala/widgets/custom_buttons.dart';
import 'package:provider/provider.dart';

class LoginOptionsPage extends StatelessWidget {
  const LoginOptionsPage({Key? key}) : super(key: key);

  void onSkipAuth(BuildContext context) {
    context.read<Routes>().pushReplacement(AppRoute.home.get());
  }

  void onGoogleLogin(BuildContext context) {
    context.read<GoogleAuthService>().handleSignIn(context);
  }

  void onAppleLogin(BuildContext context) {
    context.read<Routes>().pushReplacement(AppRoute.home.get());
  }

  void onPhoneLogin(BuildContext context) {
    context.read<Routes>().push(AuthRoute.phoneAuth.get());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SvgPicture.asset(
            "assets/background/login_screen.svg",
            alignment: Alignment.center,
            fit: BoxFit.fill,
          ),
          Column(
            children: [
              const SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIcon.pepala.build(size: 70),
                  const Text(
                    "Pepala",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SignInButton(
                icon: const Icon(Icons.skip_next, size: 30),
                text: "Sign in as a quest",
                callback: onSkipAuth,
              ),
              SignInButton(
                icon: CustomIcon.google.build(size: 30),
                text: "Log in with Google",
                callback: onGoogleLogin,
              ),
              if (Platform.isIOS)
                SignInButton(
                  icon: CustomIcon.apple.build(size: 30),
                  text: "Log in with Apple ID",
                  callback: onAppleLogin,
                ),
              SignInButton(
                icon: CustomIcon.phone.build(size: 25),
                text: "Log in with phone",
                callback: onPhoneLogin,
              ),
              const SizedBox(height: 80),
            ],
          ),
        ],
      ),
    );
  }
}
