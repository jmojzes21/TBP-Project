import 'package:flutter/material.dart';
import 'package:tbp_app/logic/date_formats.dart';
import 'package:tbp_app/logic/eating_history_service.dart';
import 'package:tbp_app/models/eating_history.dart';
import 'package:tbp_app/models/exceptions.dart';
import 'package:tbp_app/models/meal_type.dart';
import 'package:tbp_app/models/user.dart';
import 'package:tbp_app/ui/date_time_picker.dart';
import 'package:tbp_app/ui/dialogs.dart';

class EatingOverviewPage extends StatefulWidget {
  const EatingOverviewPage({super.key});

  @override
  State<EatingOverviewPage> createState() => _EatingOverviewPageState();
}

class _EatingOverviewPageState extends State<EatingOverviewPage> {
  var user = User.current!;

  List<MealType> mealTypes = [];

  var tcCalories = TextEditingController();
  MealType? mealType;
  DateTime? date;

  List<EatingHistory> data = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    var service = EatingHistoryService();
    var mealTypes = await service.getAllMealTypes();
    var data = await service.getAll(user.id);

    setState(() {
      this.mealTypes = mealTypes;
      this.data = data;
    });
  }

  void add() async {
    var service = EatingHistoryService();
    try {
      await service.insert(EatingHistory(
        id: 0,
        userId: user.id,
        dateTime: date!,
        calories: double.parse(tcCalories.text.trim()),
        mealType: mealType!,
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
            Text('Prehrana', style: Theme.of(context).textTheme.titleLarge),
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
                        Text('Datum: ${DateFormats.dateTime.format(e.dateTime)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Kalorije: ${e.calories.toStringAsFixed(1)} kcal'),
                        Text('Obrok: ${e.mealType.name}'),
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
            DateTimePicker(
              value: date,
              onUpdate: (value) {
                setState(() => date = value);
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: tcCalories,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                isDense: true,
                label: Text('Kalorije [kcal]'),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            DropdownMenu(
              label: const Text('Obrok'),
              width: 200,
              onSelected: (value) {
                setState(() => mealType = value);
              },
              dropdownMenuEntries: mealTypes.map((e) {
                return DropdownMenuEntry(
                  value: e,
                  label: e.name,
                );
              }).toList(),
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
    tcCalories.dispose();
    super.dispose();
  }
}
