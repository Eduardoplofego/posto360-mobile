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
    DateFormat formato = DateFormat('dd/MM/yyyy', 'pt_BR');
    String dataFormatada = formato.format(data);
    return dataFormatada;
  }

  static String formatarDataExtensoComAno(DateTime data) {
    DateFormat formato = DateFormat('MMMM yyyy', 'pt_BR');
    String dataFormatada = formato.format(data);
    return dataFormatada.capitalize ?? dataFormatada;
  }

  static String formatarDataExtensoHorario(DateTime data) {
    final DateFormat diaSemana = DateFormat.EEEE('pt_BR');
    final DateFormat diaMes = DateFormat("d 'de' MMM", 'pt_BR');
    final DateFormat hora = DateFormat("HH'h'mm", 'pt_BR');

    String nomeDia = diaSemana.format(data); // ex: quarta-feira
    String diaMesFormatado = diaMes.format(data); // ex: 16 de abr.
    String horaFormatada = hora.format(data); // ex: 18h00

    // Capitaliza a primeira letra do dia da semana
    nomeDia = nomeDia[0].toUpperCase() + nomeDia.substring(1);

    return '$nomeDia, $diaMesFormatado às $horaFormatada';
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
