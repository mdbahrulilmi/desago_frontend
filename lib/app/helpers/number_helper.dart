import 'package:intl/intl.dart';

class NumberHelper {
  static String formatRupiah(num? value) {
    if (value == null) return '0';
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(value).replaceAll(',', '.');
  }
}
