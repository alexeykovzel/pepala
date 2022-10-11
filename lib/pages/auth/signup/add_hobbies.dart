import 'package:flutter/material.dart';
import 'package:pepala/core/routes.dart';
import 'package:pepala/core/providers/auth/create_profile.dart';
import 'package:pepala/widgets/custom_buttons.dart';
import 'package:provider/provider.dart';

class AddHobbiesPage extends StatelessWidget {
  const AddHobbiesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Consumer<CreateProfileProvider>(
              builder: (context, data, child) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  const Text(
                    "Choose your hobbies\nand interests:",
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Flexible(
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: data.hobbies.map((hobby) => _HobbyButton(hobby)).toList(),
                    ),
                  ),
                  NavigationButton(
                    callback: (_) => context.read<Routes>().push(AuthRoute.addEducation.get()),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HobbyButton extends StatelessWidget {
  final Hobby hobby;

  const _HobbyButton(
    this.hobby, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<CreateProfileProvider>().checkHobby(hobby.value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        width: 50,
        height: 20,
        child: Center(
          child: Text(
            hobby.value,
            textAlign: TextAlign.center,
          ),
        ),
        color: hobby.isChecked ? Colors.black26 : Colors.black12,
      ),
    );
  }
}
