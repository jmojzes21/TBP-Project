import 'package:tbp_app/logic/database_connection.dart';
import 'package:tbp_app/models/physical_indicator.dart';

class PhysicalIndicatorsService {
  Future<List<PhysicalIndicator>> getAll(int userId) async {
    var db = DatabaseConnection();
    await db.open();

    var results = await db.execute(
      'SELECT * FROM "physicalIndicatorsHistory" WHERE "userId" = @userid ORDER BY "date" ASC',
      {'userid': userId},
    );

    await db.close();

    return results.map((e) {
      return PhysicalIndicator(
        id: e['id'],
        userId: e['userId'],
        date: e['date'],
        weight: e['weight'],
        bmi: e['BMI'],
        bloodPressure: e['bloodPressure'],
      );
    }).toList();
  }

  Future<void> insert(PhysicalIndicator indicator, double height) async {
    height /= 100;

    var db = DatabaseConnection();
    await db.open();

    await db.execute(
      'SELECT addPhysicalIndicators(@userId, @date, @weight, @height, @bloodPressure)',
      {
        'userId': indicator.userId,
        'date': indicator.date,
        'weight': indicator.weight,
        'height': height,
        'bloodPressure': indicator.bloodPressure,
      },
    );

    await db.close();
  }
}
