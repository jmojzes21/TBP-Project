import 'package:postgres/postgres.dart';
import 'package:tbp_app/logic/database_connection.dart';
import 'package:tbp_app/models/training_plan.dart';

class TrainingPlanService {
  Future<List<TrainingPlan>> getAll(int userId) async {
    var db = DatabaseConnection();
    await db.open();

    var results = await db.execute(
      'SELECT * FROM allUserTrainingPlans(@userid) ORDER BY LOWER("duration") ASC',
      {'userid': userId},
    );

    await db.close();

    return results.map((e) {
      DateRange duration = e['duration'];
      DateTime startDate = duration.lower!;
      DateTime endDate;

      if (duration.bounds.upper == Bound.exclusive) {
        endDate = duration.upper!.subtract(const Duration(days: 1));
      } else {
        endDate = duration.upper!;
      }

      return TrainingPlan(
        id: e['id'],
        userId: e['userId'],
        name: e['name'],
        startDate: startDate,
        endDate: endDate,
        targetWeight: e['targetWeight'],
        targetBmi: e['targetBMI'],
        actualWeight: e['weight'],
        actualBmi: e['BMI'],
      );
    }).toList();
  }

  Future<void> insert(TrainingPlan trainingPlan) async {
    var db = DatabaseConnection();
    await db.open();

    var sql = 'INSERT INTO "trainingPlans" ("userId", "name", "duration", "targetWeight", "targetBMI")';
    sql += " VALUES (@userId, @name, @duration, @targetWeight, @targetBMI)";

    var duration = '[${trainingPlan.startDate.toIso8601String()}, ${trainingPlan.endDate.toIso8601String()}]';

    await db.execute(sql, {
      'userId': trainingPlan.userId,
      'name': trainingPlan.name,
      'duration': duration,
      'targetWeight': trainingPlan.targetWeight,
      'targetBMI': trainingPlan.targetBmi,
    });

    await db.close();
  }
}
