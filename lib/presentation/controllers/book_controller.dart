import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BookController extends GetxController {
  var listBook = <Map<String, dynamic>>[].obs;
  var filteredBooks = <Map<String, dynamic>>[].obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void fetchBooks() async {
    try {
      final snapshot = await _firestore.collection('book').get();

      final books = snapshot.docs.map((doc) {
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

      listBook.value = books;
      filteredBooks.value = books;
    } catch (e) {
      print('Error fetching books: $e');
    }
  }

  void searchBooks(String query) {
    if (query.isEmpty) {
      filteredBooks.value = listBook;
    } else {
      final lowerQuery = query.toLowerCase();
      filteredBooks.value = listBook.where((book) {
        return book['title'].toString().toLowerCase().contains(lowerQuery) ||
            book['author'].toString().toLowerCase().contains(lowerQuery);
      }).toList();
    }
  }

  void addBook(Map<String, dynamic> book) async {
    try {
      await _firestore.collection('book').add(book);
      Get.snackbar('Sukses', 'Buku berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan buku: $e');
    }
  }


  void detailToEditBook(Map<String, dynamic> bookData) {

  }

  void editBook(Map<String, dynamic> bookData) {

  }

  void deleteBook(String bookId) {

  }
}
