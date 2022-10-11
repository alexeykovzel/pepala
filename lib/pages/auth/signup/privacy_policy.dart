import 'package:flutter/material.dart';
import 'package:pepala/core/routes.dart';
import 'package:pepala/core/providers/auth/create_profile.dart';
import 'package:pepala/widgets/custom_buttons.dart';
import 'package:provider/provider.dart';

class AcceptPrivacyPolicyPage extends StatelessWidget {
  const AcceptPrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const Text(
                'Privacy notice',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const Expanded(child: SizedBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TwinButton(
                    text: 'Cancel',
                    transparent: true,
                    callback: (_) =>
                        context.read<Routes>().popUntil(AuthRoute.loginOptions.get()),
                  ),
                  TwinButton(
                    text: 'Accept',
                    textColor: Colors.white,
                    callback: context.read<CreateProfileProvider>().finishProfile,
                  ),
                ],
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
