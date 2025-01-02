import 'package:postgres/postgres.dart';

class DatabaseConnection {
  static const String _ipAddress = 'localhost';

  Connection? _connection;

  Future<void> open() async {
    _connection = await Connection.open(
      Endpoint(
        host: _ipAddress,
        database: 'TBP-Project',
        username: 'postgres',
        password: 'postgres',
      ),
      settings: const ConnectionSettings(sslMode: SslMode.disable),
    );
  }

  Future<List<Map<String, dynamic>>> execute(String sql, [Object? params]) async {
    var result = await _connection!.execute(
      Sql.named(sql),
      parameters: params,
    );

    return result.map((e) => e.toColumnMap()).toList();
  }

  Future<void> close() async {
    _connection?.close();
    _connection = null;
  }
}
