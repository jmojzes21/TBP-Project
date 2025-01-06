class TrainingPlan {
  int id;
  int userId;

  String name;
  DateTime startDate;
  DateTime endDate;

  double targetWeight;
  double targetBmi;

  double? actualWeight;
  double? actualBmi;

  TrainingPlan({
    required this.id,
    required this.userId,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.targetWeight,
    required this.targetBmi,
    this.actualWeight,
    this.actualBmi,
  });
}
