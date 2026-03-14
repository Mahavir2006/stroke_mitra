import 'package:go_router/go_router.dart';
import '../features/landing/landing_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/face_analysis/face_analysis_screen.dart';
import '../features/speech_check/speech_check_screen.dart';
import '../features/motion_test/motion_test_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LandingScreen(),
    ),
    GoRoute(
      path: '/app',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/face',
      builder: (context, state) => const FaceAnalysisScreen(),
    ),
    GoRoute(
      path: '/voice',
      builder: (context, state) => const SpeechCheckScreen(),
    ),
    GoRoute(
      path: '/motion',
      builder: (context, state) => const MotionTestScreen(),
    ),
  ],
);
