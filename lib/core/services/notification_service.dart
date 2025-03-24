import 'package:get/get.dart';

class NotificationService extends GetxService {
  final _hasNotification = false.obs;

  bool get hasNotification => _hasNotification.value;
}
