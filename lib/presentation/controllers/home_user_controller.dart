import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeUserController extends GetxController {
  var currentLoans = <Map<String, dynamic>>[].obs;
  var pastLoans = <Map<String, dynamic>>[].obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchBooks();
  }

  void fetchBooks() async {
    try {
      final snapshot = await _firestore.collection('book').get();

      currentLoans.value = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'title': data['title'] ?? '',
          'author': data['author'] ?? '',
          'isbn': data['isbn'] ?? '',
          'barcode': data['barcode'] ?? '',
          'stock': data['stock'] ?? 0,
          'synopsis': data['synopsis'] ?? '',
          'category_id': data['category_id'],
        };
      }).toList();

      // Jika ingin memisahkan pinjaman sebelumnya, bisa logikakan berdasarkan timestamp/status
      pastLoans.value = []; // Kosong dulu
    } catch (e) {
      print('Error fetching books: $e');
    }
  }

  void goToDetail(Map<String, dynamic> bookData) {
    Get.toNamed('/book-detail', arguments: bookData);
  }
}
