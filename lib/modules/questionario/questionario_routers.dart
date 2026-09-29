import 'package:get/get.dart';
import 'package:posto360/modules/questionario/questionario_bindings.dart';
import 'package:posto360/modules/questionario/questionario_page.dart';

class QuestionarioRouters {
  QuestionarioRouters._();

  static final routes = <GetPage>[
    GetPage(
      name: '/cursos/questionario',
      binding: QuestionarioBindings(),
      page: () => const QuestionarioPage(),
    ),
  ];
}
