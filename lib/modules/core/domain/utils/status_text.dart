/// Normaliza textos de status vindos da API para comparação segura.
///
/// A API não é consistente com maiúsculas, acentos e separadores
/// ("Em andamento", "Em Andamento", "EM_ANDAMENTO", "Não Iniciado"...),
/// então comparar a string crua faz o status cair no `default` do switch.
class StatusText {
  StatusText._();

  static const _comAcento = 'áàâãäéèêëíìîïóòôõöúùûüçñ';
  static const _semAcento = 'aaaaaeeeeiiiiooooouuuucn';

  /// Retorna o status em minúsculas, sem acentos, com separadores
  /// convertidos em espaço simples. Valores nulos viram string vazia.
  static String normalize(dynamic status) {
    if (status == null) return '';

    final buffer = StringBuffer();
    for (final char in status.toString().toLowerCase().split('')) {
      final index = _comAcento.indexOf(char);
      buffer.write(index >= 0 ? _semAcento[index] : char);
    }

    return buffer
        .toString()
        .replaceAll(RegExp(r'[_\-]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
