import 'package:get_storage/get_storage.dart';
import 'package:posto360/modules/core/domain/constants/constants.dart';
import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/exceptions/login_excpetion.dart';
import 'package:posto360/modules/core/domain/exceptions/user_not_found_exception.dart';
import 'package:posto360/modules/core/domain/exceptions/wrong_credentials_exception.dart';
import 'package:posto360/modules/login/domain/repositories/login_repository.dart';

import 'login_service.dart';

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
      storage.write(Constants.USER_PHOTO_URL, null);
      return ResultActionDTO.success();
    } on UserNotFoundException catch (_) {
      return ResultActionDTO.failure('Usuário não encontrado', null);
    } on LoginExcpetion catch (e) {
      return ResultActionDTO.failure(e.message, null);
    } on WrongCredentialsException catch (_) {
      return ResultActionDTO.failure('Credenciais inválidas', null);
    } catch (_) {
      return ResultActionDTO.failure('Erro ao realizar login}', null);
    }
  }
}
