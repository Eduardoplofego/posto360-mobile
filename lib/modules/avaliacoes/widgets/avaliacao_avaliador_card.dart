import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/avaliacoes/domain/models/avaliacoes_avaliador_model.dart';
import 'package:posto360/modules/avaliacoes/widgets/avaliator_widget.dart';
import 'package:posto360/modules/avaliacoes/widgets/details_concluded_avaliation_widget.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';

class AvaliacaoAvaliadorCard extends StatelessWidget {
  final AvaliacaoAvaliador model;
  final Future<void> Function(AvaliacaoPendente) onPressed;

  const AvaliacaoAvaliadorCard({
    super.key,
    required this.model,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (model is AvaliacaoFinalizada) {
      return _finalizadaCard(model as AvaliacaoFinalizada);
    }
    return _pendenteCard(model as AvaliacaoPendente);
  }

  bool _isTomorrow(DateTime? data) {
    if (data == null) return false;

    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));

    final comparedDate = DateTime(data.year, data.month, data.day);

    return comparedDate == tomorrow;
  }

  bool _isToday(DateTime? data) {
    if (data == null) return false;
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final comparedDate = DateTime(data.year, data.month, data.day);

    return comparedDate == today;
  }

  Widget _pendenteCard(AvaliacaoPendente model) {
    final isTomorrow = _isTomorrow(model.prazo);
    final isToday = _isToday(model.prazo);

    final lightColor =
        isToday
            ? Colors.red.shade100
            : isTomorrow
            ? Colors.orange.shade100
            : Colors.blue.shade100;
    final defaultColor =
        isToday
            ? Colors.red
            : isTomorrow
            ? const Color.fromARGB(255, 163, 98, 1)
            : PostoAppUiConfigurations.blueMediumColor;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Container(
        width: Get.width,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border:
              isToday
                  ? Border(left: BorderSide(color: Colors.red, width: 3))
                  : isTomorrow
                  ? Border(left: BorderSide(color: Colors.orange, width: 3))
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(model.nome, style: TextStyle(fontWeight: FontWeight.w500)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: lightColor,
                  ),
                  child: Text(
                    isToday || isTomorrow ? 'Vencendo' : 'Pendente',
                    style: TextStyle(
                      fontSize: 12,
                      color: defaultColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              model.descricao,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '${model.numeroCriterios} critérios',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(width: 6),
                Text(
                  '|',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(width: 6),
                Text(
                  'Modelo #${model.numModelo}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 0),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color:
                        !(isToday || isTomorrow)
                            ? Colors.green.shade100
                            : lightColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.watch_later_outlined,
                    color:
                        !(isToday || isTomorrow) ? Colors.green : defaultColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Prazo: ${model.prazo != null ? UtilData.obterDataDDMMAAAA(model.prazo!) : '-'} ${isToday
                      ? '(Hoje)'
                      : isTomorrow
                      ? '(Amanhã)'
                      : ''}',
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        !(isToday || isTomorrow)
                            ? Colors.grey.shade800
                            : defaultColor,
                  ),
                ),
                Spacer(),
                SizedBox(
                  height: 34,
                  child: ElevatedButton(
                    onPressed: () {
                      onPressed(model);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      backgroundColor: PostoAppUiConfigurations.blueLightColor,
                    ),
                    child: Text(
                      'Avaliar',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _finalizadaCard(AvaliacaoFinalizada model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Container(
        width: Get.width,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(model.nome, style: TextStyle(fontWeight: FontWeight.w500)),
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300),
                    color: PostoAppUiConfigurations.blueLightColor,
                  ),
                  child: Icon(Icons.check, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              model.descricao,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 12),
            DetailsConcludedAvaliationWidget(
              totaldiscretions: model.numeroCriterios,
              concludedsDiscretions: model.criteriosCumpridos,
              penality: model.penalidade,
            ),
            const SizedBox(height: 12),
            const Divider(height: 0),
            const SizedBox(height: 12),
            AvaliatorWidget(
              name: model.avaliador,
              leadingText: 'Realizada por',
              createdAt: UtilData.obterDataDDMMAAAA(model.dataAvaliacao),
            ),
          ],
        ),
      ),
    );
  }
}
