import 'package:cloud_firestore/cloud_firestore.dart';

class JoinRequest {
  String meetingUid;
  String userUid;
  Timestamp sentTime;

  JoinRequest({
    required this.meetingUid,
    required this.userUid,
    required this.sentTime,
  });
}
