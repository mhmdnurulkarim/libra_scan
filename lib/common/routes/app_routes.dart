import 'package:get/get.dart';
import 'package:libra_scan/presentation/screens/main_screen.dart';
import 'package:libra_scan/presentation/screens/report/report_screen.dart';

import '../../presentation/screens/auth/forgot_password.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_detail_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/book/book_detail_screen.dart';
import '../../presentation/screens/book/book_management_screen.dart';
import '../../presentation/screens/home/scanner_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/transaction/transaction_admin_screen.dart';
import '../../presentation/screens/transaction/transaction_user_screen.dart';
import 'app_pages.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.register, page: () => const RegisterScreen()),
    GetPage(
      name: AppRoutes.registerDetail,
      page: () => const RegisterDetailScreen(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(name: AppRoutes.main, page: () => MainScreen()),
    GetPage(name: AppRoutes.scanner, page: () => const ScannerScreen()),
    GetPage(
      name: AppRoutes.bookManagement,
      page: () => const BookManagementScreen(),
    ),
    GetPage(name: AppRoutes.bookDetail, page: () => const BookDetailScreen()),
    GetPage(
      name: AppRoutes.transactionUser,
      page: () => const TransactionUserScreen(),
    ),
    GetPage(
      name: AppRoutes.transactionAdmin,
      page: () => const TransactionAdminScreen(),
    ),
    GetPage(name: AppRoutes.report, page: () => const ReportScreen()),
  ];
}
