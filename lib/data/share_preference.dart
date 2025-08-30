import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userData['user_id'] ?? '');
    await prefs.setString('nin', userData['nin'] ?? '');
    await prefs.setString('name', userData['name'] ?? '');
    await prefs.setString('address', userData['address'] ?? '');
    await prefs.setString('phone_number', userData['phone_number'] ?? '');
    await prefs.setString('email', userData['email'] ?? '');
    await prefs.setString('role_id', userData['role_id'] ?? '');
    await prefs.setString('status', userData['status'] ?? '');
  }

  static Future<Map<String, String>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString('user_id') ?? '';
    if (userId.isEmpty) {
      return {};
    }

    return {
      'user_id': userId,
      'nin': prefs.getString('nin') ?? '',
      'name': prefs.getString('name') ?? '',
      'address': prefs.getString('address') ?? '',
      'phone_number': prefs.getString('phone_number') ?? '',
      'email': prefs.getString('email') ?? '',
      'role_id': prefs.getString('role_id') ?? '',
      'status': prefs.getString('status') ?? '',
    };
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
