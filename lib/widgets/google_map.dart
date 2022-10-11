import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pepala/core/db/meeting_repository.dart';
import 'package:pepala/core/models/meeting.dart';
import 'package:provider/provider.dart';

class MapModel extends ChangeNotifier {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final CameraPosition initPos = _kTwenteCampus;
  late GoogleMapController controller;
  MarkerId? selectedMarker;
  LatLng? markerPosition;
  int _markerIdCounter = 1;

  void _onCreated(GoogleMapController controller) async {
    // dark mode is turned off for now
    // map._loadMapStyle().then((_) => controller.setMapStyle(map.style));
    this.controller = controller;
    
    List<MeetingModel> meetings = await MeetingRepository().getByWaitingStatus();
    for (var meeting in meetings) {
      GeoPoint location = meeting.location!;
      _add(location.latitude, location.longitude);
    }
  }

  void _onMarkerTapped(MarkerId markerId) {
    final Marker? tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      final MarkerId? previousMarkerId = selectedMarker;
      if (previousMarkerId != null && markers.containsKey(previousMarkerId)) {
        final Marker resetOld = markers[previousMarkerId]!.copyWith(
          iconParam: BitmapDescriptor.defaultMarker,
        );
        markers[previousMarkerId] = resetOld;
      }
      selectedMarker = markerId;
      final Marker newMarker = tappedMarker.copyWith(
        iconParam: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen,
        ),
      );
      markers[markerId] = newMarker;
      markerPosition = null;
      notifyListeners();
    }
  }

  void _add(double latitude, double longitude) {
    final String markerIdVal = 'marker_id_$_markerIdCounter';
    final MarkerId markerId = MarkerId(markerIdVal);
    _markerIdCounter++;

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () => _onMarkerTapped(markerId),
    );

    markers[markerId] = marker;
    notifyListeners();
  }

  void _remove(MarkerId markerId) {
    if (markers.containsKey(markerId)) {
      markers.remove(markerId);
      notifyListeners();
    }
  }

  void _changePosition(MarkerId markerId, double latitude, double longitude) {
    final Marker marker = markers[markerId]!;
    final LatLng current = marker.position;
    final Offset offset = Offset(
      latitude - current.latitude,
      longitude - current.longitude,
    );
    markers[markerId] = marker.copyWith(
      positionParam: LatLng(
        latitude + offset.dy,
        longitude + offset.dx,
      ),
    );
    notifyListeners();
  }

  void _changeAnchor(MarkerId markerId) {
    final Marker marker = markers[markerId]!;
    final Offset currentAnchor = marker.anchor;
    final Offset newAnchor = Offset(1.0 - currentAnchor.dy, currentAnchor.dx);
    markers[markerId] = marker.copyWith(
      anchorParam: newAnchor,
    );
    notifyListeners();
  }

  void _setMarkerIcon(MarkerId markerId, BitmapDescriptor assetIcon) {
    final Marker marker = markers[markerId]!;
    markers[markerId] = marker.copyWith(iconParam: assetIcon);
    notifyListeners();
  }

  Future<BitmapDescriptor> _getAssetIcon(BuildContext context) async {
    final Completer<BitmapDescriptor> bitmapIcon = Completer<BitmapDescriptor>();
    final ImageConfiguration config = createLocalImageConfiguration(context);

    const AssetImage('assets/red_square.png').resolve(config).addListener(
      ImageStreamListener(
        (ImageInfo image, bool sync) async {
          final ByteData? bytes = await image.image.toByteData(format: ImageByteFormat.png);
          if (bytes == null) {
            bitmapIcon.completeError(Exception('Unable to encode icon'));
            return;
          }
          final BitmapDescriptor bitmap = BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
          bitmapIcon.complete(bitmap);
        },
      ),
    );

    return await bitmapIcon.future;
  }

  Future<LatLng> getLatLng(ScreenCoordinate coordinate) async =>
      await controller.getLatLng(coordinate);

  Future<LatLng> getMapPoint(ScreenCoordinate coordinate) async =>
      await controller.getLatLng(coordinate);

  /// Loads a dark mode configuration for the map.
  Future<String> _loadMapStyle() async =>
      await rootBundle.loadString('assets/config/map_dark_mod.json');

  /// Returns [CameraPosition] of the UT campus.
  static const CameraPosition _kTwenteCampus = CameraPosition(
    target: LatLng(52.24384458934532, 6.852143369843881),
    zoom: 15,
  );
}

class TrackerMap extends StatelessWidget {
  static const LatLng center = LatLng(-33.86711, 151.1947171);
  final bool locationEnabled;
  final GeoPoint? initialPosition;

  CameraPosition pointTo(GeoPoint geoPoint) {
    return CameraPosition(
      zoom: 15,
      target: LatLng(
        geoPoint.latitude,
        geoPoint.longitude,
      ),
    );
  }

  const TrackerMap({
    Key? key,
    this.locationEnabled = false,
    this.initialPosition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MapModel>(
      builder: (context, data, child) => Stack(
        children: [
          GoogleMap(
            myLocationEnabled: locationEnabled,
            myLocationButtonEnabled: locationEnabled,
            markers: Set<Marker>.of(data.markers.values),
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition:
                initialPosition == null ? data.initPos : pointTo(initialPosition!),
            onMapCreated: data._onCreated,
          ),
          Visibility(
            visible: data.markerPosition != null,
            child: Container(
              color: Colors.white70,
              height: 30,
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  data.markerPosition == null
                      ? Container()
                      : Expanded(child: Text("lat: ${data.markerPosition!.latitude}")),
                  data.markerPosition == null
                      ? Container()
                      : Expanded(child: Text("lng: ${data.markerPosition!.longitude}")),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
