import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pepala/core/models/request.dart';

class RequestRepository {
  Future<bool> add(JoinRequest request) async {
    var requestsRef = FirebaseFirestore.instance.collection('requests');
    return requestsRef.add({
      'meeting_uid': request.meetingUid,
      'user_uid': request.userUid,
      'sent_time': request.sentTime,
    }).then((value) {
      log("Successfully added request.");
      return true;
    }).catchError((error) {
      log("Failed to add request: $error");
      return false;
    });
  }

  Future<bool> delete(String uid) async {
    var requestsRef = FirebaseFirestore.instance.collection('requests');
    return requestsRef.doc(uid).delete().then((value) {
      log("Successfully deleted request.");
      return true;
    }).catchError((error) {
      log("Failed to delete request: $error");
      return false;
    });
  }

  Future<List<JoinRequest>> getByUserUid(String userUid) async {
    var requestsRef = FirebaseFirestore.instance.collection('requests');
    return await requestsRef
        .where('user_uid', isEqualTo: userUid)
        .orderBy('sent_time')
        .get()
        .then((QuerySnapshot querySnapshot) {
      List<JoinRequest> result = [];
      
      for (var doc in querySnapshot.docs) {
        result.add(
          JoinRequest(
            meetingUid: doc['meeting_uid'],
            userUid: doc['user_uid'],
            sentTime: doc['sent_time'],
          ),
        );
      }
      return result;
    }).catchError((error) {
      return [] as List<JoinRequest>;
    });
  }
}
