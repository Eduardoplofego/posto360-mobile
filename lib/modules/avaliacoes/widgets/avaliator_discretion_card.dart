import 'dart:math';

import 'package:flutter/material.dart';
import 'package:posto360/modules/avaliacoes/domain/dto/confirm_discretions_dto.dart';
import 'package:posto360/modules/avaliacoes/domain/models/avaliator_dicretions_model.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/core/domain/ui/widgets/posto_app_text_form_field.dart';

class AvaliatorDiscretionCard extends StatelessWidget {
  final AvaliatorDicretionsModel model;
  final bool isOpened;
  final int index;
  final bool isLoading;
  final ValueNotifier<bool> _isFulfilled;
  final ValueNotifier<TextEditingController> _penalityController;
  final ValueNotifier<TextEditingController> _commentController;
  final Function(ConfirmDiscretionsDto) onConfirm;

  AvaliatorDiscretionCard({
    super.key,
    required this.model,
    required this.isOpened,
    required this.index,
    required this.isLoading,
    required this.onConfirm,
  }) : _isFulfilled = ValueNotifier(true),
       _penalityController = ValueNotifier(TextEditingController()..text = '0'),
       _commentController = ValueNotifier(TextEditingController());

  @override
  Widget build(BuildContext context) {
    if (model.cumprido != null) {
      return discretionFulfilled();
    }
    return discretionEmpty();
  }

  Widget discretionFulfilled() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: model.cumprido! ? Colors.green : Colors.red,
            width: 3,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1,
            spreadRadius: 1,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
              color: model.cumprido! ? Colors.green : Colors.red,
            ),
            child: Icon(
              model.cumprido! ? Icons.check : Icons.close,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        model.nome,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: PostoAppUiConfigurations.greyColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Transform.rotate(
                      angle: isOpened ? -pi / 2 : 0,
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                Text(
                  model.descricao,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 12),
                Row(
                  spacing: 10,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color:
                            model.cumprido!
                                ? Colors.green.shade100
                                : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        model.cumprido! ? 'Cumprido' : 'Não cumprido',
                        style: TextStyle(
                          fontSize: 12,
                          color: model.cumprido! ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      'Penalidade: ${model.penalidade}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: isOpened,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        model.comentarios ?? 'Nenhum comentário',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: isOpened,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        'Preenchido em: ${model.dataPreenchimento ?? '--'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget discretionEmpty() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:
            isOpened
                ? Border.all(color: PostoAppUiConfigurations.blueLightColor)
                : null,
        boxShadow: [
          if (!isOpened)
            BoxShadow(
              color: Colors.black12,
              blurRadius: 1,
              spreadRadius: 1,
              offset: Offset(1, 1),
            ),
          if (isOpened) ...[
            BoxShadow(
              color: Colors.lightBlue.shade100,
              blurRadius: 1,
              spreadRadius: 2,
              offset: Offset(-1, 1),
            ),
            BoxShadow(
              color: Colors.lightBlue.shade100,
              blurRadius: 1,
              spreadRadius: 2,
              offset: Offset(1, -1),
            ),
          ],
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.grey.shade300,
            ),
            child: Center(
              child: Text(
                (index + 1).toString(),
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        model.nome,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: PostoAppUiConfigurations.greyColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Transform.rotate(
                      angle: isOpened ? -pi / 2 : 0,
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                Text(
                  model.descricao,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder(
                  valueListenable: _isFulfilled,
                  builder: (context, value, child) {
                    return Visibility(
                      visible: isOpened,
                      child: Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 60,
                              child: ElevatedButton(
                                onPressed: () {
                                  _isFulfilled.value = true;
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      _isFulfilled.value
                                          ? Colors.green.shade100
                                          : Colors.white,
                                  side: BorderSide(
                                    color:
                                        _isFulfilled.value
                                            ? Colors.green
                                            : Colors.grey,
                                  ),
                                ),
                                child: Text(
                                  'Cumprido',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        _isFulfilled.value
                                            ? Colors.green
                                            : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 60,
                              child: ElevatedButton(
                                onPressed: () {
                                  _isFulfilled.value = false;
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      !_isFulfilled.value
                                          ? Colors.red.shade100
                                          : Colors.white,
                                  side: BorderSide(
                                    color:
                                        !_isFulfilled.value
                                            ? Colors.green
                                            : Colors.grey,
                                  ),
                                ),
                                child: Text(
                                  'Não cumprido',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        !_isFulfilled.value
                                            ? Colors.red
                                            : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                Visibility(
                  visible: isOpened,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Text('Penalidade'),
                      const SizedBox(height: 3),
                      Row(
                        spacing: 6,
                        children: [
                          Expanded(
                            child: PostoAppTextFormField(
                              label: '',
                              controller: _penalityController.value,
                              obscureText: false,
                            ),
                          ),

                          Expanded(flex: 2, child: Text('Pontos')),
                        ],
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: isOpened,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Text('Comentários'),
                      const SizedBox(height: 3),
                      Row(
                        spacing: 6,
                        children: [
                          Expanded(
                            child: PostoAppTextFormField(
                              label: '',
                              controller: _commentController.value,
                              obscureText: false,
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: isOpened,
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                final dto = ConfirmDiscretionsDto(
                                  id: model.id,
                                  isFulfilled: _isFulfilled.value,
                                  penality: _penalityController.value.text,
                                  comment: _commentController.value.text,
                                );

                                onConfirm(dto);
                              },
                              child:
                                  isLoading
                                      ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      )
                                      : Text(
                                        'Confirmar critério',
                                        style: TextStyle(color: Colors.white),
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
