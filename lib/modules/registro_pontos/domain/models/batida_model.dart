/// Uma batida de ponto vinda da API, no formato `HH:mm` seguido de um
/// marcador opcional entre parenteses (ex.: `08:00 (I)`).
class BatidaModel {
  static const marcadorInclusaoManual = 'I';

  final String hora;
  final String? marcador;

  const BatidaModel({required this.hora, this.marcador});

  const BatidaModel.vazia() : hora = '-', marcador = null;

  bool get isVazia => hora == '-';

  bool get hasMarcador => marcador != null && marcador!.isNotEmpty;

  bool get isInclusaoManual =>
      marcador?.toUpperCase() == marcadorInclusaoManual;

  /// Sigla exibida ao lado do horario (ex.: `(I)`).
  String get marcadorSigla => hasMarcador ? '(${marcador!.toUpperCase()})' : '';

  /// Texto da legenda exibida no rodape do card.
  String get marcadorDescricao {
    if (!hasMarcador) return '';
    if (isInclusaoManual) return 'Batida incluída manualmente';
    return 'Batida com marcação $marcadorSigla';
  }

  Map<String, dynamic> toMap() => {'hora': hora, 'marcador': marcador};

  @override
  String toString() => 'BatidaModel(hora: $hora, marcador: $marcador)';
}
