import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:posto360/core/constants/constants.dart';

import 'package:posto360/models/user_model.dart';

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
        Get.offAllNamed('/dash');
      }
    });

    _isLogged(getUserId() != null);
    return this;
  }

  void logout() {
    _getStorage.write(Constants.JWT_TOKEN, null);
    _getStorage.write(Constants.USER_KEY, null);
  }

  UserModel? getUserId() {
    if (_getStorage.read(Constants.USER_KEY) == null) return null;

    return UserModel.fromMap(_getStorage.read(Constants.USER_KEY));
  }
}
