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
      final userName = userData['name'];

      final transactionsSnapshot = await _firestore
          .collection('transaction')
          .where('user_id', isEqualTo: _firestore.doc('user/$userId'))
          .get();

      List<Map<String, dynamic>> current = [];
      List<Map<String, dynamic>> past = [];

      for (var transaction in transactionsSnapshot.docs) {
        final transactionData = transaction.data();
        final createdAt = transactionData['borrow_date'] as Timestamp?;
        final transactionId = transaction.id;
        final statusTransaction = transactionData['status_transaction'] as String? ?? 'draft';

        final detailsSnapshot = await transaction.reference.collection('transaction_detail').get();

        int totalQty = 0;
        for (var detail in detailsSnapshot.docs) {
          final data = detail.data();
          final qty = (data['quantity'] is num) ? (data['quantity'] as num).toInt() : 1;
          totalQty += qty;
        }

        final item = {
          'transaction_id': transactionId,
          'created_at': createdAt,
          'book_count': totalQty,
          'name': userName,
          'status': statusTransaction,
        };

        if (statusTransaction == 'returned') {
          past.add(item);
        } else {
          current.add(item);
        }
      }

      currentTransactions.value = current;
      pastLoans.value = past;
    } catch (e) {
      print('Error fetching user transactions: $e');
    }
  }

  void goToDetail(String transactionId) {
    Get.toNamed('/transaction-user', arguments: {'transaction_id': transactionId});
  }
}
