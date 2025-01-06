import 'package:flutter/material.dart';
import 'package:tbp_app/logic/user_service.dart';
import 'package:tbp_app/models/exceptions.dart';
import 'package:tbp_app/models/user.dart';
import 'package:tbp_app/ui/dialogs.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var tcEmail = TextEditingController();
  var tcFirstName = TextEditingController();
  var tcLastName = TextEditingController();
  var tcContact = TextEditingController();

  var tcPassword = TextEditingController();
  var tcConfirmPassword = TextEditingController();

  void register() async {
    var userService = UserService();

    var user = User(
      id: 0,
      email: tcEmail.text.trim(),
      firstName: tcFirstName.text.trim(),
      lastName: tcLastName.text.trim(),
      contact: tcContact.text.trim(),
      role: '',
    );

    var password = tcPassword.text.trim();
    var confirmPassword = tcConfirmPassword.text.trim();

    try {
      await userService.register(user, password, confirmPassword);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (a) {
      var e = AppException.from(a);
      Dialogs.showLongSnackBar(this, e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registracija'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: tcEmail,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  isDense: true,
                  label: Text('Email'),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: tcFirstName,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  isDense: true,
                  label: Text('Ime'),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: tcLastName,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  isDense: true,
                  label: Text('Prezime'),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: tcContact,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  isDense: true,
                  label: Text('Kontakt'),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: tcPassword,
                obscureText: true,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  isDense: true,
                  label: Text('Lozinka'),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: tcConfirmPassword,
                obscureText: true,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  isDense: true,
                  label: Text('Potvrda lozinke'),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: FilledButton(
                  onPressed: () => register(),
                  child: const Text('Registriraj se'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    tcEmail.dispose();
    tcFirstName.dispose();
    tcLastName.dispose();
    tcContact.dispose();
    tcPassword.dispose();
    tcConfirmPassword.dispose();
    super.dispose();
  }
}
