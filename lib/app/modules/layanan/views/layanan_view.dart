import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/layanan_controller.dart';

class LayananView extends GetView<LayananController> {
  const LayananView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LayananView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'LayananView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
