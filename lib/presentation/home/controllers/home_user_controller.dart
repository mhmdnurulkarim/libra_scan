import 'package:get/get.dart';

class HomeController extends GetxController {
  // Dummy list pinjaman sekarang
  var currentLoans = <Map<String, String>>[].obs;

  // Dummy list pinjaman sebelumnya
  var pastLoans = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchLoans();
  }

  void fetchLoans() {
    // Dummy data
    currentLoans.value = [
      {"title": "Buku 1", "author": "Penulis 1"},
      {"title": "Buku 2", "author": "Penulis 2"},
      {"title": "Buku 3", "author": "Penulis 3"},
    ];

    pastLoans.value = [
      {"title": "Buku 4", "author": "Penulis 4"},
      {"title": "Buku 5", "author": "Penulis 5"},
    ];
  }
}
