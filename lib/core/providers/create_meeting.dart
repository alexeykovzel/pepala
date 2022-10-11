import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pepala/core/constants.dart';
import 'package:pepala/core/db/meeting_repository.dart';
import 'package:pepala/core/models/meeting.dart';
import 'package:pepala/core/routes.dart';
import 'package:pepala/widgets/google_map.dart';
import 'package:pepala/widgets/meeting_type.dart';
import 'package:pepala/widgets/widget_helper.dart';
import 'package:provider/provider.dart';

import 'user_data.dart';

class CreateMeetingProvider extends ChangeNotifier {
  final MeetingRepository _meetingRepository = MeetingRepository();
  final MeetingModel _meeting = MeetingModel();
  List<MeetingType> searchResult = MeetingDetails.types;

  /// Changes the search result based on the text in the search field.
  void onSearchTextChanged(String text) {
    searchResult = MeetingDetails.types.where((t) => t.value.contains(text)).toList();
    notifyListeners();
  }

  /// Handles the meeting type selection. First, by saving the data,
  /// and then finishing the meeting creation as it is the last step.
  Future<void> selectType(BuildContext context, int index) async {
    _meeting.type = searchResult[index].value;
    await context.read<Routes>().transitPop(_createMeeting(context));
  }

  /// Handles the meeting location selection. First, by locating the 
  /// geo point in the center of the screen and storing it, and then
  /// pushing the next page for the meeting creation.
  Future<void> selectLocation(BuildContext context) async {
    _meeting.location = await _locateCenter(context);
    context.read<Routes>().push(CreateMeetingRoute.selectType.get());
  }

  /// Handles the meeting creation. First, by storing the data about the 
  /// meeting into the local memory, and then proceeding with the main page.
  Future<void> _createMeeting(BuildContext context) async{
    // Try to save the meeting into the database
    _meeting.users = [FirebaseAuth.instance.currentUser!.uid];
    bool saved = await _meetingRepository.add(_meeting);

    // Store the data into the local memory on success
    if (saved) {
      context.read<UserData>().currentMeeting = _meeting;
      // TODO: Notify the opposite person.
    } else {
      WidgetHelper.showToast('Oops.. Failed to create the meeting');
    }
  }

  /// Locates the geo point on the map in the center of the screen.
  Future<GeoPoint> _locateCenter(BuildContext context) async {
    ScreenCoordinate screenCoordinate = _getScreenCenter(context);
    LatLng latLng = await context.read<MapModel>().getLatLng(screenCoordinate);
    return GeoPoint(latLng.latitude, latLng.longitude);
  }

  /// Returns a center point on a screen in the [GoogleMap]'s view.
  ScreenCoordinate _getScreenCenter(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    int x = screenSize.width ~/ 2;
    int y = screenSize.height ~/ 2;
    ScreenCoordinate screenCoordinate = ScreenCoordinate(x: x, y: y);
    return screenCoordinate;
  }
}
