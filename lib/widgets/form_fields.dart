import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// Customizable text form field. Used mainly in the authentication.
class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final String? initialValue;
  final TextInputType? textInputType;
  final AutovalidateMode autovalidateMode;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String?)? onChanged;
  final Function(String?)? onSaved;
  final Function()? onTap;
  final bool readOnly;
  final bool digitsAllowed;
  final int minLines;
  final int maxLines;
  final int? maxLength;
  final bool? autoFocus;
  final bool hasCounter;

  const CustomTextFormField({
    Key? key,
    required this.hintText,
    this.initialValue,
    this.textInputType,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.onTap,
    this.readOnly = false,
    this.digitsAllowed = true,
    this.minLines = 1,
    this.maxLines = 1,
    this.maxLength,
    this.autoFocus,
    this.hasCounter = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      autofocus: autoFocus ?? false,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      initialValue: initialValue,
      keyboardType: textInputType,
      autovalidateMode: autovalidateMode,
      inputFormatters: [
        if (!digitsAllowed) FilteringTextInputFormatter.digitsOnly,
      ],
      validator: validator,
      onChanged: onChanged,
      onSaved: onSaved,
      onTap: onTap,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 15, 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

/// Dropdown field for a predefined choice of input.
class CustomDropdownFormField extends StatelessWidget {
  final List<DropdownMenuItem<String>> items;
  final Function(String? val)? onChanged;
  final Function(String? val)? onSaved;
  final String? hintText;
  final String? value;

  const CustomDropdownFormField({
    Key? key,
    required this.items,
    this.onChanged,
    this.onSaved,
    this.hintText,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      enableFeedback: true,
      value: value,
      icon: const Icon(Icons.keyboard_arrow_down),
      items: items,
      onChanged: onChanged,
      onSaved: onSaved,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 15, 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

/// Phone field that shows a country flag of a phone operator and
/// automatically formats the phone number correspondingly.
/// Also, it allows choosing a country by a DIALOG.
class PhoneFormField extends StatelessWidget {
  final TextEditingController? controller;
  final Function(PhoneNumber val)? onSaved;
  final Function(bool b)? onValidated;
  final PhoneNumber? initialValue;
  final String? errorMessage;
  final bool? autoFocus;

  const PhoneFormField({
    Key? key,
    this.controller,
    this.onSaved,
    this.onValidated,
    this.initialValue,
    this.errorMessage,
    this.autoFocus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      autoFocus: autoFocus ?? false,
      onSaved: onSaved,
      onInputValidated: onValidated,
      onInputChanged: (PhoneNumber number) => {},
      textFieldController: controller,
      spaceBetweenSelectorAndTextField: 2,
      errorMessage: errorMessage,
      selectorConfig: const SelectorConfig(
        selectorType: PhoneInputSelectorType.DIALOG,
      ),
      selectorTextStyle: const TextStyle(color: Colors.black),
      initialValue: initialValue ?? PhoneNumber(isoCode: "NL"),
      keyboardType: const TextInputType.numberWithOptions(
        signed: true,
        decimal: true,
      ),
      inputDecoration: InputDecoration(
        hintText: "Phone number",
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: const BorderSide(width: 2, color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: const BorderSide(width: 2, color: Colors.white),
        ),
      ),
    );
  }
}

/// Pin code field used for phone verification.
class PinCodeFormField extends StatelessWidget {
  final TextEditingController? controller;
  final StreamController<ErrorAnimationType>? errorController;
  final Function(String)? onCompleted;

  const PinCodeFormField({
    Key? key,
    this.controller,
    this.errorController,
    this.onCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
      child: PinCodeTextField(
        autoFocus: true,
        appContext: context,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        controller: controller,
        length: 6,
        pinTheme: PinTheme(
          fieldHeight: 50,
          fieldWidth: 40,
          shape: PinCodeFieldShape.box,
          selectedColor: Colors.black,
          selectedFillColor: Colors.white,
          activeColor: Colors.black26,
          activeFillColor: Colors.white,
          inactiveColor: Colors.black26,
          inactiveFillColor: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        animationDuration: const Duration(milliseconds: 300),
        showCursor: false,
        enableActiveFill: true,
        errorAnimationController: errorController,
        animationType: AnimationType.scale,
        keyboardType: TextInputType.number,
        onCompleted: onCompleted,
        onChanged: (value) {},
      ),
    );
  }
}
