import 'package:get_storage/get_storage.dart';
import 'package:posto360/core/constants/constants.dart';
import 'package:posto360/core/dto/result_action_dto.dart';
import 'package:posto360/core/exceptions/user_not_found_exception.dart';
import 'package:posto360/core/exceptions/wrong_credentials_exception.dart';
import 'package:posto360/repositories/auth/login/login_repository.dart';

import './login_service.dart';

class LoginServiceImpl extends LoginService {
  final LoginRepository _loginRepository;

  LoginServiceImpl({required LoginRepository loginRepository})
    : _loginRepository = loginRepository;

  @override
  Future<ResultActionDTO> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _loginRepository.login(
        email: email,
        password: password,
      );

      final storage = GetStorage();

      storage.write(Constants.JWT_TOKEN, response.token);
      storage.write(Constants.USER_KEY, response.user.toMap());

      return ResultActionDTO.success();
    } on WrongCredentialsException catch (_) {
      return ResultActionDTO.failure('Credenciais inválidas');
    } on UserNotFoundException catch (_) {
      return ResultActionDTO.failure('Usuário não encontrado');
    } catch (_) {
      return ResultActionDTO.failure('Problema ao realizar login');
    }
  }
}
