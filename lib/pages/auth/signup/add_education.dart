import 'package:flutter/material.dart';
import 'package:pepala/core/constants.dart';
import 'package:pepala/core/providers/auth/create_profile.dart';
import 'package:pepala/core/utils/field_validator.dart';
import 'package:pepala/widgets/custom_buttons.dart';
import 'package:pepala/widgets/form_fields.dart';
import 'package:provider/provider.dart';

class AddEducationPage extends StatelessWidget {
  const AddEducationPage({Key? key}) : super(key: key);

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
                  "The last step...",
                  style: TextStyle(fontSize: 28),
                  textAlign: TextAlign.center,
                ),
                const Expanded(flex: 1, child: SizedBox()),
                Form(
                  key: data.educationField.key,
                  child: Wrap(
                    runSpacing: 20,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              hintText: 'Course',
                              initialValue: data.profile.course,
                              onSaved: (val) => data.profile.course = val,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: FieldValidator.course,
                            ),
                          ),
                          const SizedBox(width: 15),
                          SizedBox(
                            width: 70,
                            child: CustomDropdownFormField(
                              hintText: 'Y',
                              value: data.profile.courseYear?.toString(),
                              onChanged: (val) =>
                                  data.profile.courseYear = int.parse(val!),
                              items: UserDetails.courseYears
                                  .map((val) => DropdownMenuItem(
                                      value: val, child: Text(val)))
                                  .toList(),
                            ),
                          )
                        ],
                      ),
                      CustomTextFormField(
                        hintText: 'University',
                        initialValue: data.profile.university,
                        onSaved: (val) => data.profile.university = val,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FieldValidator.university,
                      ),
                    ],
                  ),
                ),
                const Expanded(flex: 4, child: SizedBox()),
                NavigationButton(
                    nextText: 'Finish',
                    callback: data.educationField.handle),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
