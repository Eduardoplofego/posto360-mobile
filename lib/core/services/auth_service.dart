import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:posto360/core/constants/constants.dart';

class AuthService extends GetxService {
  final _isLogged = RxnBool();
  final _getStorage = GetStorage();

  Future<AuthService> init() async {
    _getStorage.listenKey(Constants.JWT_TOKEN, (value) {
      _isLogged(value != null);
    });

    ever<bool?>(_isLogged, (isLogged) {
      if (isLogged == null || !isLogged) {
        Get.offAllNamed('/login');
      } else {
        Get.offAllNamed('/dashboard');
      }
    });

    _isLogged(getUserId() != null);
    return this;
  }

  void logout() {
    _getStorage.write(Constants.JWT_TOKEN, null);
    _getStorage.write(Constants.USER_KEY, null);
  }

  String? getUserId() {
    if (_getStorage.read(Constants.USER_KEY) == null) return null;

    final jsonUser = _getStorage.read(Constants.USER_KEY);

    return jsonUser['id'];
  }
}
