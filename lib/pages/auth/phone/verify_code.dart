import 'package:flutter/material.dart';
import 'package:pepala/core/models/pincode.dart';
import 'package:pepala/core/routes.dart';
import 'package:pepala/widgets/form_fields.dart';
import 'package:provider/provider.dart';

class VerifyCodePage extends StatelessWidget {
  const VerifyCodePage({Key? key}) : super(key: key);

  void onBypass(BuildContext context) {
    context.read<Routes>().pushReplacement(AuthRoute.addProfilePhoto.get());
  }

  Widget getResendText(int resendTime) {
    if (resendTime != 0) {
      return RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 14),
          children: [
            const TextSpan(
              text: "You can resend code in ",
              style: TextStyle(color: Colors.black),
            ),
            TextSpan(
              text: resendTime.toString(),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const TextSpan(
              text: " seconds",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => PinCodeModel(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              const Text(
                'Enter code',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Consumer<PinCodeModel>(
                builder: (context, pinCode, child) {
                  return Column(
                    children: [
                      getResendText(pinCode.resendTime),
                      const SizedBox(height: 10),
                      PinCodeFormField(
                        controller: pinCode.pinCodeController,
                        errorController: pinCode.errorController,
                        onCompleted: pinCode.verify,
                      ),
                      TextButton(
                        onPressed: () => pinCode.resend(),
                        child: const Text(
                          "Send code again",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}
