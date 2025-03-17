import 'package:posto360/core/dto/login_dto.dart';

abstract class LoginRepository {
  Future<LoginDto> login({required String email, required String password});
}
