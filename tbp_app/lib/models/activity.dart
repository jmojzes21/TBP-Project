class Activity {
  int id;
  int userId;

  String name;
  String type;

  DateTime startDateTime;
  DateTime endDateTime;

  String notes;

  Activity({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.startDateTime,
    required this.endDateTime,
    required this.notes,
  });

  factory Activity.fromJson({required int id, required int userId, required Map<String, dynamic> data}) {
    return Activity(
      id: id,
      userId: userId,
      name: data['name'],
      type: data['type'],
      startDateTime: DateTime.parse(data['start']),
      endDateTime: DateTime.parse(data['end']),
      notes: data['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'start': startDateTime.toIso8601String(),
      'end': endDateTime.toIso8601String(),
      'notes': notes,
    };
  }
}
