import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../utils/app_colors.dart';
import '../utils/app_responsive.dart';
import '../utils/app_text.dart';

class AppDialog {
  static const String _successLottie = 'assets/lottie/ok.json';
  static const String _errorLottie = 'assets/lottie/error.json';
  static const String _askLottie = 'assets/lottie/ask.json';
  static const String _infoLottie = 'assets/lottie/info.json';

  static Future<void> success({
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onConfirm,
    bool barrierDismissible = true,
  }) async {
    return Get.dialog(
      _buildDialog(
        lottieAsset: _successLottie,
        title: title,
        message: message,
        confirmText: buttonText,
        onConfirm: onConfirm,
        confirmColor: AppColors.success,
        barrierDismissible: barrierDismissible,
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<void> error({
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onConfirm,
    bool barrierDismissible = true,
  }) async {
    return Get.dialog(
      _buildDialog(
        lottieAsset: _errorLottie,
        title: title,
        message: message,
        confirmText: buttonText,
        onConfirm: onConfirm,
        confirmColor: AppColors.danger,
        barrierDismissible: barrierDismissible,
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<void> info({
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onConfirm,
    bool barrierDismissible = true,
  }) async {
    return Get.dialog(
      _buildDialog(
        lottieAsset: _infoLottie,
        title: title,
        message: message,
        confirmText: buttonText,
        onConfirm: onConfirm,
        confirmColor: AppColors.info,
        barrierDismissible: barrierDismissible,
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<bool?> ask({
    required String title,
    required String message,
    String confirmText = 'Ya',
    String cancelText = 'Tidak',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) async {
    return Get.dialog<bool>(
      _buildDialog(
        lottieAsset: _askLottie,
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: () {
          if (onConfirm != null) onConfirm();
          Get.back(result: true);
        },
        onCancel: () {
          if (onCancel != null) onCancel();
          Get.back(result: false);
        },
        confirmColor: AppColors.info,
        cancelColor: AppColors.textSecondary,
        showCancelButton: true,
        barrierDismissible: barrierDismissible,
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  static Widget _buildDialog({
    required String lottieAsset,
    required String title,
    required String message,
    required String confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Color confirmColor = AppColors.primary,
    Color cancelColor = AppColors.textSecondary,
    bool showCancelButton = false,
    bool barrierDismissible = true,
  }) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: AppResponsive.padding(horizontal: 4),
      elevation: 0,
      child: Container(
        width: AppResponsive.w(90),
        padding: AppResponsive.padding(all: 4),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              lottieAsset,
              width: AppResponsive.w(30),
              height: AppResponsive.h(15),
              repeat: true,
              animate: true,
            ),            
            SizedBox(height: AppResponsive.h(2)),
            Text(
              title,
              style: AppText.h5(color: AppColors.dark),
              textAlign: TextAlign.center,
            ),   
            SizedBox(height: AppResponsive.h(1)),
            Text(
              message,
              style: AppText.bodyMedium(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppResponsive.h(3)),
            Row(
              mainAxisAlignment: showCancelButton 
                  ? MainAxisAlignment.spaceEvenly 
                  : MainAxisAlignment.center,
              children: [
                if (showCancelButton)
                  _buildButton(
                    text: cancelText ?? 'Cancel',
                    onPressed: onCancel ?? () => Get.back(result: false),
                    backgroundColor: AppColors.light,
                    textColor: cancelColor,
                    width: 40,
                  ),
                _buildButton(
                  text: confirmText,
                  onPressed: onConfirm ?? () => Get.back(result: true),
                  backgroundColor: confirmColor,
                  textColor: AppColors.white,
                  width: showCancelButton ? 40 : 80,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color textColor,
    required double width,
  }) {
    return SizedBox(
      width: AppResponsive.w(width),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: AppResponsive.padding(vertical: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: AppText.button(color: textColor),
        ),
      ),
    );
  }
}