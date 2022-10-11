import 'package:cloud_firestore/cloud_firestore.dart';

class MeetingModel {
  String? uid;
  String? type;
  List<String>? users;
  GeoPoint? location;

  Stream<QuerySnapshot<Map<String, dynamic>>> get requests {
    var requestsRef = FirebaseFirestore.instance.collection('requests');
    return requestsRef.where('meeting_uid', isEqualTo: uid).snapshots();
  }

  MeetingModel({this.type, this.location});
}
