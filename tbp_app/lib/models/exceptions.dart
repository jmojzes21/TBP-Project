import 'package:postgres/postgres.dart';

class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;

  factory AppException.from(Object e) {
    if (e is AppException) {
      return e;
    } else if (e is PgException) {
      return AppException(e.message);
    } else if (e is Exception) {
      return AppException(e.toString());
    } else if (e is Error) {
      return AppException(e.toString());
    }

    return AppException(e.toString());
  }
}
