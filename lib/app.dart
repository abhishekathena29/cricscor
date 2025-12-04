import 'package:cricscor/ui/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:style/theme/colors.dart';
import 'package:style/theme/theme.dart';

import 'ui/main_shell.dart';

class CricScorApp extends StatelessWidget {
  const CricScorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cricscor',
      theme: materialThemeDataLight,
      darkTheme: materialThemeDataDark,
      builder: (context, child) {
        final brightness = MediaQuery.platformBrightnessOf(context);
        final colors = brightness == Brightness.dark
            ? appColorSchemeDark
            : appColorSchemeLight;
        return AppTheme(colorScheme: colors, child: child ?? const SizedBox());
      },
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.hasData && asyncSnapshot.data != null) {
            return const MainShell();
          }
          return MinimalLoginPage();
        },
      ),
    );
  }
}
