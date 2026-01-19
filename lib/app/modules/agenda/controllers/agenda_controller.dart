import 'package:get/get.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:table_calendar/table_calendar.dart';

class AgendaController extends GetxController {
  Rx<DateTime> selectedDay = DateTime.now().obs;

  final agendas = <Map<String, dynamic>>[
    {
      "date": DateTime(2026, 1, 15),
      "category": "Rapat",
      "title": "Rapat Koordinasi Pembangunan Desa",
      "time": "09:00 - 11:30",
      "location": "Balai Desa",
      "color": AppColors.primary,
    },
    {
      "date": DateTime(2026, 1, 15),
      "category": "Agenda",
      "title": "Musyawarah Warga",
      "time": "13:00 - 15:00",
      "location": "Aula Desa",
      "color": AppColors.deepPurple,
    },
    {
      "date": DateTime(2026, 1, 16),
      "category": "Kunjungan",
      "title": "Kunjungan Kecamatan",
      "time": "10:00 - 12:00",
      "location": "Kantor Desa",
      "color": AppColors.lightBlue,
    },
  ].obs;

  /// 🔴 Dipakai TableCalendar (marker merah)
  List<Map<String, dynamic>> getAgendaByDay(DateTime day) {
    return agendas.where((e) {
      final d = e['date'] as DateTime;
      return isSameDay(d, day);
    }).toList();
  }

  /// 📋 Dipakai list agenda bawah
  List<Map<String, dynamic>> get agendaByDate =>
      getAgendaByDay(selectedDay.value);
}
