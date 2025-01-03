import 'package:flutter/material.dart';
import 'package:tbp_app/logic/date_formats.dart';

class DatePicker extends StatelessWidget {
  final DateTime? value;
  final void Function(DateTime value) onUpdate;

  const DatePicker({
    super.key,
    required this.value,
    required this.onUpdate,
  });

  String getDateTimeText() {
    if (value != null) {
      return DateFormats.date.format(value!);
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
      onUpdate(DateTime(result.year, result.month, result.day));
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
          ],
        ),
      ),
    );
  }
}
