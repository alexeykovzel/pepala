import 'package:flutter/material.dart';
import 'package:pepala/core/providers/auth/create_profile.dart';
import 'package:pepala/core/utils/field_validator.dart';
import 'package:pepala/widgets/custom_buttons.dart';
import 'package:pepala/widgets/form_fields.dart';
import 'package:provider/provider.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Consumer<CreateProfileProvider>(
            builder: (context, data, child) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                const Text(
                  "First, what is\nyour name?",
                  style: TextStyle(fontSize: 28),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                Form(
                  key: data.nameField.key,
                  child: CustomTextFormField(
                    hintText: 'Name',
                    autoFocus: true,
                    initialValue: data.profile.name,
                    textInputType: TextInputType.name,
                    onSaved: (val) => data.profile.name = val!.trim(),
                    validator: FieldValidator.name,
                  ),
                ),
                const Expanded(child: SizedBox()),
                NavigationButton(callback: data.nameField.handle),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
