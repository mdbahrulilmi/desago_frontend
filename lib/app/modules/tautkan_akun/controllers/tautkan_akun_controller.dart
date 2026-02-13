import 'dart:io';
import 'package:desago/app/modules/tautkan_akun_form/controllers/tautkan_akun_form_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:desago/app/routes/app_pages.dart';

class TautkanAkunController extends GetxController {
  final isLoading = false.obs;
  final ktpData = <String, String>{}.obs;
  final rawText = ''.obs;

  final ImagePicker _picker = ImagePicker();

  // ============================== SCAN FUNCTION ==============================
  Future<void> scanKTP() async {
    try {
      isLoading.value = true;
      debugPrint("=== MULAI SCAN KTP ===");

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
      );
      if (image == null) {
        isLoading.value = false;
        debugPrint("Tidak ada gambar diambil");
        return;
      }
      debugPrint("Gambar diambil: ${image.path}");

      final inputImage = InputImage.fromFile(File(image.path));
      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);

      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      // ====== SEBELUM PARSING ======
      rawText.value = recognizedText.text;
      debugPrint("========== RAW OCR ==========");
      debugPrint(rawText.value); // Hasil OCR mentah
      debugPrint("=============================");

      await textRecognizer.close();

      // ====== PARSING ======
      final result = _parseKTP(rawText.value);

      debugPrint("Hasil parsing siap dikirim ke form: $result");

      isLoading.value = false;

      // ====== UPDATE FORM OTOMATIS ======
      final formController =
          Get.put(TautkanAkunFormController(), permanent: true);
      formController.fillFormFromOCR(result);
      formController.ktpImage.value = File(image.path);

      Get.toNamed(Routes.TAUTKAN_AKUN_FORM);

    } catch (e, st) {
      isLoading.value = false;
      debugPrint("ERROR SCAN KTP: $e\n$st");
      Get.snackbar("Error", "Gagal scan KTP");
    }
  }

  // ============================== PARSER KTP ROBUST ==============================
  Map<String, String> _parseKTP(String text) {
    debugPrint("========== PARSING FINAL ==========");

    final result = {
      "nama_lengkap": "",
      "nik": "",
      "berlaku_hingga": "",
      "kewarganegaraan": "",
      "pekerjaan": "",
      "status_perkawinan": "",
      "agama": "",
      "alamat": "",
      "golongan_darah": "",
      "tanggal_lahir": "",
      "tempat_lahir": "",
    };

    final lines = text
        .split("\n")
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];

      final nikMatch = RegExp(r"\b\d{16}\b").firstMatch(line);
      if (nikMatch != null) {
        result["nik"] = nikMatch.group(0)!;
        if (i + 1 < lines.length) {
          result["nama_lengkap"] = lines[i + 1].replaceAll(":", "").trim();
        }
        continue;
      }

      if (line.contains(",") && RegExp(r"\d{2}-\d{2}-\d{4}").hasMatch(line)) {
        final parts = line.split(",");
        if (parts.length == 2) {
          result["tempat_lahir"] = parts[0].replaceAll(":", "").trim();
          result["tanggal_lahir"] = parts[1].replaceAll(":", "").trim();
        }
        continue;
      }

      final agamaList = ["ISLAM", "KRISTEN", "KATOLIK", "HINDU", "BUDDHA","KONGHUCU"];

if (line.toUpperCase().contains("JL") || line.toUpperCase().contains("JALAN")) {
  List<String> alamatParts = [];
  for (int j = i; j < lines.length; j++) {
    String nextLine = lines[j].trim();

    // Stop collecting if the line contains other known fields
    if (nextLine.toUpperCase().contains("AGAMA") ||
        nextLine.toUpperCase().contains("STATUS") ||
        nextLine.toUpperCase().contains("PEKERJAAN") ||
        nextLine.contains("WNI") ||
        nextLine.contains("WNA") ||
        RegExp(r"Gol").hasMatch(nextLine) ||
        nextLine.toUpperCase().contains("BERLAKU") ||
        agamaList.any((a) => nextLine.toUpperCase().contains(a))) break;

    // Remove leading colon if any
    if (nextLine.startsWith(":")) nextLine = nextLine.substring(1).trim();

    alamatParts.add(nextLine);
  }
  result["alamat"] = alamatParts.join(", ");
}

      for (var agama in agamaList) {
        if (line.toUpperCase().contains(agama)) {
          result["agama"] = agama;
          break;
        }
      }

      final statusMatch = RegExp(
        r"STATUS\s*PERKAWINAN\s*:?\s*(.+)",
        caseSensitive: false,
      ).firstMatch(line);
      if (statusMatch != null) {
        result["status_perkawinan"] = statusMatch.group(1)!.trim();
        continue;
      }

      if (["SWASTA", "PEGAWAI", "WIRASWASTA"]
          .any((p) => line.toUpperCase().contains(p))) {
        result["pekerjaan"] = line
            .replaceAll("SWNASTA", "SWASTA")
            .replaceAll("PEGANAI", "PEGAWAI")
            .replaceAll(":", "")
            .trim();
        continue;
      }

      if (line.toUpperCase().contains("WNI") || line.toUpperCase().contains("WNA")) {
        result["kewarganegaraan"] =
            line.toUpperCase().contains("WNI") ? "WNI" : "WNA";
        continue;
      }

      final golMatch = RegExp(r"Gol.*?\s*([ABO]{1,2})").firstMatch(line);
      if (golMatch != null) {
        result["golongan_darah"] = golMatch.group(1)!;
        continue;
      }

      if (line.toUpperCase().contains("BERLAKU")) {
        for (int j = i + 1; j < i + 6 && j < lines.length; j++) {
          String nextLine = lines[j].replaceAll(" ", "").replaceAll(":", "").trim();
          final dateRegex = RegExp(r"\d{2}-\d{2}-\d{4}");
          if (dateRegex.hasMatch(nextLine)) {
            result["berlaku_hingga"] = nextLine;
            break;
          }
        }
        continue;
      }
    }

    ktpData.value = result;

    debugPrint("========== HASIL FINAL ==========");
    result.forEach((k, v) => debugPrint("$k : $v"));
    debugPrint("==================================");

    return result;
  }
}
