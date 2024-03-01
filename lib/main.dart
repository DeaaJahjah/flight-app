import 'package:firebase_core/firebase_core.dart';
import 'package:flight_booking_concept_ui/core/routes/routes.dart';
import 'package:flight_booking_concept_ui/features/auth/providers/auth_state_provider.dart';
import 'package:flight_booking_concept_ui/features/splash_screen/splash_screen.dart';
import 'package:flight_booking_concept_ui/firebase_options.dart';
import 'package:flight_booking_concept_ui/utils/hard_coded_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  HardCodedData.generateHardCodedData();
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthSataProvider>(
          create: (_) => AuthSataProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flight Booking UI Concept',
        locale: const Locale('ar'),
        supportedLocales: const [
          Locale("ar", "AE"),
        ],
        localizationsDelegates: const [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        onGenerateRoute: onGenerateRoute,
        theme: myLightThemeData,
        home: const SplashScreen(),
      ),
    );
  }
}

ThemeData myLightThemeData = ThemeData(
  fontFamily: 'Cario',
  useMaterial3: false,
);
