import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';
import '../controllers/surat_form_controller.dart';

class SuratFormView extends GetView<SuratFormController> {
  const SuratFormView({super.key});

  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);

    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        title: Obx(() => AutoSizeText(
            controller.suratTitle.value ?? '',
            style: AppText.h5(color: AppColors.secondary),
            maxLines: 1,
            minFontSize: 10,
            overflow: TextOverflow.ellipsis,
          )),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.secondary),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : _buildDynamicForm()),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Obx(() => ElevatedButton(
        onPressed: controller.isSubmitting.value
            ? null
            : () => controller.submitForm(),

        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        child: controller.isSubmitting.value
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                'Ajukan Surat',
                style: AppText.button(color: AppColors.white),
              ),
      ))

      ),
    );
  }

  Widget _buildDynamicForm() {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard(),

        ...controller.formSections.map((section) {
          final sectionTitle = section['section'] ?? '';
          final fields = section['fields'] as List<dynamic>? ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              Text(
                sectionTitle,
                style: AppText.h5(color: AppColors.dark),
              ),

              const SizedBox(height: 16),

              ...fields.map((field) {
                final name = field['name'];
                final label = field['label'] ?? '';
                final hint = field['hint'] ?? '';
                final required = field['required'] ?? false;
                final type = field['type'];
                final max = field['max'];
                final isMaxNow = field['isMaxNow'] ?? false;

                switch (type) {
                  case 'text':
                  case 'textarea':
                    return _buildTextField(
                      name,
                      label,
                      hint,
                      required,
                      type == 'textarea',
                      false,
                      max
                    );

                  case 'number':
                    return _buildNumberField(
                      name,
                      label,
                      hint,
                      required,
                      max
                    );

                  case 'date':
                    return _buildDateField(
                      name,
                      label,
                      hint,
                      required,
                      isMaxNow
                    );

                  case 'select':
                    return _buildDropdownField(
                      name,
                      label,
                      hint,
                      field['options'] ?? [],
                      required,
                    );

                  case 'checkbox':
                    return _buildCheckboxField(
                      name,
                      label,
                    );

                  case 'file':
                    return _buildFileField(
                      name,
                      label,
                      required,
                    );
                  case 'time':
                  return _buildTimeField(
                    name,
                    label,
                    hint,
                    required,
                  );
                  default:
                    return const SizedBox.shrink();
                }
              }).toList(),
            ],
          );
        }).toList(),

        const SizedBox(height: 100),
      ],
    ),
  );
}


 Widget _buildInfoCard() {
  final persyaratanRaw = controller.suratData['persyaratan'];
  final persyaratanLines = <String>[];

  if (persyaratanRaw != null) {
    if (persyaratanRaw is String) {
      persyaratanLines.addAll(persyaratanRaw.replaceAll(r'\n', '\n').split('\n'));
    } else if (persyaratanRaw is List) {
      persyaratanLines.addAll(persyaratanRaw.map((e) => e.toString()));
    }
  }

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.warningCard,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.strokeWarningCard, width: 2),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (persyaratanLines.isNotEmpty) ...[
          Text('Persyaratan:', style: AppText.h6(color: Color(0xFF003750))),
          const SizedBox(height: 8),
          ...persyaratanLines.map((line) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: AppText.bodyMedium(color: AppColors.dark)),
                  Expanded(
                    child: Text(
                      line,
                      style: AppText.bodyMedium(color: AppColors.dark),
                    ),
                  ),
                ],
              )),
        ],
      ],
    ),
  );
}

  Widget _buildTextField(String key, String label, String hint, bool required,
      bool multiline, bool number, int? maxLength) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: label, style: AppText.bodyMedium(color: AppColors.dark)),
                if (required)
                  TextSpan(text: ' *', style: AppText.bodyMedium(color: AppColors.danger)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller.getTextController(key),
            keyboardType: number? TextInputType.number : TextInputType.text,
            maxLines: multiline ? 3 : 1,
            maxLength: maxLength ?? null,
            decoration: InputDecoration(
              counterText: '',
              hintText: hint,
              hintStyle: AppText.bodyMedium(color: AppColors.textSecondary.withOpacity(0.5)),
              filled: true,
              fillColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.dark.withOpacity(0.2)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.dark.withOpacity(0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ]),
      );
    }

  Widget _buildNumberField(String key, String label, String hint, bool required, int? max)=>
      _buildTextField(key, label, hint, required, false, true, max);

  Widget _buildDateField(String key, String label, String hint, bool required, bool isMaxNow) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: label, style: AppText.bodyMedium(color: AppColors.dark)),
              if (required)
                TextSpan(text: ' *', style: AppText.bodyMedium(color: AppColors.danger)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => controller.selectDate(Get.context!, key, isMaxNow),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.dark.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Obx(() => Text(
                        controller.getDateValue(key) ?? hint,
                        style: controller.getDateValue(key) != null
                            ? AppText.bodyMedium(color: AppColors.dark)
                            : AppText.bodyMedium(color: AppColors.textSecondary.withOpacity(0.5)),
                      )),
                ),
                Icon(Icons.calendar_today, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildTimeField(
    String key,
    String label,
    String hint,
    bool required,
) {
  // pastikan controller untuk key ini sudah ada
  final textController = controller.getTimeController(key);

  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: label, style: AppText.bodyMedium(color: AppColors.dark)),
              if (required)
                TextSpan(text: ' *', style: AppText.bodyMedium(color: AppColors.danger)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: textController,
          readOnly: true, // bisa diketik manual
          keyboardType: TextInputType.datetime,
          onTap: () {showDialog(
                  context: Get.context!,
                  builder: (_) => Dialog(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Pilih Waktu", style: AppText.h5()),
                          const SizedBox(height: 8),
                          TimePickerSpinner(
                            is24HourMode: true,
                            normalTextStyle: TextStyle(
                              fontSize: 30,
                              color: AppColors.textSecondary.withOpacity(0.5), 
                              fontWeight: FontWeight.w500,
                            ),
                            highlightedTextStyle: TextStyle(
                              fontSize: 35,
                              color: AppColors.text,
                              fontWeight: FontWeight.bold,
                            ),
                            spacing: 60,
                            itemHeight: 50,
                            isForce2Digits: true,
                            onTimeChange: (time) {
                              final formatted =
                                  "${time.hour.toString().padLeft(2,'0')}:${time.minute.toString().padLeft(2,'0')}";
                              textController.text = formatted;
                              controller.timeValues[key]?.value = formatted;
                            },
                          ),

                          SizedBox(height: AppResponsive.h(1)),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: AppResponsive.padding(horizontal: 14),
                                  child: ElevatedButton(
                                    onPressed: () => Navigator.pop(Get.context!),
                                    child: Text("OK",
                                    style: AppText.bodyMedium(color: AppColors.text),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.border,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
                },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppText.bodyMedium(color: AppColors.textSecondary.withOpacity(0.5)),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.dark.withOpacity(0.2)),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.dark.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildDropdownField(
      String key, String label, String hint, List<dynamic> options, bool required) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: label, style: AppText.bodyMedium(color: AppColors.dark)),
              if (required)
                TextSpan(text: ' *', style: AppText.bodyMedium(color: AppColors.danger)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.dark.withOpacity(0.2)),
          ),
          child: Obx(() => DropdownButton<String>(
                value: controller.getDropdownValue(key),
                hint: Text(hint,
                    style: AppText.bodyMedium(color: AppColors.textSecondary.withOpacity(0.5))),
                isExpanded: true,
                underline: const SizedBox(),
                icon: Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                items: options.map<DropdownMenuItem<String>>((option) {
                  return DropdownMenuItem<String>(
                    value: option.toString(),
                    child: Text(option.toString(), style: AppText.bodyMedium(color: AppColors.dark)),
                  );
                }).toList(),
                onChanged: (value) => controller.setDropdownValue(key, value),
              )),
        ),
      ]),
    );
  }

  Widget _buildCheckboxField(String key, String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Obx(() => Checkbox(
                value: controller.getCheckboxValue(key),
                activeColor: AppColors.primary,
                onChanged: (value) => controller.setCheckboxValue(key, value ?? false),
              )),
          Expanded(
              child: Text(label, style: AppText.bodyMedium(color: AppColors.dark))),
        ],
      ),
    );
  }

  Widget _buildFileField(String key, String label, bool required) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: label, style: AppText.bodyMedium(color: AppColors.dark)),
              if (required)
                TextSpan(text: ' *', style: AppText.bodyMedium(color: AppColors.danger)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => controller.getFileValue(key) != null
            ? _buildSelectedFile(key)
            : _buildFilePicker(key)),
      ]),
    );
  }

  Widget _buildSelectedFile(String key) {
  final file = controller.getFileValue(key);

  if (file == null) return const SizedBox();

  final isImage = file.path.toLowerCase().endsWith('.png') ||
      file.path.toLowerCase().endsWith('.jpg') ||
      file.path.toLowerCase().endsWith('.jpeg') ||
      file.path.toLowerCase().endsWith('.webp');

  return InkWell(
    onTap: () => controller.pickFile(key), // tetap bisa ganti
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.dark.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          if (isImage)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(file.path),
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
          else
            Row(
              children: [
                Icon(Icons.file_present, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    file.path.split('/').last,
                    style: AppText.bodyMedium(color: AppColors.dark),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

          const SizedBox(height: 8),

          Text(
            "Ketuk untuk ganti file",
            style: AppText.pSmallBold(color: AppColors.primary),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildFilePicker(String key) {
    return InkWell(
      onTap: () => controller.pickFile(key),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.dark.withOpacity(0.2)),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.upload_file, color: AppColors.primary, size: 32),
              const SizedBox(height: 12),
              Text('Pilih File', style: AppText.bodyMedium(color: AppColors.primary)),
            ],
          ),
        ),
      ),
    );
  }
}
