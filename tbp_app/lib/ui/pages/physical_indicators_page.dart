import 'package:flutter/material.dart';
import 'package:tbp_app/logic/date_formats.dart';
import 'package:tbp_app/logic/physical_indicators_service.dart';
import 'package:tbp_app/models/exceptions.dart';
import 'package:tbp_app/models/physical_indicator.dart';
import 'package:tbp_app/models/user.dart';
import 'package:tbp_app/ui/date_picker.dart';
import 'package:tbp_app/ui/dialogs.dart';

class PhysicalIndicatorsPage extends StatefulWidget {
  const PhysicalIndicatorsPage({super.key});

  @override
  State<PhysicalIndicatorsPage> createState() => _PhysicalIndicatorsPageState();
}

class _PhysicalIndicatorsPageState extends State<PhysicalIndicatorsPage> {
  var user = User.current!;

  var tcWeight = TextEditingController();
  var tcHeight = TextEditingController();
  var tcBloodPressure = TextEditingController(text: '120/80');

  DateTime? date;

  List<PhysicalIndicator> data = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    var service = PhysicalIndicatorsService();
    var data = await service.getAll(user.id);
    setState(() {
      this.data = data;
    });
  }

  void add() async {
    var service = PhysicalIndicatorsService();
    try {
      await service.insert(
        PhysicalIndicator(
          id: 0,
          userId: user.id,
          date: date!,
          weight: double.parse(tcWeight.text.trim()),
          bmi: 0,
          bloodPressure: tcBloodPressure.text.trim(),
        ),
        double.parse(tcHeight.text.trim()),
      );
      Dialogs.showShortSnackBar(this, 'Uspješno');
      load();
    } catch (a) {
      var e = AppException.from(a);
      Dialogs.showLongSnackBar(this, e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            Text('Indikatori', style: Theme.of(context).textTheme.titleLarge),
            ...data.map((e) {
              return SizedBox(
                width: double.infinity,
                child: Card(
                  margin: const EdgeInsets.only(top: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Datum: ${DateFormats.date.format(e.date)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Težina: ${e.weight.toStringAsFixed(1)} kg'),
                        Text('BMI: ${e.bmi.toStringAsFixed(1)}'),
                        Text('Tlak krvi: ${e.bloodPressure} mmHg'),
                      ],
                    ),
                  ),
                ),
              );
            }),
            //
            const SizedBox(height: 20),

            Text('Dodaj', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),

            Text('Datum', style: Theme.of(context).textTheme.bodyLarge),
            DatePicker(
              value: date,
              onUpdate: (value) {
                setState(() => date = value);
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: tcWeight,
              decoration: const InputDecoration(
                isDense: true,
                label: Text('Težina [kg]'),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: tcHeight,
              decoration: const InputDecoration(
                isDense: true,
                label: Text('Visina [cm]'),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: tcBloodPressure,
              decoration: const InputDecoration(
                isDense: true,
                label: Text('Tlak krvi [mmHg]'),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            FilledButton(
              onPressed: () => add(),
              child: const Text('Dodaj'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    tcWeight.dispose();
    tcHeight.dispose();
    tcBloodPressure.dispose();
    super.dispose();
  }
}
