import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeAdminController extends GetxController {
  var isLoading = true.obs;
  var groupedRequests = <String, List<Map<String, dynamic>>>{}.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final allowedStatuses = <String>{
    'waiting for borrow',
    'take a book',
    'waiting for booking',
    'waiting for return',
  };

  @override
  void onInit() {
    super.onInit();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    try {
      isLoading.value = true;
      final snapshot = await _firestore.collection('transaction').get();

      final Map<String, List<Map<String, dynamic>>> statusGroups = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final status = data['status_transaction'] ?? '';

        if (!allowedStatuses.contains(status)) continue;

        final transactionId = doc.id;
        final userRef = data['user_id'] as DocumentReference?;

        if (userRef == null) continue;
        final userId = userRef.id;

        final userSnap = await _firestore.collection('user').doc(userId).get();
        final accSnap = await _firestore
            .collection('user')
            .doc(userId)
            .collection('account')
            .limit(1)
            .get();

        if (!userSnap.exists || accSnap.docs.isEmpty) continue;

        final user = userSnap.data();
        final acc = accSnap.docs.first.data();
        final name = user?['name'] ?? 'Tidak diketahui';
        final email = acc['email'] ?? 'Tidak diketahui';

        final detailSnap = await doc.reference.collection('transaction_detail').get();
        final totalBooks = detailSnap.docs.fold<int>(0, (sum, d) {
          final qty = d['quantity'];
          return sum + (qty is int ? qty : 1);
        });

        final item = {
          'name': name,
          'email': email,
          'book': totalBooks,
          'transaction_id': transactionId,
          'status_transaction': status,
        };

        statusGroups.putIfAbsent(status, () => []).add(item);
      }

      groupedRequests.value = statusGroups;
    } catch (e) {
      print('Error fetching admin requests: $e');
    } finally {
      isLoading.value = false;
    }
  }
}