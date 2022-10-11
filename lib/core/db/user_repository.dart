import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pepala/core/models/profile.dart';

class UserRepository {
  /// Saves the user profile into the firestore under the authorization UID.
  Future<bool> add(Profile user) async {
    if (user.name == null) return false;
    if (user.photoUrl == null) return false;

    var usersRef = FirebaseFirestore.instance.collection('users');
    return usersRef.doc(user.uid).set({
      'uid': user.uid,
      'name': user.name,
      'bio': user.bio,
      'nationality': user.nationality,
      'gender': user.gender,
      'age': user.age,
      'university': user.university,
      'course': user.course,
      'course_year': user.courseYear,
      'hobbies': user.hobbies,
      'photo_url': user.photoUrl,
    }).then((value) {
      log('Successfully added user.');
      return true;
    }).catchError((error) {
      log('Failed to add user: $error');
      return false;
    });
  }

  /// Returns the future of the user profile by the provided uid.
  Future<Profile?> get(String uid) async {
    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
    QuerySnapshot snapshot = await usersRef.where('uid', isEqualTo: uid).get();
    if (snapshot.docs.isEmpty) return null;
    var user = snapshot.docs.first;

    return Profile(
      uid: user.get('uid'),
      name: user.get('name'),
      bio: user.get('bio'),
      nationality: user.get('nationality'),
      gender: user.get('gender'),
      age: user.get('age'),
      university: user.get('university'),
      course: user.get('course'),
      courseYear: user.get('course_year'),
      hobbies: List<String>.from(user.get('hobbies')),
      photoUrl: user.get('photo_url'),
    );
  }

  /// Checks if the user profile exists under the provided uid.
  Future<bool> exists(String uid) async {
    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
    QuerySnapshot snapshot = await usersRef.where('uid', isEqualTo: uid).get();
    return snapshot.docs.isEmpty ? false : true;
  }

  /// Uploads a profile photo of the user under the provided uid.
  /// Then, returns its download url on the firestore.
  Future<String?> uploadPhoto(String uid, File file) async {
    try {
      String photoPath = 'users/$uid/profile-photo.jpg';
      Reference photoRef = FirebaseStorage.instance.ref(photoPath);
      TaskSnapshot snapshot = await photoRef.putFile(file);
      return snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      if (e.code == 'canceled') log('Upload error: $e');
      return null;
    }
  }

  /// For using within widgets:
  /// Image.network([downloadURL]);
  Future<String?> getPhotoURL(String uid) async {
    String photoPath = 'users/$uid/profile-photo.jpg';
    return await FirebaseStorage.instance.ref(photoPath).getDownloadURL();
  }
}
