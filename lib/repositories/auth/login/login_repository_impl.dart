import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:posto360/core/dto/login_dto.dart';
import 'package:posto360/core/exceptions/login_excpetion.dart';
import 'package:posto360/core/exceptions/user_not_found_exception.dart';
import 'package:posto360/core/exceptions/wrong_credentials_exception.dart';
import 'package:posto360/core/rest_client/api_routes/api_routes.dart';
import 'package:posto360/core/rest_client/posto_rest_client.dart';
import 'package:posto360/models/user_model.dart';

import './login_repository.dart';

class LoginRepositoryImpl extends LoginRepository {
  final PostoRestClient _restClient;

  LoginRepositoryImpl({required PostoRestClient restClient})
    : _restClient = restClient;

  @override
  Future<LoginDto> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _restClient.post(ApiRoutes.login(), {
        'email': email,
        'senha': password,
      });

      if (response.statusCode == 308) {
        throw LoginExcpetion();
      }

      final token = response.body['token'];
      final userJson = response.body['user'];

      return LoginDto(token: token, user: UserModel.fromMap(userJson));
    } on DioException catch (e, s) {
      log('Erro ao realizar login', error: e, stackTrace: s);

      if (e.response?.statusCode == 401) {
        throw WrongCredentialsException();
      } else if (e.response?.statusCode == 404) {
        throw UserNotFoundException();
      }

      throw LoginExcpetion();
    } catch (e, s) {
      log('Erro generico ao realizar login', error: e, stackTrace: s);

      throw LoginExcpetion();
    }
  }
}
