import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class MainScreenController extends GetxController {
  var currentIndex = 0.obs;
  var role = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadUserRole();
  }

  Future<void> loadUserRole() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      role.value = 'anggota';
      return;
    }

    try {
      final userDoc =
      await FirebaseFirestore.instance.collection('user').doc(userId).get();
      final roleRef = userDoc.data()?['role'] as DocumentReference?;
      if (roleRef != null) {
        final roleDoc = await roleRef.get();
        final roleData = roleDoc.data() as Map<String, dynamic>?;
        final roleName = (roleData?['name'] as String?)?.toLowerCase();
        role.value = roleName ?? 'anggota';
      } else {
        role.value = 'anggota';
      }
    } catch (e) {
      print("Error fetching role: $e");
      role.value = 'anggota';
    }
  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}