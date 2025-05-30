import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../data/share_preference.dart';

class HomeUserController extends GetxController {
  var currentTransactions = <Map<String, dynamic>>[].obs;
  var pastLoans = <Map<String, dynamic>>[].obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchUserTransactions();
  }

  Future<void> fetchUserTransactions() async {
    try {
      final userData = await LocalStorage.getUserData();
      final userId = userData['user_id'];

      if (userId == null || userId.isEmpty) {
        print('User ID not found in local storage');
        return;
      }

      final transactionsSnapshot = await _firestore
          .collection('transaction')
          .where('user_id', isEqualTo: _firestore.doc('user/$userId'))
          .get();

      List<Map<String, dynamic>> current = [];
      List<Map<String, dynamic>> past = [];

      for (var transaction in transactionsSnapshot.docs) {
        final transactionData = transaction.data();
        final createdAt = transactionData['created_at'] as Timestamp?;
        final transactionId = transaction.id;

        final detailsSnapshot = await _firestore
            .collection('transaction')
            .doc(transactionId)
            .collection('transaction_detail')
            .get();

        int currentCount = 0;

        for (var detail in detailsSnapshot.docs) {
          final detailData = detail.data();
          final status = detailData['status'] ?? '';
          final bookRef = detailData['book_id'] as DocumentReference?;

          if (status == 'borrowed' || status == 'pending') {
            currentCount++;
          }

          if (status == 'returned' && bookRef != null) {
            final bookSnapshot = await bookRef.get();
            if (bookSnapshot.exists) {
              final bookData = bookSnapshot.data() as Map<String, dynamic>;
              past.add({
                'title': bookData['title'] ?? '',
                'author': bookData['author'] ?? '',
                'id': bookSnapshot.id,
                'book': bookData,
              });
            }
          }
        }

        if (currentCount > 0) {
          current.add({
            'transaction_id': transactionId,
            'created_at': createdAt,
            'book_count': currentCount,
          });
        }
      }

      currentTransactions.value = current;
      pastLoans.value = past;
    } catch (e) {
      print('Error fetching user transactions: $e');
    }
  }

  void goToDetail(dynamic data) {
    if (data is String) {
      Get.toNamed('/transaction-user', arguments: {'transaction_id': data});
    } else {
      Get.toNamed('/transaction-user', arguments: data);
    }
  }
}
