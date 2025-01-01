import 'package:flutter/material.dart';
import 'package:tbp_app/logic/user_service.dart';
import 'package:tbp_app/models/exceptions.dart';
import 'package:tbp_app/ui/app_navigation.dart';
import 'package:tbp_app/ui/dialogs.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var tcIpAddress = TextEditingController();
  var tcUsername = TextEditingController();
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

    var ipAddress = tcIpAddress.text.trim();
    var username = tcUsername.text.trim();
    var password = tcPassword.text.trim();

    try {
      await userService.login(ipAddress, username, password);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
        return const AppNavigation();
      }));
    } catch (a) {
      var e = AppException.from(a);
      Dialogs.showLongSnackBar(this, e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('IP adresa', style: Theme.of(context).textTheme.titleMedium),
              TextField(
                controller: tcIpAddress,
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Text('Korisničko ime', style: Theme.of(context).textTheme.titleMedium),
              TextField(
                controller: tcUsername,
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
              const SizedBox(height: 40),
              Center(
                child: FilledButton(
                  onPressed: () => login(),
                  child: const Text('Prijavi se'),
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
    tcIpAddress.dispose();
    tcUsername.dispose();
    tcPassword.dispose();
    super.dispose();
  }
}
