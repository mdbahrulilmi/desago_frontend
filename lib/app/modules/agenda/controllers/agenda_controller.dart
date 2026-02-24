import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/models/AgendaModel.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:table_calendar/table_calendar.dart';

class AgendaController extends GetxController {
  final Rx<DateTime> selectedDay = DateTime.now().obs;
  final RxList<AgendaModel> agendas = <AgendaModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAgenda();
  }

  Future<void> fetchAgenda() async {
    try {
      isLoading.value = true;

      final res = await DioService.instance.get(ApiConstant.agendaDesa);

      final List listData =
          res.data is List ? res.data : res.data['data'] ?? [];

      agendas.assignAll(
        listData.map((e) => AgendaModel.fromJson(e)).toList(),
      );

    } catch (e, stack) {
      agendas.clear();
    } finally {
      isLoading.value = false;
    }
  }

  List<AgendaModel> getAgendaByDay(DateTime day) {
    return agendas.where((agenda) {
      return isSameDay(agenda.tanggal, day);
    }).toList();
  }

  List<AgendaModel> get agendaByDate =>
      getAgendaByDay(selectedDay.value);

  void shareAgenda(AgendaModel agenda) {
    final tanggalFormatted =
        DateFormat('dd MMMM yyyy', 'id_ID').format(agenda.tanggal);

    final text = '''
📌 *${agenda.judul}*

🗓 Tanggal: $tanggalFormatted
⏰ Waktu: ${agenda.waktuMulai} - ${agenda.waktuSelesai}
📍 Lokasi: ${agenda.lokasi}
🏷 Kategori: ${agenda.kategori.nama}

''';

    Share.share(
      text,
      subject: agenda.judul,
    );
  }
}
