import 'package:get/get.dart';
import 'package:posto360/modules/avaliacoes/domain/dto/confirm_discretions_dto.dart';
import 'package:posto360/modules/avaliacoes/domain/models/avaliator_dicretions_model.dart';
import 'package:posto360/modules/avaliacoes/infra/services/avaliacoes_module_service.dart';
import 'package:posto360/modules/core/domain/mixins/message_mixin.dart';

class RealizarAvaliacaoController extends GetxController with MessageMixin {
  late AvaliacoesModuleService _avaliacoesService;

  RealizarAvaliacaoController() {
    _avaliacoesService = Get.find<AvaliacoesModuleService>();
  }

  final _loading = false.obs;
  final _message = Rxn<MessagesModel>();

  final _discretionsList = <AvaliatorDicretionsModel>[].obs;

  final _discretionSelectedIndex = 0.obs;
  final _isConfirmingDiscretion = false.obs;

  int get discretionSelectedIndex => _discretionSelectedIndex.value;
  bool get isConfirmingDiscretion => _isConfirmingDiscretion.value;
  bool get isLoading => _loading.value;
  List<AvaliatorDicretionsModel> get discretionsList => _discretionsList;
  int get discretionsConcluded =>
      discretionsList.where((ele) => ele.cumprido != null).length;
  int get totalDiscretions => discretionsList.length;
  double get progress =>
      totalDiscretions == 0 ? 0 : (discretionsConcluded / totalDiscretions);

  @override
  void onInit() {
    super.onInit();
    messageListener(_message);
  }

  @override
  void onReady() {
    super.onReady();
    loadData();
  }

  void setDiscretionSelected(int index) {
    _discretionSelectedIndex(index);
  }

  Future<void> loadData() async {
    final avaliacaoId = Get.parameters['avaliacaoId'];
    final modeloAvaliacaoId = Get.parameters['modeloId'];

    if (avaliacaoId == null || modeloAvaliacaoId == null) {
      _message(
        MessagesModel(
          title: 'Erro',
          message: 'Parâmetros inválidos',
          type: MessageType.error,
        ),
      );
      return;
    }
    _loading(true);

    final discretions = await _avaliacoesService.getAvaliadorCriterios(
      gestaoAvaliacaoId: int.parse(avaliacaoId),
      modeloAvaliacaoId: int.parse(modeloAvaliacaoId),
    );

    if (discretions.isError) {
      _loading(false);
      _message(
        MessagesModel(
          title: 'Erro',
          message: discretions.message,
          type: MessageType.error,
        ),
      );
    }

    _loading(false);
    _discretionsList.assignAll(discretions.data!);
  }

  Future<void> onConfirmDiscretion(ConfirmDiscretionsDto dto) async {
    _isConfirmingDiscretion(true);
    final result = await _avaliacoesService.confirmDiscretion(dto: dto);

    if (result.isError) {
      _message(
        MessagesModel(
          title: 'Erro',
          message: result.message,
          type: MessageType.error,
        ),
      );
      _isConfirmingDiscretion(false);
      return;
    }

    _discretionSelectedIndex(0);
    _isConfirmingDiscretion(false);
    loadData();
  }

  Future<void> concludeAvaliation() async {
    final avaliacaoId = Get.parameters['avaliacaoId'];
    if (avaliacaoId == null) {
      _message(
        MessagesModel(
          title: 'Erro',
          message: 'Não foi possível concluir a avaliação',
          type: MessageType.error,
        ),
      );
      return;
    }
    final avaliationIdParsed = int.tryParse(avaliacaoId);
    if (avaliationIdParsed == null) {
      _message(
        MessagesModel(
          title: 'Erro',
          message: 'Não foi possível concluir a avaliação',
          type: MessageType.error,
        ),
      );
      return;
    }

    final result = await _avaliacoesService.concludeAvaliation(
      avaliacaoId: int.parse(avaliacaoId),
    );

    if (result.isError) {
      _message(
        MessagesModel(
          title: 'Erro',
          message: result.message,
          type: MessageType.error,
        ),
      );
      return;
    }

    Get.back(result: true);
  }
}
