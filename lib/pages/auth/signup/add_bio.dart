import 'package:flutter/material.dart';
import 'package:pepala/core/providers/auth/create_profile.dart';
import 'package:pepala/core/utils/field_validator.dart';
import 'package:pepala/widgets/custom_buttons.dart';
import 'package:pepala/widgets/form_fields.dart';
import 'package:provider/provider.dart';

class AddBioPage extends StatelessWidget {
  const AddBioPage({Key? key}) : super(key: key);

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
                const SizedBox(height: 50),
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(color: Colors.black),
                    // style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(
                        text: "Let's get to\nknow you!\n",
                        style: TextStyle(fontSize: 28),
                      ),
                      TextSpan(
                        text: "(you can also fill it later)",
                        style: TextStyle(fontSize: 14),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                    padding: const EdgeInsets.only(left: 20, bottom: 5),
                    alignment: Alignment.centerLeft,
                    child: const Text('Bio', style: TextStyle(fontSize: 22))),
                Form(
                  key: data.bioField.key,
                  child: CustomTextFormField(
                    autoFocus: true,
                    hintText: 'Write something about you',
                    initialValue: data.profile.bio,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSaved: (val) => data.profile.bio = val,
                    validator: FieldValidator.bio,
                    hasCounter: true,
                    maxLength: 500,
                    minLines: 6,
                    maxLines: 6,
                  ),
                ),
                const Expanded(flex: 5, child: SizedBox()),
                NavigationButton(callback: data.bioField.handle),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
