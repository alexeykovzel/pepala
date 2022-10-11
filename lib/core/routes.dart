import 'package:flutter/material.dart';
import '/pages/auth/auth_nav.dart';
import '/pages/auth/auth_options.dart';
import '/pages/auth/phone/add_phone.dart';
import '/pages/auth/phone/verify_code.dart';
import '/pages/auth/signup/add_bio.dart';
import '/pages/auth/signup/add_education.dart';
import '/pages/auth/signup/add_hobbies.dart';
import '/pages/auth/signup/add_name.dart';
import '/pages/auth/signup/add_personal_info.dart';
import '/pages/auth/signup/add_profile_photo.dart';
import '/pages/auth/signup/privacy_policy.dart';
import '/pages/auth/signup/skip_choice.dart';
import '/pages/home/home.dart';
import '/pages/home/meeting/create_meeting/create_meeting_nav.dart';
import '/pages/home/meeting/create_meeting/select_location.dart';
import '/pages/home/meeting/create_meeting/select_meeting_type.dart';
import '/pages/home/meeting/edit_meeting.dart';
import '/pages/home/meeting/user_overview.dart';
import '/pages/loading.dart';

enum NavLevel { app, auth, createMeeting }

class Routes {
  final appKey = GlobalKey<NavigatorState>();
  final authKey = GlobalKey<NavigatorState>();
  final createMeetingKey = GlobalKey<NavigatorState>();

  /// Returns a navigator instance by its unique identifier.
  NavigatorState getNavigator(NavLevel nav) {
    switch (nav) {
      case NavLevel.app:
        return appKey.currentState!;
      case NavLevel.auth:
        return authKey.currentState!;
      case NavLevel.createMeeting:
        return createMeetingKey.currentState!;
    }
  }

  Future<void> transit(Future future, Route route) async {
    push(AppRoute.loading.get());
    await future;
    pushReplacement(route);
  }

  Future<void> transitPop(Future future) async {
    pushReplacement(AppRoute.loading.get());
    await future;
    popByLevel(NavLevel.app);
  }

  /// If the navigator reaches its limit, it gets terminated.
  /// Otherwise. it pops the current page.
  Future<bool> popByLevel(NavLevel level) async {
    return await getNavigator(level).maybePop();
  }

  /// Namely pushes the page by its unique identifier.
  void push(Route route) async {
    await getNavigator(route.level).push(MaterialPageRoute(builder: route.builder));
  }

  /// Namely replaces the current page by its unique identifier.
  void pushReplacement(Route route) async {
    await getNavigator(route.level).pushReplacement(MaterialPageRoute(builder: route.builder));
  }

  /// Pops until there is a match of route paths.
  void popUntil(Route route) {
    getNavigator(route.level).popUntil((r) => r.settings.name == route.path);
  }
}

enum AppRoute {
  home,
  auth,
  test,
  loading,
  createMeeting,
  userOverview,
  editMeeting,
}

enum AuthRoute {
  loginOptions,
  phoneAuth,
  verifyPhone,
  skipChoice,
  addName,
  addBio,
  addProfilePhoto,
  addPersonalInfo,
  addHobbies,
  addEducation,
  privacyPolicy,
}

enum CreateMeetingRoute {
  selectLocation,
  selectType,
}

extension AppRouteGenerator on AppRoute {
  static const NavLevel _level = NavLevel.app;

  Route get({index}) {
    switch (this) {
      case AppRoute.home:
        return Route('/', (_) => HomePage(index: index ?? 1), _level);
      case AppRoute.auth:
        return Route('auth', (_) => const AuthPage(), _level);
      case AppRoute.loading:
        return Route('loading', (_) => const LoadingPage(), _level);
      case AppRoute.test:
        return Route('test', (_) => const AddPhonePage(), _level);
      case AppRoute.createMeeting:
        return Route('create_meeting', (_) => const CreateMeetingPage(), _level);
      case AppRoute.userOverview:
        return Route('research_person', (_) => const UserOverview(), _level);
      case AppRoute.editMeeting:
        return Route('edit_meeting', (_) => const EditMeetingPage(), _level);
    }
  }

  static Map<String, WidgetBuilder> get all {
    return {for (AppRoute route in AppRoute.values) route.get().path: route.get().builder};
  }
}

extension AuthRouteGenerator on AuthRoute {
  static const NavLevel _level = NavLevel.auth;

  Route get() {
    switch (this) {
      case AuthRoute.loginOptions:
        return Route('login_options', (_) => const LoginOptionsPage(), _level);
      case AuthRoute.phoneAuth:
        return Route('phone_signup', (_) => const AddPhonePage(), _level);
      case AuthRoute.verifyPhone:
        return Route('verify_phone', (_) => const VerifyCodePage(), _level);
      case AuthRoute.skipChoice:
        return Route('skip_choice', (_) => const SkipChoicePage(), _level);
      case AuthRoute.addName:
        return Route('user_info_1', (_) => const GetStartedPage(), _level);
      case AuthRoute.addBio:
        return Route('user_info_2', (_) => const AddBioPage(), _level);
      case AuthRoute.addProfilePhoto:
        return Route('user_info_3', (_) => const AddProfilePicturePage(), _level);
      case AuthRoute.addPersonalInfo:
        return Route('user_info_4', (_) => const AddPersonalInfoPage(), _level);
      case AuthRoute.addHobbies:
        return Route('user_info_5', (_) => const AddHobbiesPage(), _level);
      case AuthRoute.addEducation:
        return Route('user_info_6', (_) => const AddEducationPage(), _level);
      case AuthRoute.privacyPolicy:
        return Route('privacy_policy', (_) => const AcceptPrivacyPolicyPage(), _level);
    }
  }

  static WidgetBuilder buildByPath(String path) {
    return AuthRoute.values.singleWhere((r) => r.get().path == path).get().builder;
  }
}

extension CreateMeetingRouteGenerator on CreateMeetingRoute {
  static const NavLevel _level = NavLevel.createMeeting;

  Route get() {
    switch (this) {
      case CreateMeetingRoute.selectLocation:
        return Route('select_location', (_) => const SelectLocationPage(), _level);
      case CreateMeetingRoute.selectType:
        return Route('select_meeting_type', (_) => const SelectMeetingType(), _level);
    }
  }

  static WidgetBuilder buildByPath(String path) {
    return CreateMeetingRoute.values.singleWhere((r) => r.get().path == path).get().builder;
  }
}

class Route {
  /// Builds an appropriate widget for the given route.
  final WidgetBuilder builder;

  /// Navigation level among the application navigators (incl. nested).
  final NavLevel level;

  /// Route identifier which distinguishes it from other routes.
  final String path;

  Route(this.path, this.builder, this.level);
}
