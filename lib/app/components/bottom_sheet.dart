import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import '../utils/app_colors.dart';
import '../utils/app_responsive.dart';
import '../utils/app_text.dart';

class AppBottomSheet {
  /// Bottom Sheet dasar dengan judul, pesan, dan konten custom
  static Future<T?> show<T>({
    String? title,
    String? message,
    required List<Widget> content,
    bool isDismissible = true,
    Color? backgroundColor,
    double? height,
  }) {
    return Get.bottomSheet<T>(
      _buildBottomSheet(
        title: title,
        message: message,
        content: content,
        showCancelButton: false,
        backgroundColor: backgroundColor,
        height: height,
      ),
      isDismissible: isDismissible,
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  /// Bottom Sheet dengan opsi picker (digunakan untuk pilihan sederhana)
  static Future<T?> picker<T>({
    String? title,
    String? message,
    required List<BottomSheetOption<T>> options,
    bool showCancelButton = true,
    String cancelText = 'Batal',
    Color? backgroundColor,
    double? height,
  }) {
    return Get.bottomSheet<T>(
      _buildBottomSheet(
        title: title,
        message: message,
        content: options.map((option) => _buildOptionItem<T>(option)).toList(),
        showCancelButton: showCancelButton,
        cancelText: cancelText,
        backgroundColor: backgroundColor,
        height: height,
      ),
      isDismissible: true,
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  /// Bottom Sheet khusus untuk pilihan avatar (galeri/kamera)
  static Future<bool?> avatarPicker({
    String title = 'Pilih Foto Profil',
    String message = 'Pilih foto dari galeri atau ambil foto baru',
    required VoidCallback onGallery,
    required VoidCallback onCamera,
    String galleryText = 'Galeri',
    String cameraText = 'Kamera',
    String cancelText = 'Batal',
    Color? backgroundColor,
  }) {
    return Get.bottomSheet<bool>(
      _buildBottomSheet(
        title: title,
        message: message,
        content: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAvatarOption(
                icon: Remix.image_line,
                title: galleryText,
                color: AppColors.info,
                onTap: () {
                  Get.back(result: true);
                  onGallery();
                },
              ),
              _buildAvatarOption(
                icon: Remix.camera_3_line,
                title: cameraText,
                color: AppColors.primary,
                onTap: () {
                  Get.back(result: true);
                  onCamera();
                },
              ),
            ],
          ),
        ],
        showCancelButton: true,
        cancelText: cancelText,
        backgroundColor: backgroundColor,
      ),
      isDismissible: true,
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  /// Widget builder untuk bottom sheet
  static Widget _buildBottomSheet({
    String? title,
    String? message,
    required List<Widget> content,
    bool showCancelButton = true,
    String cancelText = 'Batal',
    Color? backgroundColor,
    double? height,
  }) {
    return Container(
      padding: AppResponsive.padding(all: 4),
      constraints: BoxConstraints(
        maxHeight: height ?? AppResponsive.h(50),
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Handle bar
          Container(
            width: AppResponsive.w(10),
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.muted,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(height: AppResponsive.h(2)),
          
          // Title
          if (title != null) ...[
            Text(
              title,
              style: AppText.h5(color: AppColors.dark),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppResponsive.h(1)),
          ],
          
          // Message
          if (message != null) ...[
            Text(
              message,
              style: AppText.bodyMedium(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppResponsive.h(3)),
          ],
          
          // Content
          ...content,
          
          // Space before cancel button
          if (showCancelButton) SizedBox(height: AppResponsive.h(3)),
          
          // Cancel button
          if (showCancelButton)
            InkWell(
              onTap: () => Get.back(result: null),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: double.infinity,
                padding: AppResponsive.padding(vertical: 1.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.primary,
                ),
                alignment: Alignment.center,
                child: Text(
                  cancelText,
                  style: AppText.button(color: AppColors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Widget untuk pilihan avatar (galeri/kamera)
  static Widget _buildAvatarOption({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: AppResponsive.w(35),
        padding: AppResponsive.padding(vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: color.withOpacity(0.1),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: AppResponsive.w(8),
              ),
            ),
            SizedBox(height: AppResponsive.h(1)),
            Text(
              title,
              style: AppText.bodyLarge(color: color),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget untuk item pilihan dalam bottom sheet
  static Widget _buildOptionItem<T>(BottomSheetOption<T> option) {
    return InkWell(
      onTap: () => Get.back(result: option.value),
      child: Container(
        width: double.infinity,
        padding: AppResponsive.padding(vertical: 1.5, horizontal: 2),
        margin: AppResponsive.margin(bottom: 1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: option.backgroundColor ?? AppColors.muted.withOpacity(0.3),
        ),
        child: Row(
          children: [
            if (option.icon != null) ...[
              Icon(
                option.icon,
                color: option.iconColor ?? AppColors.dark,
                size: AppResponsive.w(6),
              ),
              SizedBox(width: AppResponsive.w(3)),
            ],
            Expanded(
              child: Text(
                option.text,
                style: option.textStyle ?? AppText.bodyLarge(color: AppColors.dark),
              ),
            ),
            if (option.trailing != null) option.trailing!,
          ],
        ),
      ),
    );
  }
}

/// Class untuk merepresentasikan opsi dalam bottom sheet
class BottomSheetOption<T> {
  final String text;
  final T value;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final Widget? trailing;

  BottomSheetOption({
    required this.text,
    required this.value,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.textStyle,
    this.trailing,
  });
}