import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/otp_verifikasi_controller.dart';

class OtpVerifikasiView extends GetView<OtpVerifikasiController> {
  const OtpVerifikasiView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OtpVerifikasiView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'OtpVerifikasiView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
