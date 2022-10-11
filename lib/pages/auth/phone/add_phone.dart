import 'package:flutter/material.dart';
import 'package:pepala/core/providers/auth/phone_auth.dart';
import 'package:pepala/widgets/custom_buttons.dart';
import 'package:pepala/widgets/form_fields.dart';
import 'package:provider/provider.dart';

class AddPhonePage extends StatelessWidget {
  const AddPhonePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromRGBO(58, 81, 252, 100),
                    Color.fromRGBO(133, 58, 252, 100),
                    Color.fromRGBO(133, 58, 252, 100),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 180,
                decoration: const BoxDecoration(
                  // color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                    ),
                    BoxShadow(
                      color: Colors.white,
                      spreadRadius: -6.0,
                      blurRadius: 4.0,
                    ),
                    BoxShadow(
                      color: Colors.white,
                      spreadRadius: -6.0,
                      blurRadius: 4.0,
                      offset: Offset(0, 6),
                    ),
                    BoxShadow(
                      color: Colors.white,
                      spreadRadius: -6.0,
                      blurRadius: 4.0,
                      offset: Offset(4, 6),
                    ),
                    BoxShadow(
                      color: Colors.white,
                      spreadRadius: -6.0,
                      blurRadius: 4.0,
                      offset: Offset(-4, 6),
                    ),
                  ],
                  borderRadius: BorderRadius.vertical(
                    top: Radius.elliptical(100, 60),
                  ),
                ),
              ),
            ),
            Consumer<PhoneAuthService>(
              builder: (context, service, child) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Form(
                  key: service.phoneKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      const Text(
                        "Welcome!",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 60),
                      PhoneFormField(
                        autoFocus: true,
                        errorMessage: null,
                        initialValue: service.phone,
                        onSaved: service.onPhoneSaved,
                        onValidated: service.onPhoneValidated,
                      ),
                      const Expanded(flex: 4, child: SizedBox()),
                      SizedBox(
                        height: 60,
                        child: CustomNextButton(
                          callback: service.handlePhoneAuth,
                        ),
                      ),
                      const SizedBox(height: 60)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
