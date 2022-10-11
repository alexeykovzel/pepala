import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:provider/provider.dart';

import 'core/db/firebase_options.dart';
import 'core/providers/user_data.dart';
import 'core/providers/auth/google_auth.dart';
import 'core/theme.dart';
import 'core/routes.dart';

/// flutter run --route=/{page_name}    - to start with a selected page.

Future<void> main() async {
  /// Firebase requires the flutter native code to be initialized beforehand.
  /// As this process is asynchronous, we ensure that it happens in order.
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialization of the db before running the app.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserData()),
        Provider(create: (_) => GoogleAuthService()),
        Provider(create: (_) => Routes()),
      ],
      child: const MyApp(),
    ),
  );
}

/// Initialization of the material app.
class MyApp extends StatelessWidget {
  final bool isTestMode = false;

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Pepala',
        theme: buildShrineTheme(),
        navigatorKey: context.read<Routes>().appKey,
        initialRoute: isTestMode
            ? AppRoute.createMeeting.get().path
            : AppRoute.auth.get().path,
        routes: AppRouteGenerator.all);
  }
}
