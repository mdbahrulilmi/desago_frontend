import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:desago/app/services/storage_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AktivitasController extends GetxController {
  final RxList<Map<String, dynamic>> aktivitas = <Map<String, dynamic>>[].obs;

  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;

  final ScrollController scrollController = ScrollController();

  int currentPage = 1;
  int lastPage = 1;

  @override
  void onInit() {
    super.onInit();
    fetchAktivitas();
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
  if (!scrollController.hasClients) return;

  final threshold = 100.0;

  if (scrollController.position.extentAfter < threshold &&
      !isLoadingMore.value &&
      !isLoading.value &&
      currentPage < lastPage) {
    loadMore();
    }
  }

  Future<void> fetchAktivitas({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        currentPage = 1;
        lastPage = 1;
        aktivitas.clear();
      }

      isLoading.value = true;

      final token = StorageService.getToken();

      final res = await DioService.instance.get(
        ApiConstant.aktivitas,
        queryParameters: {
          'page': currentPage,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (res.data == null) return;

      final body = res.data;
      final List data = body['data'] ?? [];

      currentPage = body['current_page'] ?? 1;
      lastPage = body['last_page'] ?? 1;

      aktivitas.assignAll(
        data.cast<Map<String, dynamic>>(),
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients &&
            scrollController.position.maxScrollExtent == 0 &&
            currentPage < lastPage) {
          loadMore();
        }
      });

    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (currentPage >= lastPage) return;

    try {
      isLoadingMore.value = true;
      final nextPage = currentPage + 1;

      final token = StorageService.getToken();

      final res = await DioService.instance.get(
        ApiConstant.aktivitas,
        queryParameters: {
          'page': nextPage,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (res.data == null) return;

      final body = res.data;
      final List data = body['data'] ?? [];

      currentPage = body['current_page'] ?? nextPage;
      lastPage = body['last_page'] ?? lastPage;

      aktivitas.addAll(
        data.cast<Map<String, dynamic>>(),
      );

    } catch (e) {
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshAktivitas() async {
    await fetchAktivitas(isRefresh: true);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
