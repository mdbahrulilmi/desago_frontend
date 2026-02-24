import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/models/BiodataModel.dart';
import 'package:desago/app/models/UserModel.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:desago/app/services/storage_services.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final box = GetStorage();

  Rxn<UserModel> user = Rxn<UserModel>();
  Rxn<BiodataModel> biodata = Rxn<BiodataModel>();
  RxBool isLoading = true.obs;

  bool get isVerified => biodata.value?.isVerified ?? false;
  bool get isPending => biodata.value?.isPending ?? false;

  @override
  void onInit() {
    super.onInit();
    initAuth();
    print("🔥 AuthController initialized");
  }

  Future<void> initAuth() async {
    final token = StorageService.getToken();

    if (token != null && token.isNotEmpty) {

      DioService.instance.options.headers['Authorization'] =
          'Bearer $token';

      await loadUser();
    }
  }

  Future<void> loadUser() async {
    try {
      isLoading.value = true;

      final cachedUser = box.read('user');
      final cachedBiodata = box.read('biodata');

      if (cachedUser != null) {
        user.value = UserModel.fromJson(cachedUser);
      } else {
      }

      if (cachedBiodata != null) {
        biodata.value = BiodataModel.fromJson(cachedBiodata);
      } else {
      }

      final token = await StorageService.getToken();

      if (token == null) {
        return;
      }

      final res = await DioService.instance.get(
        ApiConstant.biodata,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        }),
      );

      final bio = BiodataModel.fromJson(res.data);

      biodata.value = bio;

      box.write('biodata', res.data);

      user.value = UserModel(
        id: bio.id.toString(),
        username: bio.username,
        email: bio.email,
        nama_lengkap: bio.namaLengkap,
        phone: bio.noTelepon,
        avatar: bio.avatar,
        verified: bio.verification,
      );

      box.write('user', user.value?.toJson());

    } catch (e, stackTrace) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshVerification() async {
    try {
      final token = await StorageService.getToken();

      if (token == null) {
        return;
      }

      final res = await DioService.instance.get(
        ApiConstant.biodata,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        }),
      );

      final bio = BiodataModel.fromJson(res.data);

      biodata.value = bio;
      box.write('biodata', res.data);

    } catch (e, stackTrace) {
    }
  }
}