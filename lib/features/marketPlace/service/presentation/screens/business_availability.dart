import 'package:flutter/material.dart';

class BusinessAvailability extends StatefulWidget {
  const BusinessAvailability({super.key});

  @override
  State<BusinessAvailability> createState() => _BusinessAvailabilityState();
}

class _BusinessAvailabilityState extends State<BusinessAvailability> {
  bool _isAvailable = true;
  final List<Map<String, dynamic>> _workingHours = [
    {'day': 'Monday', 'open': true, 'start': TimeOfDay(hour: 9, minute: 0), 'end': TimeOfDay(hour: 17, minute: 0)},
    {'day': 'Tuesday', 'open': true, 'start': TimeOfDay(hour: 9, minute: 0), 'end': TimeOfDay(hour: 17, minute: 0)},
    {'day': 'Wednesday', 'open': true, 'start': TimeOfDay(hour: 9, minute: 0), 'end': TimeOfDay(hour: 17, minute: 0)},
    {'day': 'Thursday', 'open': true, 'start': TimeOfDay(hour: 9, minute: 0), 'end': TimeOfDay(hour: 17, minute: 0)},
    {'day': 'Friday', 'open': true, 'start': TimeOfDay(hour: 9, minute: 0), 'end': TimeOfDay(hour: 17, minute: 0)},
    {'day': 'Saturday', 'open': false, 'start': TimeOfDay(hour: 9, minute: 0), 'end': TimeOfDay(hour: 17, minute: 0)},
    {'day': 'Sunday', 'open': false, 'start': TimeOfDay(hour: 9, minute: 0), 'end': TimeOfDay(hour: 17, minute: 0)},
  ];

  Future<void> _selectTime(BuildContext context, bool isStart, int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _workingHours[index]['start'] : _workingHours[index]['end'],
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0077B6),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Availability'),
        backgroundColor: const Color(0xFF0077B6),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Availability Toggle
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Business Availability',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Switch(
                      value: _isAvailable,
                      onChanged: (value) {
                        setState(() {
                          _isAvailable = value;
                        });
                      },
                      activeColor: const Color(0xFF0077B6),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Working Hours
            const Text(
              'Working Hours',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Set your weekly working hours',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),

            // Days List
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _workingHours.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final day = _workingHours[index];
                return Card(
                  elevation: 1,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              day['day'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Switch(
                              value: day['open'],
                              onChanged: (value) {
                                setState(() {
                                  _workingHours[index]['open'] = value;
                                });
                              },
                              activeColor: const Color(0xFF0077B6),
                            ),
                          ],
                        ),
                        if (day['open']) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () => _selectTime(context, true, index),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _formatTimeOfDay(day['start']),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                              const Text('to', style: TextStyle(color: Colors.grey)),
                              InkWell(
                                onTap: () => _selectTime(context, false, index),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _formatTimeOfDay(day['end']),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
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
                    const SnackBar(content: Text('Availability saved successfully')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0077B6),
                  foregroundColor: Colors.white,
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