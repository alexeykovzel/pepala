import 'package:flutter/material.dart';
import 'package:pepala/widgets/meeting_type.dart';

class UserDetails {
  static const List<String> genders = ['Male', 'Female', 'Other'];

  static const List<String> courseYears = ['1', '2', '3'];

  static const List<String> hobbies = ['music', 'chess', 'sports', 'smoke', 'dance', 'coffee'];
}

class MeetingDetails {
  static const types = [
    MeetingType(value: 'Coffee', icon: Icon(Icons.coffee)),
    MeetingType(value: 'Volleyball', icon: Icon(Icons.sports_volleyball)),
    MeetingType(value: 'Procrastination', icon: Icon(Icons.phone_iphone)),
    MeetingType(value: 'Chilling', icon: Icon(Icons.bed)),
    MeetingType(value: 'Suicide', icon: Icon(Icons.restaurant)),
    MeetingType(value: 'Coffee', icon: Icon(Icons.coffee)),
    MeetingType(value: 'Volleyball', icon: Icon(Icons.sports_volleyball)),
    MeetingType(value: 'Procrastination', icon: Icon(Icons.phone_iphone)),
    MeetingType(value: 'Chilling', icon: Icon(Icons.bed)),
    MeetingType(value: 'Suicide', icon: Icon(Icons.restaurant)),
  ];
}
