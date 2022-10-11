import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pepala/core/providers/auth/phone_auth.dart';
import 'package:pepala/widgets/widget_helper.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

class PinCodeModel extends ChangeNotifier with CodeAutoFill {
  final StreamController<ErrorAnimationType> _errorController;
  final TextEditingController _pinCodeController;
  final BuildContext context;
  String? _appSignature;
  bool _disposed = false;
  int _resendTime = 0;

  PinCodeModel(this.context)
      : _errorController = StreamController<ErrorAnimationType>.broadcast(),
        _pinCodeController = TextEditingController() {
    listenForCode();
    _resetTimer();

    /// Saves the app signature from the automatically filled code.
    SmsAutoFill().getAppSignature.then((s) => _appSignature = s);
  }

  @override
  void dispose() {
    super.dispose();
    _disposed = true;
  }

  /// Accepts the code that was filled automatically from the SMS.
  /// Then, starts the verification process for the code.
  @override
  void codeUpdated() {
    _pinCodeController.text = code!;
    verify(code!);
  }

  /// Verifies the verification code by the phone register.
  /// Otherwise, throws a unique code error defined by [PinCodeModel].
  void verify(String code) {
    context.read<PhoneAuthService>().completeCode(code, _throwCodeError);
    notifyListeners();
  }

  /// Resends the verification code (only if the timer is finished).
  /// Otherwise, notifies the user to wait for the timer.
  void resend() {
    if (_resendTime == 0) {
      context.read<PhoneAuthService>().resendToken(context);
      _resetTimer();
    } else {
      WidgetHelper.showToast("Wait for the timer");
    }
  }

  /// Implements an error animation in case the code
  /// filled by the user is wrong or invalid.
  void _throwCodeError(String msg) {
    _errorController.add(ErrorAnimationType.shake);
    WidgetHelper.showToast(msg);
  }

  /// Decrements the resending time every second.
  /// Then, updates all the widgets that use it.
  Future<void> _decrementTimer() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!_disposed) {
      _resendTime -= 1;
      notifyListeners();

      if (_resendTime != 0) {
        _decrementTimer();
      }
    }
  }

  /// Sets the timer start value and decrements it until 0.
  void _resetTimer() {
    _resendTime = 30;
    _decrementTimer();
  }

  get errorController => _errorController;

  get pinCodeController => _pinCodeController;

  get resendTime => _resendTime;
}
