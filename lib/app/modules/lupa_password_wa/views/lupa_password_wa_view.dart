import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:remixicon/remixicon.dart';

import '../controllers/lupa_password_wa_controller.dart';

class LupaPasswordWaView extends GetView<LupaPasswordWaController> {
  const LupaPasswordWaView({super.key});
  @override
 Widget build(BuildContext context) {
   AppResponsive().init(context);
   
   return Scaffold(
     backgroundColor: AppColors.white,
     body: SafeArea(
       child: SingleChildScrollView(
         child: Padding(
           padding: AppResponsive.padding(horizontal: 6, top: 4),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Center(
                 child: Image.asset(
                   'assets/img/logo.png',
                   width: AppResponsive.w(65),
                   height: AppResponsive.h(15),
                   fit: BoxFit.contain,
                 ),
               ),
               SizedBox(height: AppResponsive.h(4)),
               Text(
                 'Reset via WhatsApp',
                 style: AppText.h4(color: AppColors.primary),
               ),
               SizedBox(height: AppResponsive.h(2)),
               Text(
                 'Masukkan nomor WhatsApp yang terdaftar untuk menerima link reset password',
                 style: AppText.bodyMedium(color: AppColors.textSecondary),
               ),
               SizedBox(height: AppResponsive.h(4)),
               Form(
                 key: controller.formKey,
                 child: TextFormField(
                   controller: controller.phoneController,
                   style: AppText.bodyMedium(color: AppColors.dark),
                   keyboardType: TextInputType.phone,
                   onChanged: (value) => controller.formatPhoneNumber(value),
                   validator: (value) => controller.validatePhone(value),
                   decoration: InputDecoration(
                     hintText: 'Masukkan nomor WhatsApp',
                     hintStyle: AppText.bodyMedium(color: AppColors.textSecondary),
                     prefixIcon: Icon(Remix.whatsapp_line, color: AppColors.textSecondary),
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(8),
                       borderSide: BorderSide(color: AppColors.muted),
                     ),
                     enabledBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(8),
                       borderSide: BorderSide(color: AppColors.muted),
                     ),
                     focusedBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(8),
                       borderSide: BorderSide(color: AppColors.primary),
                     ),
                     errorBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(8),
                       borderSide: BorderSide(color: AppColors.danger),
                     ),
                   ),
                   cursorColor: AppColors.dark,
                 ),
               ),
               SizedBox(height: AppResponsive.h(4)),
               Obx(() => SizedBox(
                 width: double.infinity,
                 height: AppResponsive.h(6),
                 child: ElevatedButton(
                   onPressed: controller.isLoading.value ? null : () => controller.onSubmit(),
                   style: ElevatedButton.styleFrom(
                     backgroundColor: AppColors.primary,
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(8),
                     ),
                   ),
                   child: controller.isLoading.value
                       ? Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             SizedBox(
                               height: AppResponsive.h(3),
                               width: AppResponsive.h(3),
                               child: CircularProgressIndicator(
                                 color: AppColors.white,
                                 strokeWidth: 2,
                               ),
                             ),
                             SizedBox(width: AppResponsive.w(2)),
                             Text(
                               'Memproses...',
                               style: AppText.button(color: AppColors.white),
                             ),
                           ],
                         )
                       : Text(
                           'Kirim',
                           style: AppText.button(color: AppColors.white),
                         ),
                 ),
               )),
               SizedBox(height: AppResponsive.h(2)),
               SizedBox(
                 width: double.infinity,
                 height: AppResponsive.h(6),
                 child: ElevatedButton.icon(
                   onPressed: () => Get.back(),
                   icon: Icon(
                     Remix.arrow_left_line,
                     color: AppColors.white,
                   ),
                   label: Text(
                     'Kembali',
                     style: AppText.button(color: AppColors.white),
                   ),
                   style: ElevatedButton.styleFrom(
                     backgroundColor: AppColors.primary,
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(8),
                     ),
                   ),
                 ),
               ),
             ],
           ),
         ),
       ),
     ),
   );
 }
}
