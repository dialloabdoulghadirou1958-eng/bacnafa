import 'package:flutter/material.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class BacNafaApp extends StatelessWidget {
  const BacNafaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BacNafa',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: goRouter,
    );
  }
}
