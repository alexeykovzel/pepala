import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pepala/core/providers/create_meeting.dart';
import 'package:pepala/widgets/custom_icons.dart';
import 'package:pepala/widgets/custom_buttons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pepala/widgets/google_map.dart';
import 'package:provider/provider.dart';

class SelectLocationPage extends StatefulWidget {
  const SelectLocationPage({Key? key}) : super(key: key);

  @override
  _SelectLocationPageState createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  PermissionStatus _permissionStatus = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();
    _requestPermission(Permission.locationWhenInUse);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ChangeNotifierProvider(
          create: (_) => MapModel(),
          child: Stack(
            children: [
              TrackerMap(
                locationEnabled: _permissionStatus == PermissionStatus.granted,
              ),
              _getCenterMark(),
              Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.only(bottom: 40),
                child: Consumer<CreateMeetingProvider>(
                  builder: (context, provider, child) => InkWell(
                    onTap: () => provider.selectLocation(context),
                    child: const BasicButtonContainer(text: 'Next'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Finds screen center coordinates using [MediaQuery]
  /// and returns a custom flying mark.
  Widget _getCenterMark() {
    Size screenSize = MediaQuery.of(context).size;
    double size = 40;

    return Positioned(
      top: (screenSize.height - size) / 2,
      left: (screenSize.width - size) / 2,
      child: CustomIcon.navGrey.build(size: size),
    );
  }

  /// Sends a request to a profile for a given permission.
  /// Then, it awaits profile's response and updates the permission status.
  Future<void> _requestPermission(Permission permission) async {
    final status = await permission.request();
    setState(() => _permissionStatus = status);
  }
}
