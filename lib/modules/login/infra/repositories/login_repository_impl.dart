import 'package:posto360/modules/core/domain/dto/login_dto.dart';
import 'package:posto360/modules/core/domain/exceptions/login_excpetion.dart';
import 'package:posto360/modules/core/domain/exceptions/wrong_credentials_exception.dart';
import 'package:posto360/modules/core/domain/rest_client/api_routes/api_routes.dart';
import 'package:posto360/modules/core/domain/rest_client/posto_rest_client.dart';
import 'package:posto360/modules/core/domain/models/user_model.dart';

import '../../domain/repositories/login_repository.dart';

class LoginRepositoryImpl extends LoginRepository {
  final PostoRestClient _restClient;

  LoginRepositoryImpl({required PostoRestClient restClient})
    : _restClient = restClient;

  @override
  Future<LoginDto> login({
    required String email,
    required String password,
  }) async {
    final response = await _restClient.post(ApiRoutes.login(), {
      'usernameRaw': email,
      'senha': password,
    });

    if (response.statusCode == 308) {
      throw LoginExcpetion();
    }

    if (response.statusCode == 404) {
      throw LoginExcpetion(message: 'Usuário não encontrado');
    }

    if (response.statusCode == 401) {
      throw WrongCredentialsException();
    }

    final token = response.body['token'];
    final userJson = response.body['userData'];

    return LoginDto(token: token, user: UserModel.fromMap(userJson));
  }
}
