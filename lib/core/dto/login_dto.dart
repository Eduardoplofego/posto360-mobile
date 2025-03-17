import 'package:posto360/models/user_model.dart';

class LoginDto {
  final String token;
  final UserModel user;
  LoginDto({required this.token, required this.user});
}
