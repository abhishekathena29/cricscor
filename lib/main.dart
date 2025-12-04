import 'package:cricscor/firebase_options.dart';
import 'package:cricscor/ui/auth/provider/auth_provider.dart';
import 'package:cricscor/ui/create/provider/create_provider.dart';
import 'package:cricscor/ui/profile/provider/profile_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenProvider()),
        ChangeNotifierProvider(create: (_) => CreateProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: const CricScorApp(),
    ),
  );
}
