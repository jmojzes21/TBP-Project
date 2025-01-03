class PhysicalIndicator {
  int id;
  int userId;

  DateTime date;
  double weight;
  double bmi;
  String bloodPressure;

  PhysicalIndicator({
    required this.id,
    required this.userId,
    required this.date,
    required this.weight,
    required this.bmi,
    required this.bloodPressure,
  });
}
