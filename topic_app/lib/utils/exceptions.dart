
class DataException implements Exception {
  DataException({required this.message});
  String message = "";
  @override
  String toString() => message;
}
