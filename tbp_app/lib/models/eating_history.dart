import 'package:tbp_app/models/meal_type.dart';

class EatingHistory {
  int id;
  int userId;

  DateTime dateTime;
  double calories;

  MealType mealType;

  EatingHistory({
    required this.id,
    required this.userId,
    required this.dateTime,
    required this.calories,
    required this.mealType,
  });
}
