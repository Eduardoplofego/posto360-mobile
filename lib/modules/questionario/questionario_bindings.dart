import 'package:get/get.dart';
import 'package:posto360/modules/questionario/domain/repositories/questionario_repository.dart';
import 'package:posto360/modules/questionario/infra/repositories/questionario_repository_impl.dart';
import 'package:posto360/modules/questionario/infra/services/questionario_service.dart';
import 'package:posto360/modules/questionario/services/questionario_service_impl.dart';
import './questionario_controller.dart';

class QuestionarioBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuestionarioRepository>(
      () => QuestionarioRepositoryImpl(postoRestClient: Get.find()),
    );
    Get.lazyPut<QuestionarioService>(
      () => QuestionarioServiceImpl(questionarioRepository: Get.find()),
    );
    Get.put(
      QuestionarioController(
        questionarioService: Get.find(),
        authService: Get.find(),
      ),
    );
  }
}
