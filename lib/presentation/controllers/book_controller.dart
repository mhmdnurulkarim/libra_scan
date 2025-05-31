import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/snackbar.dart';

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
          'book_id': doc.id,
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

  Future<QuerySnapshot> getAllCategories() {
    return _firestore.collection('category').get();
  }

  void addBook(Map<String, dynamic> book) async {
    try {
      final docRef = await _firestore.collection('book').add(book);

      await docRef.update({'book_id': docRef.id});

      MySnackBar.show(
        title: 'Sukses',
        message: 'Buku berhasil ditambahkan',
        bgColor: Colors.green,
        icon: Icons.check,
      );

      Get.back();
    } catch (e) {
      MySnackBar.show(
        title: 'Error',
        message: 'Gagal menambahkan buku: $e',
        bgColor: Colors.red,
        icon: Icons.error,
      );
    }
  }


  Future<void> updateBook(String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('book').doc(id).update(data);
      MySnackBar.show(
        title: 'Berhasil',
        message: 'Data buku diperbarui',
        bgColor: Colors.green,
      );
    } catch (e) {
      MySnackBar.show(
        title: 'Error',
        message: 'Gagal update: $e',
        bgColor: Colors.red,
        icon: Icons.error,
      );
    }
  }

  Future<void> deleteBook(String id) async {
    try {
      await _firestore.collection('book').doc(id).delete();
      MySnackBar.show(
        title: 'Berhasil',
        message: 'Buku berhasil dihapus',
        bgColor: Colors.green,
      );
    } catch (e) {
      MySnackBar.show(
        title: 'Error',
        message: 'Gagal hapus: $e',
        bgColor: Colors.red,
        icon: Icons.error,
      );
    }
  }
}
