import 'package:flutter/material.dart';
import 'package:tbp_app/logic/activities_service.dart';
import 'package:tbp_app/logic/date_formats.dart';
import 'package:tbp_app/models/activity.dart';
import 'package:tbp_app/models/activity_type.dart';
import 'package:tbp_app/models/exceptions.dart';
import 'package:tbp_app/models/user.dart';
import 'package:tbp_app/ui/date_time_picker.dart';
import 'package:tbp_app/ui/dialogs.dart';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  var user = User.current!;

  List<ActivityType> activityTypes = [];

  var tcName = TextEditingController();
  var tcNotes = TextEditingController();

  ActivityType? activityType;
  DateTime? startDateTime;
  DateTime? endDateTime;

  List<Activity> data = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    var service = ActivitiesService();
    var activityTypes = await service.getAllActivityTypes();
    var data = await service.getAll(user.id);

    setState(() {
      this.activityTypes = activityTypes;
      this.data = data;
    });
  }

  void add() async {
    var service = ActivitiesService();
    try {
      await service.insert(Activity(
        id: 0,
        userId: user.id,
        name: tcName.text.trim(),
        type: activityType!.key,
        startDateTime: startDateTime!,
        endDateTime: endDateTime!,
        notes: tcNotes.text.trim(),
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
            Text('Aktivnosti', style: Theme.of(context).textTheme.titleLarge),
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
                        Text('Tip: ${activityTypes.firstWhere((t) => t.key == e.type).name}'),
                        Text('Početak: ${DateFormats.dateTime.format(e.startDateTime)}'),
                        Text('Kraj: ${DateFormats.dateTime.format(e.endDateTime)}'),
                        const Text('Bilješke:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(e.notes),
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

            DropdownMenu(
              label: const Text('Tip'),
              width: 200,
              onSelected: (value) {
                setState(() => activityType = value);
              },
              dropdownMenuEntries: activityTypes.map((e) {
                return DropdownMenuEntry(
                  value: e,
                  label: e.name,
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            Text('Početak', style: Theme.of(context).textTheme.bodyLarge),
            DateTimePicker(
              value: startDateTime,
              onUpdate: (value) {
                setState(() => startDateTime = value);
              },
            ),
            const SizedBox(height: 20), Text('Kraj', style: Theme.of(context).textTheme.bodyLarge),
            DateTimePicker(
              value: endDateTime,
              onUpdate: (value) {
                setState(() => endDateTime = value);
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: tcNotes,
              minLines: 3,
              maxLines: 8,
              decoration: const InputDecoration(
                isDense: true,
                label: Text('Bilješke'),
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
    tcNotes.dispose();
    super.dispose();
  }
}
