import 'package:posto360/core/dto/result_action_dto.dart';

abstract class LoginService {
  Future<ResultActionDTO> login({
    required String email,
    required String password,
  });
}
