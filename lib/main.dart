import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:ghassal_laundry/ui/screen/auth/splash/splash_screen.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:tabby_flutter_inapp_sdk/tabby_flutter_inapp_sdk.dart';

import 'AppRouter.dart';
import 'business/auth/introController/IntroController.dart';
import 'conustant/di.dart';
import 'conustant/shared_preference_serv.dart';
import 'notification_service.dart';

///handling firebase and notification
FirebaseMessaging messaging = FirebaseMessaging.instance;
NotificationService notificationService = NotificationService();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await NotificationService().init();
  await notificationService.initializePlatformNotifications();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //taby//
  TabbySDK().setup(
    withApiKey:
        'pk_912f0711-52ba-4057-8f2d-4bb9022c3c12', // Put here your Api key
    environment: Environment.production,
  );

  setupDependencyInjection();
  //handle lang
  await translator.init(
    localeType: LocalizationDefaultType.device,
    languagesList: <String>['ar', 'en'],
    assetsDirectory: 'lib/language/',
  );
  final introController = Get.put(IntroController());
  introController.sharedPreferencesService
      .setString("lang", translator.currentLanguage.toString());
  await SentryFlutter.init((options) {
    options.dsn =
        'https://8310ca7b520b54476d827fcc92034cc4@o4507253688565760.ingest.us.sentry.io/4507253690925056';
    // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
    // We recommend adjusting this value in production.
    options.tracesSampleRate = 1.0;
    // The sampling rate for profiling is relative to tracesSampleRate
    // Setting to 1.0 will profile 100% of sampled transactions:
    options.profilesSampleRate = 1.0;
  },
      appRunner: () => runApp(
            Phoenix(
              child: //MyApp(appRouter: AppRouter())
                  LocalizedApp(
                      child: MyApp(
                appRouter: AppRouter(),
              )),
            ),
          ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.resumed) {
      final SharedPreferencesService sharedPreferencesService =
          instance<SharedPreferencesService>();
      sharedPreferencesService.setBool('hasShownPopup', false);
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          title: "GhassalLaundry",
          theme: ThemeData(
              useMaterial3: true,
              pageTransitionsTheme: const PageTransitionsTheme(builders: {
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
              }),
              scaffoldBackgroundColor: Colors.white,
              bottomAppBarTheme: BottomAppBarTheme(color: Colors.black54)),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: widget.appRouter.generateRoute,
          localizationsDelegates: translator.delegates,
          locale: translator.activeLocale,
          supportedLocales: translator.locals(),
          home: SplashScreen(),
        );
      },
    );
  }
}
