import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pepala/core/models/meeting.dart';
import 'package:pepala/core/models/profile.dart';

class UserData extends ChangeNotifier {
  MeetingModel? _currentMeeting;
  Profile? profile;

  MeetingModel? get currentMeeting => _currentMeeting;

  set currentMeeting(MeetingModel? meeting) {
    _currentMeeting = meeting;
    notifyListeners();
  }

  Future<void> leaveMeeting() async {
    currentMeeting = null;

    // TODO: Update database.
    await Future.delayed(const Duration(seconds: 1));
  }
}
