import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ReportController extends GetxController {
  final RxString selectedFilter = 'Tahunan'.obs;
  final RxList<String> filters = ['Hari Ini', 'Mingguan', 'Bulanan', 'Tahunan'].obs;
  final RxList<double> values = <double>[].obs;
  final RxList<String> xLabels = <String>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReportData();
  }

  Future<void> fetchReportData() async {
    isLoading.value = true;

    final now = DateTime.now();
    DateTime startDate;

    switch (selectedFilter.value) {
      case 'Hari Ini':
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case 'Mingguan':
        startDate = now.subtract(Duration(days: 7));
        break;
      case 'Bulanan':
        if (now.month == 1) {
          startDate = DateTime(now.year - 1, 12, now.day);
        } else {
          startDate = DateTime(now.year, now.month - 1, now.day);
        }
        break;
      case 'Tahunan':
      default:
        startDate = DateTime(now.year - 4);
        break;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('transaction')
        .where('borrow_date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .get();

    Map<String, int> dataMap = {};

    for (var doc in snapshot.docs) {
      if (doc['borrow_date'] is! Timestamp) continue;
      final date = (doc['borrow_date'] as Timestamp).toDate();
      String key;

      switch (selectedFilter.value) {
        case 'Hari Ini':
          key = "${date.hour}:00";
          break;
        case 'Mingguan':
        case 'Bulanan':
          key = "${date.day}/${date.month}";
          break;
        case 'Tahunan':
        default:
          key = "${date.year}";
          break;
      }

      dataMap[key] = (dataMap[key] ?? 0) + 1;
    }

    final sortedKeys = dataMap.keys.toList();
    if (selectedFilter.value == 'Hari Ini') {
      sortedKeys.sort((a, b) => int.parse(a.split(':')[0]).compareTo(int.parse(b.split(':')[0])));
    } else {
      sortedKeys.sort();
    }

    xLabels
      ..clear()
      ..addAll(sortedKeys);
    values
      ..clear()
      ..addAll(sortedKeys.map((k) => dataMap[k]!.toDouble()));

    isLoading.value = false;
  }
}