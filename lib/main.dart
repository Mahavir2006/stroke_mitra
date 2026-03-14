import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme.dart';
import 'core/app_router.dart';

void main() {
  runApp(const ProviderScope(child: StrokeMitraApp()));
}

class StrokeMitraApp extends StatelessWidget {
  const StrokeMitraApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Stroke Mitra',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
