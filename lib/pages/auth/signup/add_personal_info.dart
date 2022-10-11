import 'package:flutter/material.dart';
import 'package:pepala/core/constants.dart';
import 'package:pepala/core/providers/auth/create_profile.dart';
import 'package:pepala/core/utils/field_validator.dart';
import 'package:pepala/widgets/custom_buttons.dart';
import 'package:pepala/widgets/form_fields.dart';
import 'package:provider/provider.dart';

class AddPersonalInfoPage extends StatelessWidget {
  const AddPersonalInfoPage({Key? key}) : super(key: key);

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
                const Text(
                  "Personal Information",
                  style: TextStyle(fontSize: 26),
                  textAlign: TextAlign.center,
                ),
                const Expanded(flex: 1, child: SizedBox()),
                SizedBox(
                  height: 280,
                  child: Form(
                    key: data.personalInfoField.key,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomTextFormField(
                          hintText: 'Enter your nationality',
                          initialValue: data.profile.nationality,
                          onSaved: (val) => data.profile.nationality = val,
                          validator: FieldValidator.nationality,
                        ),
                        CustomTextFormField(
                            hintText: 'Enter your age',
                            initialValue: '${data.profile.age ?? ''}',
                            onSaved: (val) =>
                                data.profile.age = int.tryParse(val!),
                            validator: FieldValidator.age),
                        CustomDropdownFormField(
                          hintText: 'Choose your gender',
                          value: data.profile.gender,
                          onChanged: (val) => data.profile.gender = val,
                          items: UserDetails.genders
                              .map((gender) => DropdownMenuItem(
                                  value: gender, child: Text(gender)))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const Expanded(flex: 4, child: SizedBox()),
                NavigationButton(callback: data.personalInfoField.handle),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
