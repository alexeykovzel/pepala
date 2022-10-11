import 'package:flutter/material.dart';
import 'package:pepala/pages/home/home.dart';
import 'package:pepala/core/routes.dart';
import 'package:pepala/core/providers/auth/google_auth.dart';
import 'package:pepala/core/providers/auth/phone_auth.dart';
import 'package:pepala/core/providers/auth/create_profile.dart';
import 'package:pepala/pages/loading.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late Future authFuture;

  @override
  void initState() {
    super.initState();
    authFuture = context.read<GoogleAuthService>().autoLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: authFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return const LoadingPage();

          case ConnectionState.done:
            bool hasProfile = snapshot.hasData ? snapshot.data as bool : false;

            if (hasProfile) {
              return const HomePage(index: 1);
            }

            return Consumer<Routes>(
              builder: (context, nav, child) => WillPopScope(
                onWillPop: () async => !await context.read<Routes>().popByLevel(NavLevel.auth),
                child: MultiProvider(
                  providers: [
                    ChangeNotifierProvider(create: (_) => PhoneAuthService()),
                    ChangeNotifierProvider(create: (_) => CreateProfileProvider()),
                  ],
                  child: Navigator(
                    key: nav.authKey,
                    initialRoute: AuthRoute.loginOptions.get().path,
                    onGenerateRoute: (RouteSettings settings) {
                      String path = settings.name!;
                      return MaterialPageRoute(
                        builder: AuthRouteGenerator.buildByPath(path),
                        settings: settings,
                      );
                    },
                  ),
                ),
              ),
            );
        }
      },
    );
  }
}
