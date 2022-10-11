import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pepala/core/db/user_repository.dart';
import 'package:pepala/core/models/profile.dart';
import 'package:pepala/core/routes.dart';
import 'package:provider/provider.dart';
import 'create_profile.dart';

class AuthService {
  final _userRepository = UserRepository();

  /// Completes the authorization by loading or finishing the user profile.
  Future<void> authorizeUser(UserCredential userCredential, BuildContext context) async {
    User user = userCredential.user!;
    if (await hasProfile(userCredential)) {
      await loadProfile(user, context);
    } else {
      finishProfile(user, context);
    }
  }

  /// Loads the user profile and then proceeds with the main page.
  Future<void> loadProfile(User user, BuildContext context) async {
    Profile? profile = await _userRepository.get(user.uid);
    if (profile != null) {
      context.read<CreateProfileProvider>().profile = profile;
      context.read<Routes>().pushReplacement(AppRoute.home.get());
    }
  }

  /// Finishes the user profile by loading the data from the auth that was used
  /// for authorization. Then, proceeds with the first page for sign up.
  void finishProfile(User user, BuildContext context) {
    context.read<CreateProfileProvider>().profile = Profile(
      uid: user.uid,
      name: user.displayName,
      photoUrl: user.photoURL,
      phone: user.phoneNumber,
      email: user.email
    );

    context.read<Routes>().pushReplacement(AuthRoute.addName.get());
  }

  /// Checks if the profile exists by user credential.
  Future<bool> hasProfile(UserCredential credential) async {
    if (credential.additionalUserInfo!.isNewUser) return false;
    return await _userRepository.exists(credential.user!.uid);
  }
}
