import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:posto360/modules/core/domain/constants/constants.dart';
import 'package:posto360/modules/core/domain/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService extends GetxService {
  final _isLogged = RxnBool();
  final _getStorage = GetStorage();
  final _authenticatedUser = Rxn<UserModel>();

  UserModel? get authenticatedUser => getUser();

  SupabaseClient? get clientSupabase => Supabase.instance.client;

  Future<AuthService> init() async {
    await Future.delayed(const Duration(seconds: 2));
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

    _isLogged(getUser() != null);
    return this;
  }

  void logout() {
    _getStorage.write(Constants.JWT_TOKEN, null);
    _getStorage.write(Constants.USER_KEY, null);
    _getStorage.write(Constants.CAMPANHAS_CONTROLLER, null);
    _getStorage.write(Constants.USER_PHOTO_URL, null);
  }

  UserModel? getUser() {
    if (_getStorage.read(Constants.USER_KEY) == null) return null;

    final userJson = _getStorage.read(Constants.USER_KEY);

    _authenticatedUser.value = UserModel.fromMap(userJson);

    return UserModel.fromMap(userJson);
  }
}
