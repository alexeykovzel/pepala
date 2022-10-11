import 'package:flutter/material.dart';
import 'package:pepala/core/providers/create_meeting.dart';
import 'package:pepala/core/routes.dart';
import 'package:provider/provider.dart';

class CreateMeetingPage extends StatelessWidget {
  const CreateMeetingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await context.read<Routes>().popByLevel(NavLevel.createMeeting),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CreateMeetingProvider()),
        ],
        child: Navigator(
          key: context.read<Routes>().createMeetingKey,
          initialRoute: CreateMeetingRoute.selectLocation.get().path,
          onGenerateRoute: (RouteSettings settings) {
            String? path = settings.name!;
            return MaterialPageRoute<void>(
              builder: CreateMeetingRouteGenerator.buildByPath(path),
              settings: settings,
            );
          },
        ),
      ),
    );
  }
}
