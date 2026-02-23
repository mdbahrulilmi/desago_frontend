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

  @override
  void onInit() {
    super.onInit();
    initAuth();
    print("🔥 AuthController initialized");
  }

  Future<void> initAuth() async {
    final token = StorageService.getToken();

    print("INIT TOKEN: $token");

    if (token != null && token.isNotEmpty) {

      DioService.instance.options.headers['Authorization'] =
          'Bearer $token';

      await loadUser();
    }
  }

  Future<void> loadUser() async {
    print("========== LOAD USER START ==========");
    try {
      isLoading.value = true;

      final cachedUser = box.read('user');
      final cachedBiodata = box.read('biodata');

      if (cachedUser != null) {
        print("📦 Cached User Found");
        user.value = UserModel.fromJson(cachedUser);
      } else {
        print("📦 No Cached User");
      }

      if (cachedBiodata != null) {
        print("📦 Cached Biodata Found");
        biodata.value = BiodataModel.fromJson(cachedBiodata);
        print("📦 Cached Verification: ${biodata.value?.verification}");
      } else {
        print("📦 No Cached Biodata");
      }

      final token = await StorageService.getToken();
      print("🔑 Token: $token");

      if (token == null) {
        print("❌ Token null, stop loading");
        return;
      }

      print("🌍 Fetching biodata from API...");
      final res = await DioService.instance.get(
        ApiConstant.biodata,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        }),
      );

      print("✅ API Response: ${res.data}");

      final bio = BiodataModel.fromJson(res.data);

      biodata.value = bio;
      print("🔄 Biodata Updated");
      print("🔎 Verification from API: ${bio.verification}");

      box.write('biodata', res.data);
      print("💾 Biodata saved to cache");

      /// 🔹 4️⃣ Isi UserModel ringan
      user.value = UserModel(
        id: bio.id.toString(),
        username: bio.username,
        email: bio.email,
        nama_lengkap: bio.namaLengkap,
        avatar: bio.avatar,
        verified: bio.verification,
      );

      box.write('user', user.value?.toJson());
      print("💾 User saved to cache");

      print("🎯 isVerified: $isVerified");

    } catch (e, stackTrace) {
      print("❌ Auth Error: $e");
      print("📌 StackTrace: $stackTrace");
    } finally {
      isLoading.value = false;
      print("========== LOAD USER END ==========");
    }
  }

  Future<void> refreshVerification() async {
    print("========== REFRESH VERIFICATION START ==========");
    try {
      final token = await StorageService.getToken();
      print("🔑 Token: $token");

      if (token == null) {
        print("❌ Token null, cannot refresh");
        return;
      }

      print("🌍 Refreshing biodata from API...");
      final res = await DioService.instance.get(
        ApiConstant.biodata,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        }),
      );

      print("✅ Refresh API Response: ${res.data}");

      final bio = BiodataModel.fromJson(res.data);

      biodata.value = bio;
      box.write('biodata', res.data);

      print("🔄 Verification Updated To: ${bio.verification}");
      print("🎯 isVerified Now: $isVerified");

    } catch (e, stackTrace) {
      print("❌ Refresh verification error: $e");
      print("📌 StackTrace: $stackTrace");
    }

    print("========== REFRESH VERIFICATION END ==========");
  }
}