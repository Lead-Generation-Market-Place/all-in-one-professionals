import 'package:flutter/material.dart';

class BusinessAvailability extends StatefulWidget {
  const BusinessAvailability({super.key});

  @override
  State<BusinessAvailability> createState() => _BusinessAvailabilityState();
}

class _BusinessAvailabilityState extends State<BusinessAvailability> {
  bool _isAvailable = true;
  final List<Map<String, dynamic>> _workingHours = [
    {
      'day': 'Monday',
      'open': true,
      'start': TimeOfDay(hour: 9, minute: 0),
      'end': TimeOfDay(hour: 17, minute: 0),
    },
    {
      'day': 'Tuesday',
      'open': true,
      'start': TimeOfDay(hour: 9, minute: 0),
      'end': TimeOfDay(hour: 17, minute: 0),
    },
    {
      'day': 'Wednesday',
      'open': true,
      'start': TimeOfDay(hour: 9, minute: 0),
      'end': TimeOfDay(hour: 17, minute: 0),
    },
    {
      'day': 'Thursday',
      'open': true,
      'start': TimeOfDay(hour: 9, minute: 0),
      'end': TimeOfDay(hour: 17, minute: 0),
    },
    {
      'day': 'Friday',
      'open': true,
      'start': TimeOfDay(hour: 9, minute: 0),
      'end': TimeOfDay(hour: 17, minute: 0),
    },
    {
      'day': 'Saturday',
      'open': false,
      'start': TimeOfDay(hour: 9, minute: 0),
      'end': TimeOfDay(hour: 17, minute: 0),
    },
    {
      'day': 'Sunday',
      'open': false,
      'start': TimeOfDay(hour: 9, minute: 0),
      'end': TimeOfDay(hour: 17, minute: 0),
    },
  ];

  Future<void> _selectTime(
    BuildContext context,
    bool isStart,
    int index,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart
          ? _workingHours[index]['start']
          : _workingHours[index]['end'],
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _workingHours[index]['start'] = picked;
        } else {
          _workingHours[index]['end'] = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Availability'),
        centerTitle: true,
        foregroundColor: scheme.onPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Availability Toggle
            Card(
              elevation: 0,
              color: theme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                title: Text(
                  'Business Availability',
                  style: theme.textTheme.titleMedium,
                ),
                subtitle: Text(
                  _isAvailable
                      ? 'Currently accepting jobs'
                      : 'Not accepting jobs',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: Switch.adaptive(
                  value: _isAvailable,
                  onChanged: (value) {
                    setState(() {
                      _isAvailable = value;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Working Hours
            Text('Working Hours', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Set your weekly working hours',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),

            // Days List
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _workingHours.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final day = _workingHours[index];
                return Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  color: theme.colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: theme.colorScheme.outlineVariant),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            day['day'],
                            style: theme.textTheme.titleMedium,
                          ),
                          trailing: Switch.adaptive(
                            value: day['open'],
                            onChanged: (value) {
                              setState(() {
                                _workingHours[index]['open'] = value;
                              });
                            },
                          ),
                        ),
                        if (day['open']) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 12,
                            runSpacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              _TimeButton(
                                label: _formatTimeOfDay(day['start']),
                                onPressed: () =>
                                    _selectTime(context, true, index),
                              ),
                              Text(
                                'to',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              _TimeButton(
                                label: _formatTimeOfDay(day['end']),
                                onPressed: () =>
                                    _selectTime(context, false, index),
                              ),
                            ],
                          ),
                        ] else ...[
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Chip(
                              backgroundColor: scheme.surfaceContainerHighest,
                              shape: StadiumBorder(
                                side: BorderSide(color: scheme.outlineVariant),
                              ),
                              label: Text(
                                'Closed',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Save logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Availability saved successfully'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeOfDay(TimeOfDay tod) {
    final hour = tod.hourOfPeriod;
    final minute = tod.minute.toString().padLeft(2, '0');
    final period = tod.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}

class _TimeButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _TimeButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        side: BorderSide(color: scheme.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.access_time, size: 16),
          const SizedBox(width: 6),
          Text(label, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
