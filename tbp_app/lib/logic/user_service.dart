import 'dart:convert';
import 'dart:math' as math;

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);

    User.current = User(
      id: data['id'],
      username: data['username'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'],
      contact: data['contact'],
    );
  }

  Future<void> autologin() async {
    var prefs = await SharedPreferences.getInstance();

    var username = prefs.getString('username');
    var password = prefs.getString('password');

    if (username == null || password == null) {
      throw Exception();
    }

    await login(username, password);
  }

  Future<void> register(User user, String password, String confirmPassword) async {
    if (user.username.isEmpty) {
      throw AppException('Unesite korisničko ime.');
    }

    if (user.firstName.isEmpty || user.lastName.isEmpty) {
      throw AppException('Unesite ime i prezime.');
    }

    if (user.email.isEmpty) {
      throw AppException('Unesite email adresu.');
    }

    if (password.isEmpty) {
      throw AppException('Unesite lozinku.');
    }

    if (password != confirmPassword) {
      throw AppException('Vrijednosti lozinke i potvrde lozinke su različite.');
    }

    var random = math.Random.secure();
    var salt = List.generate(32, (index) => random.nextInt(256));

    var hmacSha256 = Hmac(sha256, salt);
    var digest = hmacSha256.convert(utf8.encode(password));

    var saltText = base64Encode(salt);
    var passwordHash = base64Encode(digest.bytes);

    var db = DatabaseConnection();
    await db.open();

    await db.execute(
      'SELECT registerUser(@username, @firstName, @lastName, @email, @contact, @password, @salt, @role);',
      {
        'username': user.username,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'email': user.email,
        'contact': user.contact,
        'password': passwordHash,
        'salt': saltText,
        'role': 'normal',
      },
    );

    await db.close();
  }

  Future<void> logout() async {
    User.current = null;
    var prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
