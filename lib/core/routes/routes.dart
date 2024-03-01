import 'package:flight_booking_concept_ui/features/auth/screens/create_client_account_screen.dart';
import 'package:flight_booking_concept_ui/features/auth/screens/create_company_account_screen.dart';
import 'package:flight_booking_concept_ui/features/auth/screens/login_page.dart';
import 'package:flight_booking_concept_ui/features/auth/screens/selecte_account_type_screen.dart';
import 'package:flight_booking_concept_ui/features/splash_screen/splash_screen.dart';
import 'package:flight_booking_concept_ui/main_pages/home_page.dart';
import 'package:flutter/material.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashScreen.routeName:
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    case LoginPage.routeName:
      return MaterialPageRoute(builder: ((_) => const LoginPage()));
    case SelectAccountTypeScreen.routeName:
      return MaterialPageRoute(builder: ((_) => const SelectAccountTypeScreen()));

    case CreateClientAccountScreen.routeName:
      return MaterialPageRoute(builder: ((_) => const CreateClientAccountScreen()));

    case CreateCompanyAccountScreen.routeName:
      return MaterialPageRoute(builder: ((_) => const CreateCompanyAccountScreen()));
    case HomePage.routeName:
      return MaterialPageRoute(builder: ((_) => const HomePage()));
  }

  return null;
}
