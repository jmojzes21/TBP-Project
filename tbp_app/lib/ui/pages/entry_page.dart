import 'package:flutter/material.dart';
import 'package:tbp_app/logic/database_connection.dart';
import 'package:tbp_app/ui/pages/login_page.dart';

class EntryPage extends StatefulWidget {
  const EntryPage({super.key});

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  var tcIpAddress = TextEditingController(text: 'localhost');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Poslužitelj baze podataka', style: Theme.of(context).textTheme.titleMedium),
              TextField(
                controller: tcIpAddress,
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: FilledButton(
                  onPressed: () {
                    DatabaseConnection.ipAddress = tcIpAddress.text.trim();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                      return const LoginPage();
                    }));
                  },
                  child: const Text('Nastavi'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
