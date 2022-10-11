import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pepala/core/models/meeting.dart';

class MeetingRepository {
  Future<bool> add(MeetingModel meeting) async {
    if (meeting.location == null || meeting.type == null) return false;

    var meetingsRef = FirebaseFirestore.instance.collection('meetings');
    return meetingsRef.add({
      'type': meeting.type,
      'location': meeting.location,
      'users': meeting.users,
      'status': 'waiting',
    }).then((value) {
      log("Successfully added meeting.");
      return true;
    }).catchError((error) {
      log("Failed to add meeting: $error");
      return false;
    });
  }

  Future<List<MeetingModel>> getByWaitingStatus() async {
    var meetingsRef = FirebaseFirestore.instance.collection('meetings');
    var waitingMeetings = meetingsRef.where('status', isEqualTo: 'waiting');
    return await waitingMeetings.get().then((QuerySnapshot snapshot) {
      List<MeetingModel> result = [];

      for (var doc in snapshot.docs) {
        result.add(MeetingModel(
          type: doc['type'],
          location: doc['location'],
        ));
      }

      return result;
    }).onError((error, stackTrace) => []);
  }

  Future<bool> delete(String uid) async {
    var meetingsRef = FirebaseFirestore.instance.collection('meetings');
    return meetingsRef.doc(uid).delete().then((value) {
      log("Successfully deleted meeting.");
      return true;
    }).catchError((error) {
      log("Failed to delete meeting: $error");
      return false;
    });
  }
}
