import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../data/share_preference.dart';

class HomeUserController extends GetxController {
  var currentTransactions = <Map<String, dynamic>>[].obs;
  var pastLoans = <Map<String, dynamic>>[].obs;

  final _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchUserTransactions();
  }

  Future<void> fetchUserTransactions() async {
    try {
      final userData = await LocalStorage.getUserData();
      final userRef = _firestore.doc('user/${userData['user_id']}');
      final name = userData['name'];

      final snapshot = await _firestore
          .collection('transaction')
          .where('user_id', isEqualTo: userRef)
          .get();

      final List<Map<String, dynamic>> current = [];
      final List<Map<String, dynamic>> past = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final status = data['status_transaction'] ?? 'draft';

        final details = await doc.reference.collection('transaction_detail').get();
        final totalQty = details.docs.fold<int>(0, (sum, d) {
          final qty = d['quantity'];
          return sum + (qty is int ? qty : 1);
        });

        final item = {
          'transaction_id': doc.id,
          'created_at': data['borrow_date'],
          'book_count': totalQty,
          'name': name,
          'status': status,
        };

        if (status == 'returned') {
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
