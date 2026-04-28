import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/mixins/message_mixin.dart';
import 'package:posto360/modules/login/infra/services/login_service.dart';

class LoginController extends GetxController with MessageMixin {
  final LoginService _loginService;
  final _loading = false.obs;
  final _message = Rxn<MessagesModel>();

  bool get loading => _loading.value;

  LoginController({required LoginService loginService})
    : _loginService = loginService;

  @override
  void onInit() {
    super.onInit();
    messageListener(_message);
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    _loading(true);

    final result = await _loginService.login(
      email: username,
      password: password,
    );

    if (result.isError) {
      _loading(false);
      _message(
        MessagesModel(
          title: 'Erro',
          message: result.message,
          type: MessageType.error,
        ),
      );
      return;
    }
    _loading(false);
  }
}
