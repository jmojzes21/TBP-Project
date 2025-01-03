class User {
  int id;
  String email;
  String firstName;
  String lastName;
  String contact;
  String role;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.contact,
    required this.role,
  });

  static User? current;
}
