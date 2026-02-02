import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/mixins/loader_mixin.dart';
import 'package:posto360/modules/core/domain/mixins/message_mixin.dart';
import 'package:posto360/modules/login/infra/services/login_service.dart';

class LoginController extends GetxController with LoaderMixin, MessageMixin {
  final LoginService _loginService;
  final _loader = false.obs;
  final _message = Rxn<MessagesModel>();

  LoginController({required LoginService loginService})
    : _loginService = loginService;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loader);
    messageListener(_message);
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    _loader.toggle();

    final result = await _loginService.login(
      email: username,
      password: password,
    );

    if (result.isError) {
      _loader.toggle();
      _message(
        MessagesModel(
          title: 'Erro',
          message: result.message,
          type: MessageType.error,
        ),
      );
    } else {
      _loader.toggle();
    }
  }
}
