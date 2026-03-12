import 'dart:io';
import 'package:camera/camera.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;

class ScanKtpView extends StatefulWidget {
  const ScanKtpView({super.key});

  @override
  State<ScanKtpView> createState() => _ScanKtpViewState();
}

class _ScanKtpViewState extends State<ScanKtpView> {
  CameraController? controller;
  bool isCapturing = false;

  final double frameWidth = 320;
  final double frameHeight = 200;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();

    controller = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await controller!.initialize();

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final previewSize = controller!.value.previewSize!;

    return Scaffold(
      body: Stack(
        children: [

          /// CAMERA FULLSCREEN
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: previewSize.height,
                height: previewSize.width,
                child: CameraPreview(controller!),
              ),
            ),
          ),

          /// FRAME KTP
          Center(
            child: Container(
              width: frameWidth,
              height: frameHeight,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primary,
                  width: 3,
                ),
              ),
            ),
          ),

          /// TEXT LABEL LANCIP
          Positioned(
            top: 110,
            left: 0,
            right: 0,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                child: Text(
                  "Posisikan KTP di dalam frame",
                  style: AppText.h5(
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ),
          ),

          /// CAPTURE BUTTON
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: captureImage,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary,
                      width: 5,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: AppColors.primary,
                    size: 35,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> captureImage() async {
    if (isCapturing) return;

    try {
      isCapturing = true;

      final picture = await controller!.takePicture();
      final file = File(picture.path);

      final bytes = await file.readAsBytes();
      img.Image? original = img.decodeImage(bytes);

      if (original == null) {
        Get.back(result: file);
        return;
      }

      const ratio = 320 / 200;

      int cropWidth = (original.width * 0.7).toInt();
      int cropHeight = (cropWidth / ratio).toInt();

      int offsetX = ((original.width - cropWidth) / 2).toInt();
      int offsetY = ((original.height - cropHeight) / 2).toInt();

      img.Image cropped = img.copyCrop(
        original,
        x: offsetX,
        y: offsetY,
        width: cropWidth,
        height: cropHeight,
      );

      final croppedPath = picture.path.replaceAll(".jpg", "_crop.jpg");

      final croppedFile = File(croppedPath)
        ..writeAsBytesSync(img.encodeJpg(cropped));

      Get.back(result: croppedFile);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal mengambil gambar",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isCapturing = false;
    }
  }
}

/// LABEL BACKGROUND LANCIP
class LabelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width / 2 + 10, size.height);
    path.lineTo(size.width / 2, size.height + 12);
    path.lineTo(size.width / 2 - 10, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(path, Colors.black26, 6, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}