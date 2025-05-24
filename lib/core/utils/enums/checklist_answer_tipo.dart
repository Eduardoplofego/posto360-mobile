enum ChecklistAnswerTipo { texto, opcoes, numerico, boolean }

extension ChecklistAnswerTipoDescription on ChecklistAnswerTipo {
  static ChecklistAnswerTipo getTipo(String tipoText) {
    switch (tipoText) {
      case 'texto':
        return ChecklistAnswerTipo.texto;
      case 'boolean':
        return ChecklistAnswerTipo.boolean;
      case 'numerico':
        return ChecklistAnswerTipo.numerico;
      default:
        return ChecklistAnswerTipo.opcoes;
    }
  }

  static String getTipoString(ChecklistAnswerTipo tipo) {
    switch (tipo) {
      case ChecklistAnswerTipo.texto:
        return 'texto';
      case ChecklistAnswerTipo.opcoes:
        return 'opcoes';
      case ChecklistAnswerTipo.numerico:
        return 'numerico';
      default:
        return 'boolean';
    }
  }
}
