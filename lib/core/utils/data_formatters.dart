import 'package:intl/intl.dart';

class DataFormatters {
  DataFormatters._();

  static String formatarPeriodo(List<DateTime> datas) {
    if (datas.isEmpty) return "";

    datas.sort();
    DateTime menor = datas.first;
    DateTime maior = datas.last;

    DateFormat formato = DateFormat('d/M/yyyy');
    return "${formato.format(menor)} - ${formato.format(maior)}";
  }
}
