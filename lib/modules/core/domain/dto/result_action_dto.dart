class ResultActionDTO<T> {
  final bool success;
  final String message;
  final T? data;

  ResultActionDTO._({required this.success, required this.message, this.data});

  bool get isError => !success;

  factory ResultActionDTO.success({String? message, T? data}) {
    return ResultActionDTO._(success: true, message: message ?? '', data: data);
  }

  factory ResultActionDTO.failure(String message, T? data) {
    return ResultActionDTO._(success: false, message: message, data: data);
  }

  @override
  String toString() {
    return '''
      ResultActionDTO(
       success: $success,
       message: $message,
     );
    ''';
  }
}
