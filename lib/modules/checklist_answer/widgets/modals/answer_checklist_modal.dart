import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/core/utils/data_formatters.dart';
import 'package:posto360/core/utils/enums/checklist_answer_tipo.dart';
import 'package:posto360/models/checklist_answer_model.dart';
import 'package:posto360/modules/checklist_answer/checklist_answer_controller.dart';
import 'package:posto360/modules/checklist_answer/widgets/dotted_border_button_widget.dart';
import 'package:posto360/modules/checklist_answer/widgets/option_card_widget.dart';

class AnswerChecklistModal extends StatefulWidget {
  final ChecklistAnswerModel answerModel;
  const AnswerChecklistModal({super.key, required this.answerModel});

  @override
  State<AnswerChecklistModal> createState() => _AnswerChecklistModalState();
}

class _AnswerChecklistModalState extends State<AnswerChecklistModal> {
  final _observationEC = TextEditingController();
  final _observationFocus = FocusNode();
  final ValueNotifier<List<bool>?> isYesNoSelected = ValueNotifier(null);
  late ChecklistAnswerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<ChecklistAnswerController>();
  }

  @override
  void dispose() {
    _observationEC.dispose();
    _controller.checkAnswerCard(null);
    super.dispose();
  }

  Future<void> _onTakePhoto() async {
    await _controller.openCameraScreenAndTakePhoto();
  }

  Future<void> _onConcludeChecklist() async {
    await _controller.concludeChecklist(
      answerModel: widget.answerModel,
      comment: _observationEC.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.answerModel.tipo.toString());
    final now = DateTime.now();
    return SingleChildScrollView(
      child: IntrinsicHeight(
        child: Container(
          width: Get.width,
          decoration: BoxDecoration(
            color: PostoAppUiConfigurations.lightPurpleColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 36),
                  Container(
                    width: 115,
                    height: 4,
                    decoration: BoxDecoration(
                      color: PostoAppUiConfigurations.darkGreyColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
              titleModal(),
              const SizedBox(height: 16),
              Obx(() {
                return questionsOrComment(
                  context,
                  _controller.cardOptionSelectedIndex,
                  _controller.checkAnswerCard,
                );
              }),
              const SizedBox(height: 8),
              _divider(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 10,
                ),
                child: Row(
                  spacing: 10,
                  children: [
                    Icon(Icons.calendar_month, color: Colors.grey.shade500),
                    Flexible(
                      child: Text(
                        DataFormatters.formatarDataExtensoHorario(now),
                        style: TextStyle(
                          color: PostoAppUiConfigurations.greyColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _divider(),
              if (widget.answerModel.opcoes == null) ...[
                Obx(() {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 10,
                    ),
                    child: Row(
                      spacing: 10,
                      children: [
                        Icon(Icons.camera_enhance, color: Colors.grey.shade500),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(74, 8, 159, 247),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('Upload de foto'),
                        ),
                        Spacer(),
                        DottedBorderButtonWidget(
                          onTap: _onTakePhoto,
                          isLoading: _controller.isLoadingImageBase64,
                          isCompleted: _controller.hasImageSelected,
                        ),
                      ],
                    ),
                  );
                }),
                _divider(),
              ],
              const SizedBox(height: 16),
              Container(
                height: 48,
                width: Get.width,
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: ElevatedButton(
                  onPressed: _onConcludeChecklist,
                  child: Obx(() {
                    return !_controller.isLoadingSendAnswer
                        ? Text(
                          'Concluir tarefa',
                          style: TextStyle(color: Colors.white),
                        )
                        : CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        );
                  }),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget questionsOrComment(
    BuildContext context,
    int? cardSelectedIndex,
    Function(int value) onOptionSelected,
  ) {
    if (widget.answerModel.tipo == ChecklistAnswerTipo.boolean) {
      isYesNoSelected.value = [false, false];
      return _yesNoAnswers();
    } else if (widget.answerModel.tipo == ChecklistAnswerTipo.opcoes) {
      return _optionsAsnwers(cardSelectedIndex, onOptionSelected);
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: TextField(
          controller: _observationEC,
          minLines: 1,
          maxLines: 3,
          focusNode: _observationFocus,
          keyboardType:
              widget.answerModel.tipo == ChecklistAnswerTipo.numerico
                  ? TextInputType.number
                  : TextInputType.text,
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },
          style: TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Adicionar comentário',
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: PostoAppUiConfigurations.blueMediumColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: PostoAppUiConfigurations.blueMediumColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: PostoAppUiConfigurations.blueMediumColor,
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget titleModal() {
    return Flexible(
      child: Text(
        widget.answerModel.descricao,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }

  Padding _divider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Divider(),
    );
  }

  Widget _yesNoAnswers() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: ValueListenableBuilder(
        valueListenable: isYesNoSelected,
        builder: (context, value, child) {
          return Column(
            children: [
              OptionCardWidget(
                label: 'Sim',
                isSelected: value![0],
                onPressed: (value) {
                  isYesNoSelected.value = [true, false];
                  _controller.selectedYesNoQuestion(value);
                },
              ),
              const SizedBox(height: 10),
              OptionCardWidget(
                label: 'Não',
                isSelected: value[1],
                onPressed: (value) {
                  isYesNoSelected.value = [false, true];
                  _controller.selectedYesNoQuestion(value);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _optionsAsnwers(
    int? cardSelectedIndex,
    Function(int value) onOptionSelected,
  ) {
    var options = widget.answerModel.opcoes;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: SizedBox(
        height:
            (65 * options!.length) < 200
                ? (65 * options.length).toDouble()
                : 200,
        child: ListView.separated(
          itemCount: options.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            return OptionCardWidget(
              label: options[index],
              isSelected:
                  cardSelectedIndex != null
                      ? cardSelectedIndex == index
                      : false,
              onPressed: (value) {
                if (value) {
                  onOptionSelected(index);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
