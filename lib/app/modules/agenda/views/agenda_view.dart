import 'package:desago/app/helpers/color_helper.dart';
import 'package:desago/app/helpers/time_helper.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../controllers/agenda_controller.dart';

class AgendaView extends GetView<AgendaController> {
  const AgendaView({super.key});

  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          'Agenda Desa',
          style: AppText.h5(color: AppColors.secondary),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          _calendar(),
          SizedBox(height: AppResponsive.h(2)),
          Padding(
            padding: AppResponsive.padding(horizontal: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: _selectedDateInfo()
              ),
          ),
          SizedBox(height: AppResponsive.h(2)),
          Expanded(child: _agendaList()),
        ],
      ),
    );
  }

  Widget _calendar() {
  return Obx(() => Container(
        margin: AppResponsive.padding(horizontal: 3, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TableCalendar(
          key: ValueKey(controller.agendas.length),
          locale: 'id_ID',
          firstDay: DateTime.utc(2010, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: controller.selectedDay.value,
          selectedDayPredicate: (day) =>
              isSameDay(controller.selectedDay.value, day),

          eventLoader: (day) {
            return controller.getAgendaByDay(day);
          },

          onDaySelected: (selectedDay, focusedDay) {
            controller.selectedDay.value = selectedDay;
          },

          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),

          calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.3),
              shape: BoxShape.circle,
            ),

            /// 🔴 MARKER MERAH
            markerDecoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            markersMaxCount: 1,
          ),
        ),
      ));
}

  Widget _selectedDateInfo() {
    return Obx(() {
      final day = controller.selectedDay.value;

      final namaHari =
          DateFormat('EEEE', 'id_ID').format(day);
      final tanggal =
          DateFormat('dd MMMM yyyy', 'id_ID').format(day);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Jadwal Kegiatan",
            style: AppText.bodyMedium(color: AppColors.textSecondary),
          ),
          Text(
            "${namaHari}, ${tanggal}",
            style: AppText.h6(),
          ),
          
        ],
      );
    });
  }

  Widget _agendaList() {
    return Obx(() {
      final list = controller.agendaByDate;

      if (list.isEmpty) {
        return Center(
          child: Column(
            children: [
              SizedBox(height: AppResponsive.h(5)),
              Container(
                width: 80,
                height:80,
                decoration: BoxDecoration(
                  color: AppColors.borderAgenda,
                  borderRadius: BorderRadius.all(Radius.circular(50))
                ),
                child: Icon(
                  Remix.calendar_2_fill,
                  color:AppColors.secondary,
                  size: 40, 
                  )),
                  SizedBox(height: AppResponsive.h(1.5)),
              Text(
                "Tidak ada agenda",
                style: AppText.h5(color: AppColors.textSecondary),
              ),
              SizedBox(height: AppResponsive.h(0.5)),
              Text(
                "Pilih tanggal lain yang bertanda titik",
                style: AppText.bodyMedium(color: AppColors.textSecondary),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: AppResponsive.padding(horizontal: 5),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final e = list[index];
          return _agendaCard(
            category: e['kategori']['nama'],
            title: e['title'],
            time: "${TimeHelper.formatTime(e['waktu_mulai'])} - ${TimeHelper.formatTime(e['waktu_selesai'])}",
            location: e['location'],
            color: ColorHelper.colorFromCategoryId(e['kategori']['id']),
            agenda: e,
          );
        },
      );
    });
  }

  /// ================= AGENDA CARD =================
  Widget _agendaCard({
    required String category,
    required String title,
    required String time,
    required String location,
    required Color color,
    required dynamic agenda,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: AppResponsive.padding(vertical: 1, horizontal: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.secondary,
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            color: AppColors.border,
            spreadRadius: 1,
            offset: const Offset(1, 1),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TIME LINE
          Column(
            children: [
              Text(time, style: AppText.bodyMediumBold()),
              SizedBox(height: AppResponsive.h(1)),
              Container(
                height: AppResponsive.h(10),
                width: 2,
                color: color,
              ),
            ],
          ),
          SizedBox(width: AppResponsive.w(5)),

          /// CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    category,
                    style: AppText.smallBold(color: AppColors.white),
                  ),
                ),
                const SizedBox(height: 6),
                Text(title, style: AppText.bodyMediumBold()),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined, size: 16),
                    const SizedBox(width: 4),
                    Text(time, style: AppText.bodyMedium()),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(location, style: AppText.bodyMedium()),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
                  icon: Icon(Icons.share, size: 25, color: color,),
                  onPressed: () {
                    controller.shareAgenda(agenda);
                  },
                )

        ],
      ),
    );
  }
}
