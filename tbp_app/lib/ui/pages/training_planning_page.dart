import 'package:flutter/material.dart';
import 'package:tbp_app/logic/date_formats.dart';
import 'package:tbp_app/logic/training_plan_service.dart';
import 'package:tbp_app/models/exceptions.dart';
import 'package:tbp_app/models/training_plan.dart';
import 'package:tbp_app/models/user.dart';
import 'package:tbp_app/ui/date_picker.dart';
import 'package:tbp_app/ui/dialogs.dart';

class TrainingPlanningPage extends StatefulWidget {
  const TrainingPlanningPage({super.key});

  @override
  State<TrainingPlanningPage> createState() => _TrainingPlanningPageState();
}

class _TrainingPlanningPageState extends State<TrainingPlanningPage> {
  var user = User.current!;

  var tcName = TextEditingController();
  var tcTargetWeight = TextEditingController();
  var tcTargetBmi = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  List<TrainingPlan> data = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    var service = TrainingPlanService();
    var data = await service.getAll(user.id);

    setState(() {
      this.data = data;
    });
  }

  void add() async {
    var service = TrainingPlanService();
    try {
      await service.insert(TrainingPlan(
        id: 0,
        userId: user.id,
        name: tcName.text.trim(),
        startDate: startDate!,
        endDate: endDate!,
        targetWeight: double.parse(tcTargetWeight.text.trim()),
        targetBmi: double.parse(tcTargetBmi.text.trim()),
      ));
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
            Text('Planovi treniranja', style: Theme.of(context).textTheme.titleLarge),
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
                        Text('Naziv: ${e.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Početak: ${DateFormats.date.format(e.startDate)}'),
                        Text('Završetak: ${DateFormats.date.format(e.endDate)}'),
                        Text('Ciljana težina: ${e.targetWeight.toStringAsFixed(1)} kg'),
                        Text('Ciljani BMI: ${e.targetBmi.toStringAsFixed(1)}'),
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

            TextField(
              controller: tcName,
              decoration: const InputDecoration(
                isDense: true,
                label: Text('Naziv'),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            Text('Datum početka', style: Theme.of(context).textTheme.bodyLarge),
            DatePicker(
              value: startDate,
              onUpdate: (value) {
                setState(() => startDate = value);
              },
            ),
            const SizedBox(height: 20),

            Text('Datum završetka', style: Theme.of(context).textTheme.bodyLarge),
            DatePicker(
              value: endDate,
              onUpdate: (value) {
                setState(() => endDate = value);
              },
            ),
            const SizedBox(height: 20),

            TextField(
              controller: tcTargetWeight,
              decoration: const InputDecoration(
                isDense: true,
                label: Text('Ciljana težina'),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: tcTargetBmi,
              decoration: const InputDecoration(
                isDense: true,
                label: Text('Ciljani BMI'),
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
    tcName.dispose();
    tcTargetWeight.dispose();
    tcTargetBmi.dispose();
    super.dispose();
  }
}
