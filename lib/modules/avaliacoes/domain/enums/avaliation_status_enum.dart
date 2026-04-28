enum AvaliationStatusEnum {
  aFazer(status: 'A Fazer'),
  emAndamento(status: 'Em Andamento'),
  finalizado(status: 'Finalizado');

  final String status;

  const AvaliationStatusEnum({required this.status});
}
