import 'package:postgres/postgres.dart';
import 'package:tbp_app/logic/database_connection.dart';
import 'package:tbp_app/models/training_plan.dart';

class TrainingPlanService {
  Future<List<TrainingPlan>> getAll(int userId) async {
    var db = DatabaseConnection();
    await db.open();

    var results = await db.execute(
      'SELECT * FROM "trainingPlans" WHERE "userId" = @userid',
      {'userid': userId},
    );

    await db.close();

    return results.map((e) {
      DateRange duration = e['duration'];

      return TrainingPlan(
        id: e['id'],
        userId: e['userId'],
        name: e['name'],
        startDate: duration.lower!,
        endDate: duration.upper!,
        targetWeight: e['targetWeight'],
        targetBmi: e['targetBMI'],
      );
    }).toList();
  }

  Future<void> insert(TrainingPlan trainingPlan) async {
    var db = DatabaseConnection();
    await db.open();

    var sql = 'INSERT INTO "trainingPlans" ("userId", "name", "duration", "targetWeight", "targetBMI")';
    sql += " VALUES (@userId, @name, @duration, @targetWeight, @targetBMI)";

    await db.execute(sql, {
      'userId': trainingPlan.userId,
      'name': trainingPlan.name,
      'duration': DateRange(
        trainingPlan.startDate,
        trainingPlan.endDate,
        Bounds(Bound.inclusive, Bound.inclusive),
      ),
      'targetWeight': trainingPlan.targetWeight,
      'targetBMI': trainingPlan.targetBmi,
    });

    await db.close();
  }
}
