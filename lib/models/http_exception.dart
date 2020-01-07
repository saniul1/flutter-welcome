class HttpException implements Exception {
  final String code;
  final String message;

  HttpException(this.code, this.message);

  @override
  String toString() {
    return code;
  }

  String printMessage() {
    return message;
  }
}
