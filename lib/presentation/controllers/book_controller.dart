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

  Future<void> submitBook({
    required String? bookDocId,
    required Map<String, dynamic> book,
    required bool isEdit,
  }) async {
    try {
      if (isEdit && bookDocId != null) {
        await updateBook(bookDocId, book);
      } else {
        await addBook(book);
        MySnackBar.show(
          title: 'Sukses',
          message: 'Buku berhasil ditambahkan',
          backgroundColor: Colors.green,
          fontColor: Colors.white,
          icon: Icons.check,
        );
      }
      Get.back(result: true);
    } catch (e) {
      MySnackBar.show(
        title: 'Error',
        message: 'Gagal menyimpan buku: $e',
        backgroundColor: Colors.red,
        fontColor: Colors.white,
        icon: Icons.error,
      );
    }
  }

  Future<void> addBook(Map<String, dynamic> book) async {
    try {
      final docRef = await _firestore.collection('book').add(book);
      await docRef.update({'book_id': docRef.id});

      MySnackBar.show(
        title: 'Sukses',
        message: 'Buku berhasil ditambahkan',
        backgroundColor: Colors.green,
        fontColor: Colors.white,
        icon: Icons.check,
      );

      Get.back();
    } catch (e) {
      MySnackBar.show(
        title: 'Error',
        message: 'Gagal menambahkan buku: $e',
        backgroundColor: Colors.red,
        fontColor: Colors.white,
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
        backgroundColor: Colors.green,
        fontColor: Colors.white,
        icon: Icons.check,
      );
    } catch (e) {
      MySnackBar.show(
        title: 'Error',
        message: 'Gagal update: $e',
        backgroundColor: Colors.red,
        fontColor: Colors.white,
        icon: Icons.error,
      );
    }
  }

  Future<void> deleteBook(String id) async {
    final confirm = await Get.defaultDialog<bool>(
      title: "Konfirmasi",
      middleText: "Yakin ingin menghapus buku ini?",
      textCancel: "Batal",
      textConfirm: "Hapus",
      confirmTextColor: Colors.white,
      onConfirm: () => Get.back(result: true),
      onCancel: () => Get.back(result: false),
    );

    try {
      if (confirm == true) {
        await _firestore.collection('book').doc(id).delete();
        MySnackBar.show(
          title: 'Berhasil',
          message: 'Buku berhasil dihapus',
          backgroundColor: Colors.green,
          fontColor: Colors.white,
          icon: Icons.check,
        );

        Get.back(result: true);
      }
    } catch (e) {
      MySnackBar.show(
        title: 'Error',
        message: 'Gagal hapus: $e',
        backgroundColor: Colors.red,
        fontColor: Colors.white,
        icon: Icons.error,
      );
    }
  }

  Future<Map<String, dynamic>?> getBook(String barcode) async {
    try {
      final snapshot = await _firestore
          .collection('book')
          .where('barcode', isEqualTo: barcode)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        final data = doc.data();
        data['book_id'] = doc.id;
        return data;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error getBook: $e');
      return null;
    }
  }
}
