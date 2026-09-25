import 'package:intl/intl.dart';

final _grouped = NumberFormat('#,##0.00', 'en_US');

String formatBalance(int kobo) => 'N${_grouped.format(kobo / 100)}';

String formatAmount(int kobo) {
  final naira = kobo ~/ 100;
  final remainder = kobo % 100;
  return remainder == 0 ? 'N$naira' : 'N$naira.${remainder.toString().padLeft(2, '0')}';
}
