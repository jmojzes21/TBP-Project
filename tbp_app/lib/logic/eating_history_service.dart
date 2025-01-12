import 'package:tbp_app/logic/database_connection.dart';
import 'package:tbp_app/models/eating_history.dart';
import 'package:tbp_app/models/meal_type.dart';

class EatingHistoryService {
  Future<List<MealType>> getAllMealTypes() async {
    var db = DatabaseConnection();
    await db.open();

    var results = await db.execute('SELECT * FROM "mealType"');

    await db.close();

    return results.map((e) {
      return MealType(
        id: e['id'],
        name: e['name'],
      );
    }).toList();
  }

  Future<List<EatingHistory>> getAll(int userId) async {
    var db = DatabaseConnection();
    await db.open();

    var results = await db.execute(
      'SELECT * FROM allEatingHistory WHERE "userId" = @userid ORDER BY "dateTime" ASC',
      {'userid': userId},
    );

    await db.close();

    return results.map((e) {
      return EatingHistory(
        id: e['id'],
        userId: e['userId'],
        dateTime: e['dateTime'],
        calories: e['calories'],
        mealType: MealType(
          id: e['mealTypeId'],
          name: e['mealType'],
        ),
      );
    }).toList();
  }

  Future<void> insert(EatingHistory eatingHistory) async {
    var db = DatabaseConnection();
    await db.open();

    var sql = 'INSERT INTO "eatingHistory" ("userId", "dateTime", "calories", "mealTypeId")';
    sql += " VALUES (@userId, @dateTime, @calories, @mealTypeId)";

    await db.execute(sql, {
      'userId': eatingHistory.userId,
      'dateTime': eatingHistory.dateTime,
      'calories': eatingHistory.calories,
      'mealTypeId': eatingHistory.mealType.id,
    });

    await db.close();
  }
}
