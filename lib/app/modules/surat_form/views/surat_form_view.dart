import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/surat_form_controller.dart';

class SuratFormView extends GetView<SuratFormController> {
  const SuratFormView({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Initialize responsive sizing
    AppResponsive().init(context);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundScaffold,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Obx(() => Text(
          'Form ${controller.suratTitle.value}',
          style: AppText.h5(color: AppColors.dark),
        )),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.dark),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() => controller.isLoading.value
        ? Center(child: CircularProgressIndicator())
        : _buildDynamicForm()
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () => controller.submitForm(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Ajukan Surat',
            style: AppText.button(color: AppColors.white),
          ),
        ),
      ),
    );
  }
  
  Widget _buildDynamicForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Informasi surat
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.dark.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.suratTitle.value,
                  style: AppText.h5(color: AppColors.dark),
                ),
                SizedBox(height: 8),
                Text(
                  controller.suratData['description'] ?? '',
                  style: AppText.bodyMedium(color: AppColors.textSecondary),
                ),
                SizedBox(height: 16),
                
                // Persyaratan
                Text(
                  'Persyaratan:',
                  style: AppText.h6(color: AppColors.dark),
                ),
                SizedBox(height: 8),
                ...List.generate(
                  (controller.suratData['persyaratan'] as List?)?.length ?? 0,
                  (index) => Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• ', style: AppText.bodyMedium(color: AppColors.dark)),
                        Expanded(
                          child: Text(
                            controller.suratData['persyaratan'][index],
                            style: AppText.bodyMedium(color: AppColors.dark),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Estimasi: ${controller.suratData['estimasi'] ?? 'N/A'}',
                  style: AppText.pSmallBold(color: AppColors.primary),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 24),
          Text(
            'Data Pemohon',
            style: AppText.h5(color: AppColors.dark),
          ),
          SizedBox(height: 16),
          
          // Form fields dinamis
          ...controller.formFields.map((field) {
            switch(field['type']) {
              case 'text':
                return _buildTextField(
                  field['key'],
                  field['label'],
                  field['hint'],
                  field['required'] ?? false,
                  field['multiline'] ?? false,
                );
              case 'number':
                return _buildNumberField(
                  field['key'],
                  field['label'],
                  field['hint'],
                  field['required'] ?? false,
                );
              case 'date':
                return _buildDateField(
                  field['key'],
                  field['label'],
                  field['hint'],
                  field['required'] ?? false,
                );
              case 'dropdown':
                return _buildDropdownField(
                  field['key'],
                  field['label'],
                  field['hint'],
                  field['options'],
                  field['required'] ?? false,
                );
              case 'checkbox':
                return _buildCheckboxField(
                  field['key'],
                  field['label'],
                );
              case 'file':
                return _buildFileField(
                  field['key'],
                  field['label'],
                  field['required'] ?? false,
                );
              case 'section':
                return _buildSectionHeader(field['label']);
              default:
                return SizedBox.shrink();
            }
          }).toList(),
          
          SizedBox(height: 100), // Space at bottom for the floating button
        ],
      ),
    );
  }
  
  // Text Field
  Widget _buildTextField(String key, String label, String hint, bool required, bool multiline) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: AppText.bodyMedium(color: AppColors.dark),
                ),
                if (required)
                  TextSpan(
                    text: ' *',
                    style: AppText.bodyMedium(color: AppColors.danger),
                  ),
              ],
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: controller.getTextController(key),
            maxLines: multiline ? 3 : 1,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppText.bodyMedium(color: AppColors.textSecondary.withOpacity(0.5)),
              filled: true,
              fillColor: AppColors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        ],
      ),
    );
  }
  
  // Number Field
  Widget _buildNumberField(String key, String label, String hint, bool required) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: AppText.bodyMedium(color: AppColors.dark),
                ),
                if (required)
                  TextSpan(
                    text: ' *',
                    style: AppText.bodyMedium(color: AppColors.danger),
                  ),
              ],
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: controller.getTextController(key),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppText.bodyMedium(color: AppColors.textSecondary.withOpacity(0.5)),
              filled: true,
              fillColor: AppColors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        ],
      ),
    );
  }
  
  // Date Field
  Widget _buildDateField(String key, String label, String hint, bool required) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: AppText.bodyMedium(color: AppColors.dark),
                ),
                if (required)
                  TextSpan(
                    text: ' *',
                    style: AppText.bodyMedium(color: AppColors.danger),
                  ),
              ],
            ),
          ),
          SizedBox(height: 8),
          InkWell(
            onTap: () =>  controller.selectDate(Get.context!, key),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        ],
      ),
    );
  }
  
  // Dropdown Field
  Widget _buildDropdownField(String key, String label, String hint, List<dynamic> options, bool required) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: AppText.bodyMedium(color: AppColors.dark),
                ),
                if (required)
                  TextSpan(
                    text: ' *',
                    style: AppText.bodyMedium(color: AppColors.danger),
                  ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.dark.withOpacity(0.2)),
            ),
            child: Obx(() => DropdownButton<String>(
              value: controller.getDropdownValue(key),
              hint: Text(
                hint,
                style: AppText.bodyMedium(color: AppColors.textSecondary.withOpacity(0.5)),
              ),
              isExpanded: true,
              underline: SizedBox(),
              icon: Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
              items: options.map((option) {
                return DropdownMenuItem<String>(
                  value: option['value'],
                  child: Text(
                    option['label'],
                    style: AppText.bodyMedium(color: AppColors.dark),
                  ),
                );
              }).toList(),
              onChanged: (value) => controller.setDropdownValue(key, value),
            )),
          ),
        ],
      ),
    );
  }
  
  // Checkbox Field
  Widget _buildCheckboxField(String key, String label) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Obx(() => Checkbox(
            value: controller.getCheckboxValue(key),
            activeColor: AppColors.primary,
            onChanged: (value) => controller.setCheckboxValue(key, value ?? false),
          )),
          Expanded(
            child: Text(
              label,
              style: AppText.bodyMedium(color: AppColors.dark),
            ),
          ),
        ],
      ),
    );
  }
  
  // File Field
  Widget _buildFileField(String key, String label, bool required) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: AppText.bodyMedium(color: AppColors.dark),
                ),
                if (required)
                  TextSpan(
                    text: ' *',
                    style: AppText.bodyMedium(color: AppColors.danger),
                  ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Obx(() => controller.getFileValue(key) != null
            ? Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.dark.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.file_present, color: AppColors.primary),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        controller.getFileValue(key)?.path.split('/').last ?? 'File selected',
                        style: AppText.bodyMedium(color: AppColors.dark),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: AppColors.danger),
                      onPressed: () => controller.removeFile(key),
                    ),
                  ],
                ),
              )
            : InkWell(
                onTap: () => controller.pickFile(key),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.dark.withOpacity(0.2)),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.upload_file, color: AppColors.primary, size: 32),
                        SizedBox(height: 8),
                        Text(
                          'Pilih File',
                          style: AppText.bodyMedium(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ),
        ],
      ),
    );
  }
  
  // Section Header
  Widget _buildSectionHeader(String label) {
    return Container(
      margin: EdgeInsets.only(bottom: 16, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          SizedBox(height: 8),
          Text(
            label,
            style: AppText.h6(color: AppColors.dark),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}