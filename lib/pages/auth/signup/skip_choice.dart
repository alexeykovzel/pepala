import 'package:flutter/material.dart';
import 'package:pepala/core/routes.dart';
import 'package:pepala/widgets/custom_buttons.dart';
import 'package:provider/provider.dart';

class SkipChoicePage extends StatelessWidget {
  const SkipChoicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(child: SizedBox()),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(color: Colors.black),
                  // style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                      text: "Do you want to add\nmore information\nright now?\n\n",
                      style: TextStyle(fontSize: 28),
                    ),
                    TextSpan(
                      text: "Tip: it will help you find\nmore connections",
                      style: TextStyle(fontSize: 22),
                    )
                  ],
                ),
              ),
              const Expanded(child: SizedBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TwinButton(
                    text: 'Later',
                    transparent: true,
                    callback: (_) =>
                        context.read<Routes>().push(AuthRoute.privacyPolicy.get()),
                  ),
                  TwinButton(
                    text: 'Sure',
                    textColor: Colors.white,
                    callback: (_) =>
                        context.read<Routes>().push(AuthRoute.addPersonalInfo.get()),
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
