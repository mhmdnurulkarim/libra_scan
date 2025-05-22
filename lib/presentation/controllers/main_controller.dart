import 'package:get/get.dart';

import '../../data/share_preference.dart';

class MainScreenController extends GetxController {
  var currentIndex = 0.obs;
  var role = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadUserRole();
  }

  Future<void> loadUserRole() async {
    try {
      final userData = await LocalStorage.getUserData();
      final roleId = userData['role_id']?.toLowerCase() ?? '';

      if (roleId == 'admin') {
        role.value = 'admin';
      } else {
        role.value = 'anggota';
      }
    } catch (e) {
      print("Error loading user data from local storage: $e");
      role.value = 'anggota';
    }
  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
