import 'package:flutter/material.dart';

import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:madaride/ui/screen/login_page.dart';
import 'package:madaride/ui/screen/profile_page.dart';
import 'package:madaride/ui/screen/search_result_page.dart';
import 'package:madaride/ui/screen/show_ride_screen.dart';
import 'package:madaride/ui/screen/sign_up_page.dart';
import 'package:madaride/utils/auth_state.dart';
import 'package:provider/provider.dart';
import 'ui/screen/home_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization _localization = FlutterLocalization.instance;

  @override
  void initState() {
    _localization.init(
      mapLocales: [
        const MapLocale(
          'en',
          AppLocale.EN,
          countryCode: 'UK',
          fontFamily: 'Font EN',
        ),
        const MapLocale(
          'fr',
          AppLocale.FR,
          countryCode: 'FR',
          fontFamily: 'Font FR',
        ),
        const MapLocale(
          'mg',
          AppLocale.MG,
          countryCode: 'MG',
          fontFamily: 'Font MG',
        ),
      ],
      initLanguageCode: 'en',
    );
    _localization.onTranslatedLanguage = _onTranslatedLanguage;
    super.initState();
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        FormBuilderLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: FormBuilderLocalizations.supportedLocales,
      title: 'Madaride',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1D4ED8)),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      getPages: [
        GetPage(name: "/", page: () => const MyHomePage()),
        GetPage(name: '/search-result', page: () => SearchResultPage()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/sign-up', page: () => const SignUpPage()),
        GetPage(name: '/ride/:slug', page: () => ShowRidePage(slug: Get.parameters['slug']!)),
        GetPage(name: '/profile', page: () => const ProfilePage()),
      ],
    );
  }
}


mixin AppLocale {
  static const String slogan = 'title';

  static const Map<String, dynamic> EN = {
    slogan: 'Save money while preserving the environment',
  };
  static const Map<String, dynamic> FR = {
    slogan: 'Economisez, tout en préservant l\'environnement',
  };
  static const Map<String, dynamic> MG = {
    slogan: 'Mitsitsy no sady miaro ny tontolo iainana',
  };
}
