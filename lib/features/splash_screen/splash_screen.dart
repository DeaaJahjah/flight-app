import 'dart:async';

import 'package:flight_booking_concept_ui/core/extensions/firebase.dart';
import 'package:flight_booking_concept_ui/core/widgets/custom_progress.dart';
import 'package:flight_booking_concept_ui/features/auth/screens/login_page.dart';
import 'package:flight_booking_concept_ui/main_pages/home_page.dart';
import 'package:flight_booking_concept_ui/utils/r.dart';
import 'package:flutter/material.dart';
import 'package:show_up_animation/show_up_animation.dart';
// import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/';

  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () async {
      if (context.logedInUser != null) {
        Navigator.of(context).pushReplacementNamed(HomePage.routeName);
      } else {
        Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
      }
    });
    return Scaffold(
      backgroundColor: R.primaryColor,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShowUpAnimation(
              delayStart: const Duration(milliseconds: 50),
              animationDuration: const Duration(seconds: 1),
              curve: Curves.bounceInOut,
              direction: Direction.vertical,
              offset: 0.5,
              child: Column(
                children: [
                  Hero(
                      tag: const ValueKey('logo'),
                      child: RotationTransition(
                          turns: const AlwaysStoppedAnimation(50 / 360),
                          child: Icon(Icons.flight, color: R.secondaryColor, size: 80))),
                  // Image.asset(
                  //   'assets/images/logo-with-text.png',
                  //   height: MediaQuery.sizeOf(context).height * 0.25,
                  // ),
                  Text(
                    'موقع حجز رحلات الطيران',
                    style: TextStyle(color: R.secondaryColor),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const CustomProgress(),
                ],
              )),
        ],
      )),
    );
  }
}
