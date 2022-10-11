import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pepala/core/db/user_repository.dart';
import 'package:pepala/core/models/profile.dart';
import 'package:pepala/core/providers/user_data.dart';
import 'package:pepala/pages/loading.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';

class GoogleAuthService with AuthService {
  final _userRepository = UserRepository();
  final _googleSignIn = GoogleSignIn();

  /// Handles the user signing in with their google account.
  Future<void> handleSignIn(BuildContext context) async {
    GoogleSignInAccount? currentUser = _googleSignIn.currentUser;

    currentUser ??= await _googleSignIn.signInSilently();
    currentUser ??= await _googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await currentUser?.authentication;

    if (googleAuth != null) {
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, authorize user profile
      Navigator.push(context, MaterialPageRoute(builder: (_) => const LoadingPage()));
      UserCredential user = await FirebaseAuth.instance.signInWithCredential(credential);
      authorizeUser(user, context);
    }
  }

  /// Tries to auto login the user by their google account.
  /// Returns true if successfully logged in, false otherwise.
  Future<bool> autoLogin(BuildContext context) async {
    GoogleSignInAccount? googleUser = _googleSignIn.currentUser;
    googleUser ??= await _googleSignIn.signInSilently();
    User? currentUser = FirebaseAuth.instance.currentUser;

    // For testing
    await Future.delayed(const Duration(seconds: 1));

    // Stop auto login if the user profile is missing
    if (googleUser == null || currentUser == null) return false;
    Profile? profile = await _userRepository.get(currentUser.uid);
    if (profile == null) return false;

    // Save the profile data into the local db.
    context.read<UserData>().profile = profile;
    return true;
  }

  /// Handles the user signing out from their profile.
  Future<void> handleSignOut() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
  }
}
