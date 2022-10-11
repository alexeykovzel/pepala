import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum CustomIcon {
  add,
  navGrey,
  navRed,
  profileGrey,
  profileRed,
  google,
  apple,
  phone,
  facebook,
  pepala,
}

extension IconsCollection on CustomIcon {
  String get _address {
    switch (this) {
      case CustomIcon.add:
        return 'assets/icons/add.svg';
      case CustomIcon.navGrey:
        return 'assets/icons/tracker/nav_grey.svg';
      case CustomIcon.navRed:
        return 'assets/icons/tracker/nav_red.svg';
      case CustomIcon.profileGrey:
        return 'assets/icons/profile/profile_grey.svg';
      case CustomIcon.profileRed:
        return 'assets/icons/profile/profile_red.svg';
      case CustomIcon.google:
        return 'assets/icons/auth/google_logo.svg';
      case CustomIcon.apple:
        return 'assets/icons/auth/apple_logo.svg';
      case CustomIcon.phone:
        return 'assets/icons/auth/phone.svg';
      case CustomIcon.facebook:
        return 'assets/icons/auth/facebook_logo.svg';
      case CustomIcon.pepala:
        return 'assets/icons/logo.svg';
    }
  }

  Widget build({double? size = 24}) {
    return SvgPicture.asset(_address, width: size, height: size);
  }
}
