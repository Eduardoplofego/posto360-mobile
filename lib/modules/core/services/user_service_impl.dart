import 'dart:convert';
import 'dart:io';

import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/repositories/user_repository.dart';
import 'package:mime/mime.dart';

import '../infra/services/user_service.dart';

class UserServiceImpl extends UserService {
  final UserRepository _userRepository;

  UserServiceImpl({required UserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<ResultActionDTO<String>> sendProfilePhoto({
    required String userId,
    required String imagePath,
  }) async {
    final mimetype = lookupMimeType(imagePath);
    if (mimetype == null) {
      return ResultActionDTO.failure(
        'Não foi possível identificar o tipo de arquivo',
        '',
      );
    }
    final nameImage = '${userId}_profile.${mimetype.split('/').last}';
    final base64Image = await imageToBase64(imagePath);

    final imageObject = {
      'nome': nameImage,
      'tipo': mimetype,
      'base64': base64Image,
    };

    final response = await _userRepository.sendProfilePhoto(
      userId: userId,
      image: imageObject,
    );
    if (response.success) {
      return ResultActionDTO.success(data: response.data);
    } else {
      return ResultActionDTO.failure(response.message, '');
    }
  }

  Future<String> imageToBase64(String imagePath) async {
    final bytes = await File(imagePath).readAsBytes();
    return base64Encode(bytes);
  }
}
