import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeAdminController extends GetxController {
  var borrowRequests = <Map<String, dynamic>>[].obs;
  var bookingRequests = <Map<String, dynamic>>[].obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRequests();
  }

  void fetchRequests() async {
    try {
      isLoading.value = true;

      final transactionSnapshots = await _firestore
          .collection('transaction')
          .where('status_transaction', whereIn: ['waiting for borrow', 'waiting for booking'])
          .get();

      List<Map<String, dynamic>> requestBorrow = [];
      List<Map<String, dynamic>> requestBooking = [];

      for (var transactionDoc in transactionSnapshots.docs) {
        final transactionId = transactionDoc.id;
        final transactionData = transactionDoc.data();
        final statusTransaction = transactionData['status_transaction'];
        final userRef = transactionData['user_id'] as DocumentReference?;

        if (userRef == null) continue;
        final userId = userRef.id;

        // Ambil data user
        final userSnapshot = await _firestore.collection('user').doc(userId).get();
        final accountSnapshot = await _firestore
            .collection('user')
            .doc(userId)
            .collection('account')
            .limit(1)
            .get();

        if (!userSnapshot.exists || accountSnapshot.docs.isEmpty) continue;

        final user = userSnapshot.data();
        final account = accountSnapshot.docs.first.data();
        final name = user?['name'] ?? 'Tidak diketahui';
        final email = account['email'] ?? 'Tidak diketahui';

        // Ambil data detail transaksi
        final detailsSnapshot = await _firestore
            .collection('transaction')
            .doc(transactionId)
            .collection('transaction_detail')
            .get();

        int totalQty = 0;
        for (var detail in detailsSnapshot.docs) {
          final data = detail.data();
          final qty = (data['quantity'] is num) ? (data['quantity'] as num).toInt() : 1;
          totalQty += qty;
        }

        final item = {
          'name': name,
          'email': email,
          'book': totalQty,
          'transaction_id': transactionId,
        };

        if (statusTransaction == 'waiting for borrow') {
          requestBorrow.add(item);
        } else if (statusTransaction == 'waiting for booking') {
          requestBooking.add(item);
        }
      }


      borrowRequests.value = requestBorrow;
      bookingRequests.value = requestBooking;
    } catch (e) {
      print('Error fetching admin requests: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void goToDetail(String transactionId) {
    Get.toNamed('/transaction-admin', arguments: {'transaction_id': transactionId});
  }
}
