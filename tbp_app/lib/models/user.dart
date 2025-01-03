class User {
  int id;
  String email;
  String firstName;
  String lastName;
  String contact;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.contact,
  });

  static User? current;
}
