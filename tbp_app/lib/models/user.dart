class User {
  int id;
  String username;

  String firstName;
  String lastName;

  String email;
  String contact;

  User({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.contact,
  });

  static User? current;
}
