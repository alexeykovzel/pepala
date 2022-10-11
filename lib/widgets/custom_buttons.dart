import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pepala/core/routes.dart';
import 'package:provider/provider.dart';

/// Button for bidirectional navigation (back and forth).
class TwinButton extends StatelessWidget {
  final Function(BuildContext) callback;
  final bool transparent;
  final Color textColor;
  final String text;

  const TwinButton({
    Key? key,
    this.textColor = Colors.black,
    this.transparent = false,
    required this.text,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 70,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: transparent ? Colors.transparent : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
        onPressed: () => callback(context),
        child: Center(
          child: Text(text, style: TextStyle(fontSize: 18, color: textColor)),
        ),
      ),
    );
  }
}

/// Button for navigation ONLY to the next step.
class NextButton extends StatelessWidget {
  final Function(BuildContext) callback;
  final String text;

  const NextButton({
    Key? key,
    required this.callback,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      )),
      onPressed: () => callback(context),
      child: Container(
        constraints: const BoxConstraints.expand(height: 50),
        child: Center(child: Text(text)),
      ),
    );
  }
}

/// Adaptable navigation depending on user platform.
/// [TwinButton]s for Android.
/// [NextButton] for Iphone.
class NavigationButton extends StatelessWidget {
  final Function(BuildContext) callback;
  final String nextText;
  final String backText;
  final NavLevel nav;

  const NavigationButton({
    Key? key,
    required this.callback,
    this.nextText = 'Next',
    this.backText = 'Back',
    this.nav = NavLevel.auth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TwinButton(
                text: backText,
                transparent: true,
                callback: (_) => context.read<Routes>().popByLevel(nav),
              ),
              TwinButton(
                text: nextText,
                textColor: Colors.white,
                callback: callback,
              ),
            ],
          )
        : NextButton(
            callback: callback,
            text: nextText,
          );
  }
}

/// Decoration for 'create profile' button (will be removed).
class BasicButtonContainer extends StatelessWidget {
  final String text;

  const BasicButtonContainer({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        text,
        style: const TextStyle(fontSize: 18),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

/// Button for choosing a sign in option.
/// e.g. Google, Facebook, Apple ID or phone.
class SignInButton extends StatelessWidget {
  final Function(BuildContext) callback;
  final Widget icon;
  final String text;

  const SignInButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 2,
            blurRadius: 10.0,
          )
        ],
      ),
      child: InkWell(
        onTap: () => callback(context),
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 20),
          leading: icon,
          title: Text(text),
        ),
      ),
    );
  }
}

class CustomNextButton extends StatelessWidget {
  final Function(BuildContext) callback;

  const CustomNextButton({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => callback(context),
      child: Container(
        child: const Center(
          child: Text(
            'Next',
            style: TextStyle(
              fontSize: 24,
              color: Color(0xff4070EA),
            ),
          ),
        ),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(blurRadius: 10, color: Colors.black26),
          ],
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          border: Border.all(
            width: 5,
            color: const Color(0xff4070EA),
          ),
        ),
      ),
    );
  }
}
