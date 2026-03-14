/// Stroke Mitra - Main Entry Point
///
/// Initializes Supabase, loads environment variables,
/// and launches the Flutter application.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/router.dart';
import 'app/theme.dart';
import 'core/supabase_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait mode on mobile
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize Supabase
  await SupabaseClientManager.initialize();

  runApp(
    const ProviderScope(child: StrokeMitraApp()),
  );
}

class StrokeMitraApp extends ConsumerWidget {
  const StrokeMitraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Stroke Mitra — Detect Stroke Early. Save Lives.',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
