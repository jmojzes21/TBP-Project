import 'dart:convert';

import 'package:tbp_app/logic/database_connection.dart';
import 'package:tbp_app/models/activity.dart';
import 'package:tbp_app/models/activity_type.dart';

class ActivitiesService {
  Future<List<ActivityType>> getAllActivityTypes() async {
    var db = DatabaseConnection();
    await db.open();

    var results = await db.execute('SELECT * FROM "activityType"');

    await db.close();

    return results.map((e) {
      return ActivityType(
        key: e['key'],
        name: e['name'],
      );
    }).toList();
  }

  Future<List<Activity>> getAll(int userId) async {
    var db = DatabaseConnection();
    await db.open();

    var results = await db.execute(
      'SELECT * FROM "activities" WHERE "userId" = @userid ORDER BY "data"->\'start\' ASC',
      {'userid': userId},
    );

    await db.close();

    return results.map((e) {
      return Activity.fromJson(
        id: e['id'],
        userId: e['userId'],
        data: e['data'],
      );
    }).toList();
  }

  Future<void> insert(Activity activity) async {
    var db = DatabaseConnection();
    await db.open();

    var sql = 'INSERT INTO "activities" ("userId", "data")';
    sql += " VALUES (@userId, @data)";

    await db.execute(sql, {
      'userId': activity.userId,
      'data': jsonEncode(activity.toJson()),
    });

    await db.close();
  }
}
