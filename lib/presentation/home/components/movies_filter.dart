import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/data/models/date_range.dart';
import '/data/models/movie_field.dart';
import '/data/models/movies_filter.dart';

class MoviesFilterView extends StatefulWidget {
  const MoviesFilterView({super.key, this.initial});

  final MoviesFilter? initial;

  @override
  State<MoviesFilterView> createState() => _MoviesFilterViewState();
}

class _MoviesFilterViewState extends State<MoviesFilterView> {
  late MoviesFilter _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.initial ?? const MoviesFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DateSelector(
              label: 'Released after',
              initial: _filter.releaseDate?.from,
              onChanged: _onReleaseDateFromChanged,
            ),
            const SizedBox(height: 8),
            _DateSelector(
              label: 'Released before',
              initial: _filter.releaseDate?.from,
              onChanged: _onReleaseDateToChanged,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Order by',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                const Spacer(),
                DropdownButton(
                  value: _filter.orderBy,
                  onChanged: _onOrderByChanged,
                  items: MovieField.values
                      .map((field) => DropdownMenuItem(
                            value: field,
                            child: Text(field.name),
                          ))
                      .toList(growable: false),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Spacer(),
            FilledButton(
              onPressed: _onApplyPressed,
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }

  void _onReleaseDateFromChanged(DateTime date) {
    _filter = _filter.copyWith(
      releaseDate: DateRange(
        from: date,
        to: _filter.releaseDate?.to,
      ),
    );
  }

  void _onReleaseDateToChanged(DateTime date) {
    _filter = _filter.copyWith(
      releaseDate: DateRange(
        from: _filter.releaseDate?.from,
        to: date,
      ),
    );
  }

  void _onOrderByChanged(dynamic orderBy) {
    assert(orderBy is MovieField);

    setState(() {
      _filter = _filter.copyWith(
        orderBy: orderBy,
      );
    });
  }

  void _onApplyPressed() {
    Navigator.pop(context, _filter);
  }
}

class _DateSelector extends StatefulWidget {
  const _DateSelector({
    super.key,
    required this.label,
    this.initial,
    required this.onChanged,
  });

  final String label;
  final DateTime? initial;
  final void Function(DateTime date) onChanged;

  @override
  State<_DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<_DateSelector> {
  final DateFormat _dateFormat = DateFormat.yMd();
  late DateTime? _date;

  @override
  void initState() {
    super.initState();
    _date = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: _onPressed,
      child: Row(
        children: [
          Text(
            widget.label,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const Spacer(),
          if (_date != null) Text(_dateFormat.format(_date!)),
        ],
      ),
    );
  }

  void _onPressed() {
    showDatePicker(
      context: context,
      firstDate: DateTime(1888, 10, 14), // "Roundhay garden scene" date
      lastDate: DateTime.now(),
      initialDate: _date ?? DateTime.now(),
    ).then((date) => setState(() {
          if (date == null) {
            return;
          }

          _date = date;
          widget.onChanged(date);
        }));
  }
}
