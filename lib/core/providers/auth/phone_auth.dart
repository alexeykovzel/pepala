import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pepala/core/routes.dart';
import 'package:pepala/pages/loading.dart';
import 'package:pepala/widgets/widget_helper.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';

class PhoneAuthService extends ChangeNotifier with AuthService {
  final _phoneKey = GlobalKey<FormState>();
  var _phone = PhoneNumber(isoCode: 'NL');
  var _isPhoneValidated = false;

  Function(String msg)? _throwCodeError;

  /// Waits for the profile to complete the verification code.
  Completer _completer = Completer();

  /// Data used to resend the verification code.
  int? _forceResendingToken;
  String? _verificationId;

  void onPhoneValidated(bool b) => _isPhoneValidated = b ? true : false;

  void onPhoneSaved(PhoneNumber val) => phone = val;

  void completeCode(String code, Function(String msg) error) {
    if (_completer.isCompleted) _completer = Completer();
    _throwCodeError = error;
    _completer.complete(code);
  }

  /// Resends the authentication token.
  void resendToken(BuildContext context) {
    verifyPhoneNumber(_phone.phoneNumber!, context);
  }

  /// Handles phone authentication.
  void handlePhoneAuth(BuildContext context) {
    if (_isPhoneValidated) {
      _phoneKey.currentState!.save();
      FocusScope.of(context).unfocus();
      context.read<Routes>().push(AuthRoute.verifyPhone.get());
      verifyPhoneNumber(_phone.phoneNumber!, context);
    } else {
      WidgetHelper.showToast('Invalid phone number');
    }
  }

  /// Verifies the phone number by sending a verification code
  /// and waiting for the user to fill it.
  Future<void> verifyPhoneNumber(String phoneNumber, BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    return await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          /// ANDROID ONLY!
          /// Sign the profile in with an auto-generated credential.
          await auth.signInWithCredential(credential);
          context.read<Routes>().pushReplacement(AuthRoute.addName.get());
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            WidgetHelper.showToast('Invalid phone number. Please try again');
            Navigator.maybePop(context);
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          _forceResendingToken = resendToken;
          _verificationId = verificationId;
          _acceptVerificationCode(context);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timed out...
        },
        forceResendingToken: _forceResendingToken);
  }

  /// Waits for the user to fill in the verification code.
  Future<void> _acceptVerificationCode(BuildContext context) async {
    /// Reset pin code completer
    if (_completer.isCompleted) _completer = Completer();

    /// Waits until the profile enters the code
    String code = (await _completer.future) as String;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: code,
    );

    /// Tries to sign in using the provided code.
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoadingPage()));
      authorizeUser(userCredential, context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        _throwCodeError!("Invalid pin code. Please try again");
        _acceptVerificationCode(context);
      } else {
        _throwCodeError!("Unknown error");
        Navigator.maybePop(context);
      }
    }
  }

  GlobalKey<FormState> get phoneKey => _phoneKey;

  PhoneNumber get phone => _phone;

  set phone(PhoneNumber value) {
    _phone = value;
    notifyListeners();
  }
}
