import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/toko_controller.dart';

class TokoView extends GetView<TokoController> {
  const TokoView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TokoView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TokoView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
