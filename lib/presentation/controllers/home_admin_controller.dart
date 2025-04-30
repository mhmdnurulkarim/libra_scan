import 'package:get/get.dart';

class HomeAdminController extends GetxController {
  var loanRequests = <Map<String, dynamic>>[].obs;
  var bookingRequests = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRequests();
  }

  void fetchRequests() {
    loanRequests.value = [
      {"name": "Anggota 1", "id": "akun_001", "books": 3},
      {"name": "Anggota 2", "id": "akun_002", "books": 2},
    ];

    bookingRequests.value = [
      {"name": "Anggota 3", "id": "akun_003", "books": 1},
      {"name": "Anggota 4", "id": "akun_004", "books": 4},
    ];
  }
}
