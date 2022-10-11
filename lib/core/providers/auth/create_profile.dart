import 'dart:io';

import 'package:flutter/material.dart' hide Route;
import 'package:pepala/core/constants.dart';
import 'package:pepala/core/db/user_repository.dart';
import 'package:pepala/core/models/photo.dart';
import 'package:pepala/core/models/profile.dart';
import 'package:pepala/core/providers/user_data.dart';
import 'package:pepala/core/routes.dart';
import 'package:pepala/widgets/widget_helper.dart';
import 'package:provider/provider.dart';

class CreateProfileProvider extends ChangeNotifier {
  final nameField = AuthField(nextStep: AuthRoute.addBio.get());
  final bioField = AuthField(nextStep: AuthRoute.addProfilePhoto.get());
  final personalInfoField = AuthField(nextStep: AuthRoute.addHobbies.get());
  final educationField = AuthField(nextStep: AuthRoute.privacyPolicy.get());
  final _userRepository = UserRepository();
  var profile = Profile();

  final List<Hobby> hobbies = List.generate(
    UserDetails.hobbies.length,
    (i) => Hobby(UserDetails.hobbies[i]),
  );

  /// Checks a hobby that is being tapped.
  void checkHobby(String value) {
    hobbies.singleWhere((hobby) => hobby.value == value).check();
    notifyListeners();
  }

  /// Handles the uploading of the user photo, following with the skip choice page.
  void uploadPhoto(BuildContext context) {
    File? photo = context.read<PhotoModel>().imageFile;
    if (photo != null) {
      profile.photo = photo;
      context.read<Routes>().push(AuthRoute.skipChoice.get());
    }
  }

  /// Saves the user profile, following with the main screen on succeeding
  /// and returning to the auth options screen on failing.
  Future<void> finishProfile(BuildContext context) async {
    if (await createProfile(context)) {
      context.read<Routes>().pushReplacement(AppRoute.home.get());
    } else {
      context.read<Routes>().popUntil(AuthRoute.loginOptions.get());
      WidgetHelper.showToast('Failed to sign up');
    }
  }

  /// Creates the user profile and returns the result.
  Future<bool> createProfile(BuildContext context) async {
    // Save hobbies which were checked by the user
    profile.hobbies = hobbies.where((h) => h.isChecked == true).map((h) => h.value).toList();

    // Upload the profile photo
    if (profile.photo == null) return false;
    String? url = await _userRepository.uploadPhoto(profile.uid!, profile.photo!);

    // Store the photo url
    if (url == null) return false;
    profile.photoUrl = url;

    // Save the user profile
    context.read<UserData>().profile = profile;
    return await _userRepository.add(profile);
  }
}

class AuthField {
  var key = GlobalKey<FormState>();
  final Route nextStep;

  void handle(BuildContext context) {
    bool validated = key.currentState!.validate();
    if (validated) {
      FocusScope.of(context).unfocus();
      key.currentState!.save();
      context.read<Routes>().push(nextStep);
    }
  }

  AuthField({required this.nextStep});
}

class Hobby {
  final String value;
  bool isChecked = false;

  void check() => isChecked = !isChecked;

  Hobby(this.value);
}
