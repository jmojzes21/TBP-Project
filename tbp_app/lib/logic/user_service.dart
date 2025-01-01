import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:tbp_app/logic/database_connection.dart';
import 'package:tbp_app/models/exceptions.dart';
import 'package:tbp_app/models/user.dart';

class UserService {
  Future<void> login(String username, String password) async {
    var db = DatabaseConnection();
    await db.open();

    var result = await db.execute(
      'SELECT * FROM "users" WHERE "username"=@username',
      {'username': username},
    );

    await db.close();

    if (result.isEmpty) {
      throw AppException('Pogreška u prijavi.');
    }

    var data = result.first;

    String expectedHash = data['password'];
    String salt = data['salt'];

    var hmacSha256 = Hmac(sha256, base64Decode(salt));
    var digest = hmacSha256.convert(utf8.encode(password));

    String passwordHash = base64Encode(digest.bytes);

    if (passwordHash != expectedHash) {
      throw AppException('Pogreška u prijavi.');
    }

    User.current = User(
      id: data['id'],
      username: data['username'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'],
      contact: data['contact'],
    );
  }
}
