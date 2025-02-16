import 'package:flutter/material.dart';
import 'package:tbp_app/logic/user_service.dart';
import 'package:tbp_app/models/user.dart';
import 'package:tbp_app/ui/pages/login_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  User user = User.current!;

  void logout() {
    var userService = UserService();
    userService.logout();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return const LoginPage();
    }));
  }

  void exportAllData() async {
    var userService = UserService();
    String data = await userService.exportAllData(user);

    if (!mounted) return;
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return _UserData(data);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${user.firstName} ${user.lastName}', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          Text('Email', style: Theme.of(context).textTheme.titleMedium),
          Text(user.email, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 10),
          Text('Kontakt', style: Theme.of(context).textTheme.titleMedium),
          Text(user.contact, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),
          Text('Uloga', style: Theme.of(context).textTheme.titleMedium),
          Text(user.role, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => exportAllData(),
            child: const Text('Izvoz svih podataka'),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => logout(),
            child: const Text('Odjavi se'),
          ),
        ],
      ),
    );
  }
}

class _UserData extends StatefulWidget {
  final String data;

  const _UserData(this.data);

  @override
  State<_UserData> createState() => _UserDataState();
}

class _UserDataState extends State<_UserData> {
  late TextEditingController tcData;

  @override
  void initState() {
    super.initState();
    tcData = TextEditingController(text: widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Podaci'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: TextField(
          controller: tcData,
          maxLines: null,
          readOnly: true,
          decoration: const InputDecoration(
            isDense: true,
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    tcData.dispose();
    super.dispose();
  }
}
