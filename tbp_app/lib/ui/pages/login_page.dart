import 'package:flutter/material.dart';
import 'package:tbp_app/logic/user_service.dart';
import 'package:tbp_app/models/exceptions.dart';
import 'package:tbp_app/ui/app_navigation.dart';
import 'package:tbp_app/ui/dialogs.dart';
import 'package:tbp_app/ui/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var tcEmail = TextEditingController();
  var tcPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    autologin();
  }

  void autologin() async {
    var userService = UserService();
    try {
      await userService.autologin();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
        return const AppNavigation();
      }));
    } catch (_) {}
  }

  void login() async {
    var userService = UserService();

    var email = tcEmail.text.trim();
    var password = tcPassword.text.trim();

    try {
      await userService.login(email, password);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
        return const AppNavigation();
      }));
    } catch (a) {
      var e = AppException.from(a);
      Dialogs.showLongSnackBar(this, e.message);
    }
  }

  void register() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const RegisterPage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prijava'),
      ),
      body: Center(
        child: SizedBox(
          width: 200,
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
                controller: tcPassword,
                obscureText: true,
                decoration: const InputDecoration(
                  isDense: true,
                  label: Text('Lozinka'),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: FilledButton(
                  onPressed: () => login(),
                  child: const Text('Prijavi se'),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: FilledButton(
                  onPressed: () => register(),
                  child: const Text('Registracija'),
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
    tcPassword.dispose();
    super.dispose();
  }
}
