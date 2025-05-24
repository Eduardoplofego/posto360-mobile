import 'package:posto360/core/utils/data_formatters.dart';
import 'package:posto360/core/utils/enums/type_bonificacao.dart';
import 'package:posto360/models/campanha_model.dart';
import 'package:posto360/models/performance_model.dart';

class CampanhaControllerModel {
  double _totalValueBonus;
  DateTime firstDateSelected;
  DateTime lastDateSelected;
  List<CampanhaModel> campanhas;
  List<PerformanceModel> performances;

  CampanhaControllerModel({
    required this.firstDateSelected,
    required this.lastDateSelected,
    required this.campanhas,
    required this.performances,
  }) : _totalValueBonus = 0.0;

  factory CampanhaControllerModel.empty() {
    final today = DateTime.now();
    final fisrtDate = DateTime(today.year, today.month, 1);
    final lastDate = DateTime(
      fisrtDate.year,
      fisrtDate.month + 1,
      1,
    ).subtract(const Duration(days: 1));
    return CampanhaControllerModel(
      firstDateSelected: fisrtDate,
      lastDateSelected: lastDate,
      campanhas: [],
      performances: [],
    );
  }

  factory CampanhaControllerModel.fromMap(Map<String, dynamic> map) {
    return CampanhaControllerModel(
      firstDateSelected: DateTime.parse(map['firstDateSelected']),
      lastDateSelected: DateTime.parse(map['lastDateSelected']),
      campanhas:
          map['campanhas']
              .map<CampanhaModel>(
                (campanhaMap) => CampanhaModel.fromMap(campanhaMap),
              )
              .toList(),
      performances:
          map['performances']
              .map<PerformanceModel>(
                (performance) => PerformanceModel.fromStorageMap(performance),
              )
              .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalValueBonus': _totalValueBonus,
      'firstDateSelected': firstDateSelected.toIso8601String(),
      'lastDateSelected': lastDateSelected.toIso8601String(),
      'campanhas': campanhas.map((campanha) => campanha.toMap()).toList(),
      'performances':
          performances.map((performance) => performance.toMapToSave()).toList(),
    };
  }

  Map<int, dynamic> getPerformanceMap() {
    final mapEntries = <int, dynamic>{};
    for (var performance in performances) {
      final newEntrie = performance.toMap();
      mapEntries.addEntries(newEntrie.entries);
    }
    return mapEntries;
  }

  List<DateTime> getPeriodSelected() {
    return [firstDateSelected, lastDateSelected];
  }

  String get periodSelectedString =>
      DataFormatters.formatarPeriodo(getPeriodSelected());

  double get totalValueBonus => _totalValueBonus;

  void calculateValueTotalBonus() {
    for (var performance in performances) {
      final campanhaPerformance = campanhas.firstWhere(
        (campanha) => campanha.campanhaId == performance.campanhaId,
        orElse: () => CampanhaModel.empty(),
      );

      if (campanhaPerformance.campanhaId == 0) return;

      bool isBonificacaoUnidade =
          campanhaPerformance.tipoBonificacao == TypeBonificacao.unidade;

      final targetToWin =
          isBonificacaoUnidade
              ? campanhaPerformance.volumeBonificacao.toDouble()
              : campanhaPerformance.valorBonificacao *
                  campanhaPerformance.valorBonificacao;
      final currentTaken =
          isBonificacaoUnidade
              ? performance.unidadesVendidas.toDouble()
              : (performance.unidadesVendidas *
                  campanhaPerformance.valorBonificacao);

      if (targetToWin <= currentTaken) {
        final totalToAdd =
            (currentTaken ~/ targetToWin) *
            campanhaPerformance.valorBonificacao;
        _totalValueBonus += totalToAdd;
      }
    }
  }
}
