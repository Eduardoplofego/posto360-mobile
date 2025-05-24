import 'package:get/utils.dart';
import 'package:intl/intl.dart';

class DataFormatters {
  DataFormatters._();

  static String formatarPeriodo(List<DateTime> datas) {
    if (datas.isEmpty) return "";

    datas.sort();
    DateTime menor = datas.first;
    DateTime maior = datas.last;

    DateFormat formato = DateFormat('dd/MM/yyyy');
    return "${formato.format(menor)} - ${formato.format(maior)}";
  }

  static String formatarData(DateTime data) {
    DateFormat formato = DateFormat('yyyy-MM-dd', 'pt_BR');
    String dataFormatada = formato.format(data);
    return dataFormatada;
  }

  static String formatarDataExtensoComAno(DateTime data) {
    DateFormat formato = DateFormat('MMMM yyyy', 'pt_BR');
    String dataFormatada = formato.format(data);
    return dataFormatada.capitalize ?? dataFormatada;
  }

  static String getDurationHM(int duration) {
    final horas = duration ~/ 60;
    final minutos = (duration - horas * 60);

    if (horas > 0) {
      return '${horas}h${minutos}min';
    }

    return '${minutos}min';
  }
}
