import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as ios;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_wallet/screens/splash_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeLocalNotifications();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

Future<void> _initializeLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon_black');
  const ios.DarwinInitializationSettings initializationSettingsIOS =
      ios.DarwinInitializationSettings();
  InitializationSettings initializationSettings = const InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskWallet',
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 47, 47, 47),
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 70, 69, 69),
        dialogTheme: DialogTheme(
          backgroundColor: const Color.fromARGB(255, 42, 41, 41),
          iconColor: Colors.white,
          shadowColor: Colors.black,
          contentTextStyle: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.white),
          titleTextStyle: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Colors.white),
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          menuStyle: MenuStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 47, 47, 47),
            ),
          ),
          textStyle: const TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ).copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
      ),
      home: const SplashScreen(),
    );
  }
}
