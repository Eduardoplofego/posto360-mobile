import 'package:posto360/modules/campanhas/domain/models/performance_individual_model.dart';
import 'package:posto360/modules/core/domain/utils/data_formatters.dart';
import 'package:posto360/modules/campanhas/domain/models/campanha_model.dart';

class CampanhaControllerModel {
  double _totalValueBonus;
  DateTime firstDateSelected;
  DateTime lastDateSelected;
  List<CampanhaModel> campanhas;
  List<PerformanceIndividualModel> performances;

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
      performances: [],
    );
  }

  void resetController() {
    _totalValueBonus = 0.0;
    firstDateSelected = firstDateSelected;
    lastDateSelected = lastDateSelected;
    campanhas.clear();
    performances.clear();
  }

  Map<int, dynamic> getPerformanceMap() {
    final mapEntries = <int, dynamic>{};
    for (var performance in performances) {
      final newEntrie = performance.toJson();
      // mapEntries.addEntries(newEntrie.entries);
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
    double valorTotal = 0;
    for (var performance in performances) {
      valorTotal += performance.valorBonificacao;
    }
    _totalValueBonus = valorTotal;
  }
}
