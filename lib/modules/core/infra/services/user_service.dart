import 'package:posto360/core/dto/result_action_dto.dart';

abstract class UserService {
  Future<ResultActionDTO<String>> sendProfilePhoto({
    required String userId,
    required String imagePath,
  });
}
