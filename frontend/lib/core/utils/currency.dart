import 'package:intl/intl.dart';

final _grouped = NumberFormat('#,##0.00', 'en_US');

/// Formats kobo as a full balance, e.g. 300000028 -> "N3,000,000.28".
String formatBalance(int kobo) => 'N${_grouped.format(kobo / 100)}';

/// Formats kobo as a compact price, e.g. 300000 -> "N3000", 150050 -> "N1500.50".
String formatAmount(int kobo) {
  final naira = kobo ~/ 100;
  final remainder = kobo % 100;
  return remainder == 0 ? 'N$naira' : 'N$naira.${remainder.toString().padLeft(2, '0')}';
}
