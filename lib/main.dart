import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app_cubit/config/theme/app_theme.dart';
import 'package:messenger_app_cubit/data/services/service_locator.dart';
import 'package:messenger_app_cubit/firebase_options.dart';


import 'package:messenger_app_cubit/presentation/screens/auth/login_screen.dart';
import 'package:messenger_app_cubit/router/app_router.dart';

void main() async{
 
  await setupServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Messenger App',
      navigatorKey: getIt<AppRouter>().navigatorKey,
      theme: AppTheme.lightTheme,
      home: LoginScreen()
    );
  }
}
