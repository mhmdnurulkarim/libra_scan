import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeAdminController extends GetxController {
  var loanRequests = <Map<String, dynamic>>[].obs;
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
      final transactionSnapshots =
          await _firestore.collection('transaction').get();

      Map<String, Map<String, dynamic>> tempLoans = {};
      Map<String, Map<String, dynamic>> tempBookings = {};

      for (var transactionDoc in transactionSnapshots.docs) {
        final transactionId = transactionDoc.id;
        final userRef = transactionDoc.data()['user_id'] as DocumentReference?;

        if (userRef == null) continue;

        final detailsSnapshot =
            await _firestore
                .collection('transaction')
                .doc(transactionId)
                .collection('transaction_detail')
                .get();

        for (var detailDoc in detailsSnapshot.docs) {
          final data = detailDoc.data();
          final status = data['status'] ?? '';

          // Ambil ID user dari path 'users/{user_id}'
          final userId = userRef.id;

          // Ambil akun pengguna hanya satu kali
          if (!tempLoans.containsKey(userId) &&
              !tempBookings.containsKey(userId)) {
            final accountSnapshot =
                await _firestore
                    .collection('user')
                    .doc(userId)
                    .collection('account')
                    .limit(1)
                    .get();

            if (accountSnapshot.docs.isEmpty) continue;

            final account = accountSnapshot.docs.first.data();
            final name = account['name'] ?? 'Tidak diketahui';
            final email = account['email'] ?? 'Tidak diketahui';

            // Inisialisasi data user di masing-masing map
            tempLoans[userId] = {'name': name, 'email': email, 'book': 0};
            tempBookings[userId] = {'name': name, 'email': email, 'book': 0};
          }

          if (status == 'pending') {
            tempLoans[userId]!['book'] += 1;
          } else if (status == 'booked') {
            tempBookings[userId]!['book'] += 1;
          }
        }
      }

      // Filter hanya yang benar-benar punya permintaan
      loanRequests.value =
          tempLoans.values.where((e) => e['book'] > 0).toList();
      bookingRequests.value =
          tempBookings.values.where((e) => e['book'] > 0).toList();
    } catch (e) {
      print('Error fetching admin requests: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
