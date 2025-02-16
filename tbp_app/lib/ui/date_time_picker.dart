import 'package:flutter/material.dart';
import 'package:tbp_app/logic/date_formats.dart';

class DateTimePicker extends StatelessWidget {
  final DateTime? value;
  final void Function(DateTime value) onUpdate;

  final TimeOfDay? defaultTime;

  const DateTimePicker({
    super.key,
    required this.value,
    required this.onUpdate,
    this.defaultTime,
  });

  String getDateTimeText() {
    if (value != null) {
      return DateFormats.dateTime.format(value!);
    } else {
      return 'Odaberite datum';
    }
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime? result = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );

    if (result != null) {
      int defaultHour = defaultTime?.hour ?? 0;
      int defaultMinute = defaultTime?.minute ?? 0;

      int hour = value?.hour ?? defaultHour;
      int minute = value?.minute ?? defaultMinute;

      onUpdate(DateTime(result.year, result.month, result.day, hour, minute));
    }
  }

  Future<void> selectTime(BuildContext context) async {
    TimeOfDay? result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dialOnly,
    );

    if (result != null) {
      DateTime value = this.value ?? DateTime.now();

      int year = value.year;
      int month = value.month;
      int day = value.day;

      onUpdate(DateTime(year, month, day, result.hour, result.minute));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Text(getDateTimeText(), style: Theme.of(context).textTheme.bodyLarge),
            const Spacer(),
            IconButton(
              onPressed: () => selectDate(context),
              icon: const Icon(Icons.calendar_month),
            ),
            IconButton(
              onPressed: () => selectTime(context),
              icon: const Icon(Icons.timer),
            ),
          ],
        ),
      ),
    );
  }
}
