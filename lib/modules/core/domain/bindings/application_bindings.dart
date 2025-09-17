import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/rest_client/posto_rest_client.dart';
import 'package:posto360/modules/core/domain/services/auth_service.dart';
import 'package:posto360/modules/core/domain/services/notification_service.dart';

class ApplicationBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostoRestClient>(() => PostoRestClient(), fenix: true);
    Get.lazyPut(() => AuthService());
    Get.lazyPut(() => NotificationService());
  }
}
