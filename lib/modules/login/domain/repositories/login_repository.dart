import 'package:posto360/modules/core/domain/dto/login_dto.dart';

abstract class LoginRepository {
  Future<LoginDto> login({required String email, required String password});
}
