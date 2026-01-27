import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_text.dart';

class SuratFormController extends GetxController {
  final isLoading = true.obs;

  // Info surat
  final suratId = ''.obs;
  final suratTitle = ''.obs;
  final RxMap suratData = {}.obs;

  // Form dynamic fields
  late List<Map<String, dynamic>> formFields;

  // Controllers / state for each field
  final Map<String, TextEditingController> textControllers = {};
  final Map<String, RxString> dropdownValues = {};
  final Map<String, Rx<String?>> dateValues = {};
  final Map<String, Rx<File?>> fileValues = {};
  final Map<String, RxBool> checkboxValues = {};

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      suratId.value = Get.arguments['suratId'] ?? '';
      suratTitle.value = Get.arguments['suratTitle'] ?? 'Form Surat';
      suratData.assignAll(Get.arguments['suratData'] ?? {});
    }

    // Load form schema dari API
    setupFormSchema();
    isLoading.value = false;
  }

  /// =========================
  /// Setup Form dari API
  /// =========================
  void setupFormSchema() {
    if (suratData['form_schema'] == null) {
      formFields = [];
      return;
    }

    List<dynamic> rawFields;
    if (suratData['form_schema'] is String) {
      rawFields = jsonDecode(suratData['form_schema']);
    } else if (suratData['form_schema'] is List) {
      rawFields = suratData['form_schema'];
    } else {
      rawFields = [];
    }

    formFields = rawFields.map((e) => Map<String, dynamic>.from(e)).toList();

    // Init controllers
    for (var field in formFields) {
      final key = field['name'];
      switch (field['type']) {
        case 'text':
        case 'number':
        case 'textarea':
          textControllers[key] = TextEditingController();
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

  /// =========================
  /// Helpers
  /// =========================
  TextEditingController getTextController(String key) => textControllers[key]!;

  String? getDropdownValue(String key) =>
      dropdownValues[key]?.value.isEmpty == true ? null : dropdownValues[key]?.value;

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
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.primary,
            colorScheme: ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) dateValues[key]?.value = DateFormat('dd/MM/yyyy').format(picked);
  }

  File? getFileValue(String key) => fileValues[key]?.value;

  void pickFile(String key) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) fileValues[key]?.value = File(result.files.single.path!);
  }

  bool getCheckboxValue(String key) => checkboxValues[key]?.value ?? false;

  void setCheckboxValue(String key, bool value) => checkboxValues[key]?.value = value;

  /// =========================
  /// Validasi & Submit
  /// =========================
  bool validateForm() {
    bool isValid = true;
    for (var field in formFields) {
      if (field['required'] == true) {
        final key = field['name'];
        switch (field['type']) {
          case 'text':
          case 'number':
          case 'textarea':
            if ((textControllers[key]?.text.isEmpty ?? true)) isValid = false;
            break;
          case 'select':
            if ((dropdownValues[key]?.value.isEmpty ?? true)) isValid = false;
            break;
          case 'date':
            if ((dateValues[key]?.value == null)) isValid = false;
            break;
          case 'file':
            if ((fileValues[key]?.value == null)) isValid = false;
            break;
        }
      }
    }
    return isValid;
  }

  void submitForm() {
    if (!validateForm()) {
      Get.snackbar('Validasi Gagal', 'Mohon lengkapi semua field yang wajib diisi',
          backgroundColor: AppColors.danger.withOpacity(0.9),
          colorText: AppColors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Simulasi submit
    print('Submit data:');
    final Map<String, dynamic> payload = {};
    for (var field in formFields) {
      final key = field['name'];
      switch (field['type']) {
        case 'text':
        case 'number':
        case 'textarea':
          payload[key] = textControllers[key]?.text;
          break;
        case 'select':
          payload[key] = dropdownValues[key]?.value;
          break;
        case 'date':
          payload[key] = dateValues[key]?.value;
          break;
        case 'file':
          payload[key] = fileValues[key]?.value?.path;
          break;
      }
    }
    print(payload);
  }
}
