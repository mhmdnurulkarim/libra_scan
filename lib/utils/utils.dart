import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatDate(Timestamp timestamp) {
  final dateTime = timestamp.toDate();
  return DateFormat('dd MMM yyyy').format(dateTime);
}