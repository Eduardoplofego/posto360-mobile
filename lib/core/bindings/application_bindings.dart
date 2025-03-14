import 'package:get/get.dart';
import 'package:posto360/core/rest_client/rest_client.dart';
import 'package:posto360/core/rest_client/rest_client_impl.dart';

class ApplicationBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RestClient>(() => RestClientImpl(), fenix: true);
  }
}
