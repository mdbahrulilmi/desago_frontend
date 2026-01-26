import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:get/get.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:table_calendar/table_calendar.dart';

class AgendaController extends GetxController {
  Rx<DateTime> selectedDay = DateTime.now().obs;

  final RxList<Map<String, dynamic>> agendas = <Map<String, dynamic>>[].obs;

  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAgenda();
  }

  Future<void> fetchAgenda() async {
    try {
    isLoading.value = true;
    final res = await DioService.instance.get(ApiConstant.agendaDesa);
    final data =
            List<Map<String, dynamic>>.from(res.data);
    agendas.value = data;
    print(agendas);
  } catch (e) {
    agendas.value = [];
    print("Error fetchAgenda: $e");
  } finally {
    isLoading.value = false;
  }
  }

  List<Map<String, dynamic>> getAgendaByDay(DateTime day) {
  return agendas.where((agenda) {
    final agendaDate = DateTime.parse(agenda['tanggal']);

    return isSameDay(agendaDate, day);
  }).toList();
}


  List<Map<String, dynamic>> get agendaByDate =>
      getAgendaByDay(selectedDay.value);


void shareAgenda(Map<String, dynamic> agenda) {
  final judul = agenda['title'] ?? 'Agenda Desa';
  final tanggalRaw = agenda['tanggal'];
  final waktuMulai = agenda['waktu_mulai'] ?? '-';
  final waktuSelesai = agenda['waktu_selesai'] ?? '-';
  final lokasi = agenda['location'] ?? '-';

  String tanggalFormatted = '';
  if (tanggalRaw != null) {
    final date = DateTime.parse(tanggalRaw);
    tanggalFormatted = DateFormat('dd MMMM yyyy', 'id_ID').format(date);
  }

  final text = '''
📌 *$judul*

🗓 Tanggal: $tanggalFormatted
📍 Waktu: $waktuMulai - $waktuSelesai
📍 Lokasi: $lokasi

Info agenda desa:
https://desago.id
''';

  Share.share(
    text,
    subject: judul,
  );
}

}
