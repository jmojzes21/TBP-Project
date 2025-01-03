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
              Text('Email', style: Theme.of(context).textTheme.titleMedium),
              TextField(
                controller: tcEmail,
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Text('Ime', style: Theme.of(context).textTheme.titleMedium),
              TextField(
                controller: tcFirstName,
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Text('Prezime', style: Theme.of(context).textTheme.titleMedium),
              TextField(
                controller: tcLastName,
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Text('Kontakt', style: Theme.of(context).textTheme.titleMedium),
              TextField(
                controller: tcContact,
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Text('Lozinka', style: Theme.of(context).textTheme.titleMedium),
              TextField(
                controller: tcPassword,
                obscureText: true,
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Text('Potvrda lozinke', style: Theme.of(context).textTheme.titleMedium),
              TextField(
                controller: tcConfirmPassword,
                obscureText: true,
                decoration: const InputDecoration(
                  isDense: true,
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
