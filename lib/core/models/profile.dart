import 'dart:io';

class Profile {
  /// If the profile has an [uid], he/she passed the authentication process,
  /// though might have missed the part of filling profile details.
  String? uid;

  /// from [GetStartedPage]
  String? name;
  String? bio;

  /// from [AddProfilePhotoPage]
  File? photo;
  String? photoUrl;

  /// from [AddPersonalInfoPage]
  String? nationality;
  String? gender;
  int? age;

  /// from [AddEducationPage]
  String? university;
  String? course;
  int? courseYear;

  /// from [AddHobbiesPage]
  List<String>? hobbies;

  // probably not needed
  String? phone;
  String? email;

  Profile({
    this.uid,
    this.name,
    this.bio,
    this.photo,
    this.photoUrl,
    this.age,
    this.nationality,
    this.gender,
    this.university,
    this.course,
    this.courseYear,
    this.hobbies,
    this.phone,
    this.email,
  });

  @override
  String toString() {
    return '''name: $name"
        bio: $bio
        nationality: $nationality
        gender: $gender
        age: $age
        university: $university
        course: $course
        course year: $courseYear
        hobbies: $hobbies
        phone: $phone''';
  }
}