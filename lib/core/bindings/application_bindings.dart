import 'package:get/get.dart';
import 'package:posto360/core/rest_client/dio/dio_client.dart';
import 'package:posto360/core/rest_client/posto_rest_client.dart';
import 'package:posto360/core/rest_client/rest_client.dart';
import 'package:posto360/core/services/auth_service.dart';

class ApplicationBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostoRestClient>(() => PostoRestClient(), fenix: true);
    Get.lazyPut(() => AuthService());
  }
}
