import 'dart:convert';
import 'dart:io';

import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/models/SuratModel.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:desago/app/services/storage_services.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SuratFormController extends GetxController {
  final isLoading = true.obs;
  final isSubmitting = false.obs;

  final suratId = ''.obs;
  final suratTitle = ''.obs;
  final RxMap suratData = {}.obs;
  final Map<String, Rx<String?>> timeValues = {};


  RxList<Map<String, dynamic>> formSections = <Map<String, dynamic>>[].obs;

  final Map<String, TextEditingController> textControllers = {};
  final Map<String, RxString> dropdownValues = {};
  final Map<String, Rx<String?>> dateValues = {};
  final Map<String, Rx<File?>> fileValues = {};
  final Map<String, RxBool> checkboxValues = {};
  final Map<String, TextEditingController> timeControllers = {};


  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      suratId.value = Get.arguments['suratId'] ?? '';
      suratTitle.value = Get.arguments['suratTitle'] ?? 'Form Surat';
      suratData.assignAll(Get.arguments['suratData'] ?? {});
    }

    setupFormSchema();
    isLoading.value = false;
  }

  void setupFormSchema() {
    if (suratData['form_schema'] == null) return;

    List<dynamic> rawSections;

    if (suratData['form_schema'] is String) {
      rawSections = jsonDecode(suratData['form_schema']);
    } else {
      rawSections = suratData['form_schema'];
    }

    formSections.value =
        rawSections.map((e) => Map<String, dynamic>.from(e)).toList();

    for (var section in formSections) {
      final fields = section['fields'] as List<dynamic>? ?? [];

      for (var field in fields) {
        final key = field['name'];

        switch (field['type']) {
          case 'text':
          case 'number':
          case 'textarea':
            textControllers[key] = TextEditingController();
            break;

          case 'time':
            timeValues[key] = Rx<String?>(null);
          break;

          case 'select':
            dropdownValues[key] = ''.obs;
            break;

          case 'date':
            dateValues[key] = Rx<String?>(null);
            break;

          case 'file':
            fileValues[key] = Rx<File?>(null);
            break;

          case 'checkbox':
            checkboxValues[key] = false.obs;
            break;
        }
      }
    }
  }

  TextEditingController getTextController(String key) =>
      textControllers[key]!;

  String? getDropdownValue(String key) =>
      dropdownValues[key]?.value.isEmpty == true
          ? null
          : dropdownValues[key]?.value;

  void setDropdownValue(String key, String? value) {
    if (value != null) dropdownValues[key]?.value = value;
  }

  String? getDateValue(String key) => dateValues[key]?.value;

  void selectDate(BuildContext context, String key) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      dateValues[key]?.value =
          DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  File? getFileValue(String key) => fileValues[key]?.value;

  void pickFile(String key) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      fileValues[key]?.value = File(result.files.single.path!);
    }
  }

  bool getCheckboxValue(String key) =>
      checkboxValues[key]?.value ?? false;

  void setCheckboxValue(String key, bool value) =>
      checkboxValues[key]?.value = value;

  bool validateForm() {
    for (var section in formSections) {
      final fields = section['fields'] as List<dynamic>? ?? [];

      for (var field in fields) {
        if (field['required'] == true) {
          final key = field['name'];

          switch (field['type']) {
            case 'text':
            case 'number':
            case 'textarea':
              if (textControllers[key]?.text.isEmpty ?? true) return false;
              break;

            case 'select':
              if (dropdownValues[key]?.value.isEmpty ?? true) return false;
              break;

            case 'time':
              if (timeValues[key]?.value == null) return false;
              break;

            case 'date':
              if (dateValues[key]?.value == null) return false;
              break;

            case 'file':
              if (fileValues[key]?.value == null) return false;
              break;
          }
        }
      }
    }
    return true;
  }

 Future<void> submitForm() async {
  if (isSubmitting.value) return;
  isSubmitting.value = true;

  try {
    if (!validateForm()) {
      final empty = getEmptyFields();
      Get.snackbar(
        'Validasi Gagal',
        'Field wajib belum diisi: ${empty.values.join(', ')}',
        backgroundColor: AppColors.danger,
        colorText: Colors.white,
      );
      return;
    }

    final Map<String, dynamic> collectedData = {};
    for (var section in formSections) {
      final fields = section['fields'] as List<dynamic>? ?? [];
      for (var field in fields) {
        final key = field['name'];
        switch (field['type']) {
          case 'text':
          case 'number':
          case 'textarea':
            collectedData[key] = textControllers[key]?.text;
            break;
          case 'select':
            collectedData[key] = dropdownValues[key]?.value;
            break;
          case 'date':
            collectedData[key] = dateValues[key]?.value;
            break;
          case 'time':
            collectedData[key] = timeValues[key]?.value;
            break;
          case 'checkbox':
            collectedData[key] = checkboxValues[key]?.value ?? false;
            break;
        }
      }
    }

    final user = await StorageService.getUser();
    final token = await StorageService.getToken();
    final now = DateTime.now();
    final tahun = now.year;
    final jam = now.hour.toString().padLeft(2, '0');
    final menit = now.minute.toString().padLeft(2, '0');
    final detik = now.second.toString().padLeft(2, '0');

    final Map<String, dynamic> formDataMap = {
      'desa_id': ApiConstant.desaId,
      'reg': "${tahun}/${suratData['kode']}/${jam}${menit}${detik}",
      'jenis_surat_id': suratData['id'],
      'data_form': jsonEncode(collectedData),
      'status': 'verifikasi',
      'created_by': int.parse(user!.id.toString()),
    };

    final List<dio.MultipartFile> files = [];

    for (var entry in fileValues.entries) {
      final file = entry.value.value;
      if (file != null) {
        files.add(
          await dio.MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        );
      }
    }

    if (files.isNotEmpty) {
      formDataMap['file_surat[]'] = files;
    }

    final dio.FormData formData = dio.FormData.fromMap(formDataMap);

    final response = await DioService.instance.post(
      ApiConstant.tambahSurat,
      data: formData,
      options: dio.Options(
        contentType: 'multipart/form-data',
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 201) {
      Get.snackbar(
        'Sukses',
        'Surat berhasil diajukan',
        backgroundColor: AppColors.bottonGreen,
        colorText: Colors.white,
      );
      Navigator.of(Get.context!).pop();
    } else {
      Get.snackbar(
        'Gagal',
        'Status code: ${response.statusCode}',
        backgroundColor: AppColors.danger,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    Get.snackbar(
      'Error',
      e.toString(),
      backgroundColor: AppColors.danger,
      colorText: Colors.white,
    );
  } finally {
    isSubmitting.value = false;
  }
}


 void selectTime(BuildContext context, String key) async {
  final picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (picked != null) {
    timeValues[key]?.value = picked.format(context);
  }
}

  void initTimeController(String key) {
    if (!timeControllers.containsKey(key)) {
      timeControllers[key] = TextEditingController();
    }
  }

  TextEditingController getTimeController(String key) {
    initTimeController(key);
    return timeControllers[key]!;
  }
  
String? getTimeValue(String key) => timeValues[key]?.value;
  Map<String, String> getEmptyFields() {
    final Map<String, String> emptyFields = {};

    for (var section in formSections) {
      final fields = section['fields'] as List<dynamic>? ?? [];

      for (var field in fields) {
        final key = field['name'];
        final label = field['label'] ?? key;
        final required = field['required'] ?? false;
        final type = field['type'];

        if (!required) continue;

        dynamic value;
        switch (type) {
          case 'text':
          case 'number':
          case 'textarea':
            value = textControllers[key]?.text;
            break;

          case 'select':
            value = dropdownValues[key]?.value;
            break;

          case 'date':
            value = dateValues[key]?.value;
            break;

          case 'time':
            value = timeValues[key]?.value;
            break;

          case 'checkbox':
            value = checkboxValues[key]?.value;
            break;

          case 'file':
            value = fileValues[key]?.value;
            break;
        }

        if (value == null || (value is String && value.trim().isEmpty)) {
          emptyFields[key] = label;
        }
      }
    }

    return emptyFields;
  }

}

