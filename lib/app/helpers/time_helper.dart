import 'package:intl/intl.dart';

class TimeHelper {
  static String formatTime(String? time) {
    if (time == null || time.length < 5) return '-';
    return time.substring(0, 5);
  }

  static String formatTanggalIndonesia(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) return '-';

    final dateTime = DateTime.parse(createdAt);
    return DateFormat(
      'd MMMM yyyy',
      'id_ID',
    ).format(dateTime);
  }

  static String formatTanggal(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) return '-';

    final dateTime = DateTime.parse(createdAt);
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

   static String formatTanggalDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static String formatJam(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) return '-';

    final dateTime = DateTime.parse(createdAt);
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
