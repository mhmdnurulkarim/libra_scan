import 'package:get/get.dart';
import 'package:libra_scan/presentation/auth/views/login_screen.dart';
import 'package:libra_scan/presentation/auth/views/register_detail_screen.dart';
import 'package:libra_scan/presentation/auth/views/register_screen.dart';
import 'package:libra_scan/presentation/book/views/book_detail_screen.dart';
import 'package:libra_scan/presentation/book/views/book_management_screen.dart';
import 'package:libra_scan/presentation/home/views/home_admin_screen.dart';
import 'package:libra_scan/presentation/home/views/home_user_screen.dart';
import 'package:libra_scan/presentation/home/views/scanner_screen.dart';
import 'package:libra_scan/presentation/search/views/search_admin_screen.dart';
import 'package:libra_scan/presentation/search/views/search_user_screen.dart';
import 'package:libra_scan/presentation/splash/views/splash_screen.dart';
import 'package:libra_scan/presentation/transaction/views/transaction_user_screen.dart';

import '../../presentation/transaction/views/transaction_admin_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
    ),
    GetPage(
      name: AppRoutes.registerDetail,
      page: () => const RegisterDetailScreen(),
    ),
    GetPage(
      name: AppRoutes.homeUser,
      page: () => HomeUserScreen(),
    ),
    GetPage(
      name: AppRoutes.homeAdmin,
      page: () => HomeAdminScreen(),
    ),
    GetPage(
      name: AppRoutes.scanner,
      page: () => const ScannerScreen(),
    ),
    GetPage(
      name: AppRoutes.searchUser,
      page: () => const SearchScreen(),
    ),
    GetPage(
      name: AppRoutes.searchAdmin,
      page: () => const SearchAdminScreen(),
    ),
    GetPage(
      name: AppRoutes.bookManagement,
      page: () => const BookManagementScreen(),
    ),
    GetPage(
      name: AppRoutes.bookDetail,
      page: () => const BookDetailScreen(),
    ),
    GetPage(
      name: AppRoutes.transactionUser,
      page: () => const TransactionUserScreen(),
    ),
    GetPage(
      name: AppRoutes.transactionUser,
      page: () => const TransactionAdminScreen(),
    ),
  ];
}
