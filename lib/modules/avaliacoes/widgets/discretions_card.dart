import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/avaliacoes/domain/models/avaliacao_details_model.dart';

class DiscretionsCard extends StatelessWidget {
  final AvaliacaoDetailsModel model;
  const DiscretionsCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        width: Get.width,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border:
              !model.cumprido
                  ? Border(left: BorderSide(color: Colors.red, width: 4))
                  : null,
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
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    model.cumprido
                        ? Colors.green.shade100
                        : Colors.red.shade200,
              ),
              child: Icon(
                model.cumprido ? Icons.check : Icons.close,
                color: model.cumprido ? Colors.green : Colors.red,
                size: 18,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.nome,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      model.descricao,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Data de preenchimento',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          model.dataPreenchimento != null
                              ? UtilData.obterDataDDMMAAAA(
                                model.dataPreenchimento!,
                              )
                              : '-',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Penalidade',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color:
                                !model.penalidade.isNegative
                                    ? Colors.green.shade100
                                    : Colors.red.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            model.penalidade.toStringAsFixed(1),
                            style: TextStyle(
                              color:
                                  !model.penalidade.isNegative
                                      ? Colors.green
                                      : Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    model.comentarios != null
                        ? Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Critério atendido sem ressalvas',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
