import 'package:posto360/core/dto/result_action_dto.dart';

abstract class UserRepository {
  Future<ResultActionDTO<String>> sendProfilePhoto({
    required String userId,
    required Map<String, dynamic> image,
  });
}
