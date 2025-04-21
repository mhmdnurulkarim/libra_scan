import 'package:go_router/go_router.dart';
import 'package:libra_scan/presentation/splash/views/splash_screen.dart';
import 'package:libra_scan/presentation/auth/views/login_screen.dart';
import 'package:libra_scan/presentation/auth/views/register_screen.dart';
import 'package:libra_scan/presentation/auth/views/register_detail_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/register-detail',
      builder: (context, state) => const RegisterDetailScreen(),
    ),
  ],
);
