import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/model/business_availability_model.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';

class BusinessAvailability extends StatefulWidget {
  const BusinessAvailability({super.key});

  @override
  State<BusinessAvailability> createState() => _BusinessAvailabilityState();
}

class _BusinessAvailabilityState extends State<BusinessAvailability> {
  bool _availableAnytime = false;
  final List<Map<String, dynamic>> _workingHours = [
    {
      'day': 'Monday',
      'open': true,
      'start': TimeOfDay(hour: 8, minute: 0),
      'end': TimeOfDay(hour: 16, minute: 0), // Fixed: 4 PM should be 16:00
    },
    {
      'day': 'Tuesday',
      'open': true,
      'start': TimeOfDay(hour: 8, minute: 0),
      'end': TimeOfDay(hour: 16, minute: 0),
    },
    {
      'day': 'Wednesday',
      'open': true,
      'start': TimeOfDay(hour: 8, minute: 0),
      'end': TimeOfDay(hour: 16, minute: 0),
    },
    {
      'day': 'Thursday',
      'open': true,
      'start': TimeOfDay(hour: 8, minute: 0),
      'end': TimeOfDay(hour: 16, minute: 0),
    },
    {
      'day': 'Friday',
      'open': true,
      'start': TimeOfDay(hour: 8, minute: 0),
      'end': TimeOfDay(hour: 16, minute: 0),
    },
    {
      'day': 'Saturday',
      'open': false,
      'start': TimeOfDay(hour: 8, minute: 0),
      'end': TimeOfDay(hour: 16, minute: 0),
    },
    {
      'day': 'Sunday',
      'open': false,
      'start': TimeOfDay(hour: 8, minute: 0),
      'end': TimeOfDay(hour: 16, minute: 0),
    },
  ];

  int _getDayNumber(String dayName) {
    final days = {
      'sunday': 0,
      'monday': 1,
      'tuesday': 2,
      'wednesday': 3,
      'thursday': 4,
      'friday': 5,
      'saturday': 6,
    };
    return days[dayName.toLowerCase()] ?? 0;
  }

  DateTime _createDateTime(TimeOfDay time) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }
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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
              surface: Theme.of(context).colorScheme.surface,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: Theme.of(context).colorScheme.surface,
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          ),
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

  void _applyDaySettingsToAll(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Apply to all days?'),
          content: Text(
            'This will apply ${_workingHours[index]['day']}\'s settings to all other days.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _applyAllDaysSettings(index);
              },
              child: Text('Apply to All'),
            ),
          ],
        );
      },
    );
  }

  void _applyAllDaysSettings(int index) {
    setState(() {
      final referenceDay = _workingHours[index];
      for (int i = 0; i < _workingHours.length; i++) {
        if (i != index) {
          _workingHours[i]['open'] = referenceDay['open'];
          _workingHours[i]['start'] = referenceDay['start'];
          _workingHours[i]['end'] = referenceDay['end'];
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Settings applied to all days'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Method to prepare data for backend
  BusinessAvailabilityModel _prepareDataForBackend() {
    if (_availableAnytime) {
      // If available anytime, business_hours should be null
      return BusinessAvailabilityModel(
        availableAnytime: true,
        businessHours: null,
      );
    } else {
      // If specific working hours, create business_hours array
      List<BusinessHoursModel> businessHours = [];

      for (var day in _workingHours) {
        final dayNumber = _getDayNumber(day['day']);
        final isOpen = day['open'];

        businessHours.add(
          BusinessHoursModel(
            status: isOpen ? 'open' : 'close',
            startTime: isOpen ? _createDateTime(day['start']) : null,
            endTime: isOpen ? _createDateTime(day['end']) : null,
            day: dayNumber,
          ),
        );
      }

      return BusinessAvailabilityModel(
        availableAnytime: false,
        businessHours: businessHours,
      );
    }
  }

  

  // Method to handle next button press
  void _handleNextButtonPress() {
    // Prepare the data for backend
    final availabilityData = _prepareDataForBackend();

    final jsonData = availabilityData.toJson();

    // Print the data to console (for testing)
    print('Business Availability Data to send to backend:');

    // TODO: Send data to your backend API here
    // Example:
    // await _sendDataToBackend(availabilityData);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Availability data prepared successfully!'),
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate to next screen
    Navigator.pushNamed(context, AppRouter.professionalServiceQuestionForm);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isVerySmallScreen = size.width < 400;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Availability'),
        centerTitle: !isSmallScreen,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isVerySmallScreen
              ? 12
              : isSmallScreen
              ? 16
              : 24,
          vertical: isSmallScreen ? 12 : 16,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: size.height),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: isSmallScreen ? 20 : 24),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: scheme.outlineVariant.withOpacity(0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: scheme.shadow.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: scheme.primary,
                      size: isSmallScreen ? 24 : 28,
                    ),
                    SizedBox(width: isSmallScreen ? 12 : 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Available Anytime',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: isSmallScreen ? 16 : 18,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            _availableAnytime
                                ? 'Open 24/7 for all days'
                                : 'Set specific working hours',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: _availableAnytime,
                      onChanged: (value) {
                        setState(() {
                          _availableAnytime = value;
                        });
                      },
                      activeColor: scheme.primary,
                    ),
                  ],
                ),
              ),

              // Only show working hours if Available Anytime is OFF
              if (!_availableAnytime) ...[
                SizedBox(height: isSmallScreen ? 20 : 24),

                // Working Hours Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Working Hours',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: isSmallScreen ? 20 : 24,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Set your weekly availability schedule',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: isSmallScreen ? 16 : 20),

                // Days List - Fully Responsive
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: scheme.outlineVariant.withOpacity(0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: scheme.shadow.withOpacity(0.05),
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isVeryNarrow = constraints.maxWidth < 350;

                      return ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _workingHours.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          thickness: 1,
                          color: scheme.outlineVariant.withOpacity(0.2),
                          indent: isSmallScreen ? 16 : 20,
                          endIndent: isSmallScreen ? 16 : 20,
                        ),
                        itemBuilder: (context, index) {
                          final day = _workingHours[index];
                          final isWeekend = index >= 5;

                          return Container(
                            color: day['open']
                                ? (isWeekend
                                      ? scheme.primary.withOpacity(0.05)
                                      : Colors.transparent)
                                : scheme.surfaceContainerHighest.withOpacity(
                                    0.2,
                                  ),
                            child: Padding(
                              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                              child: _buildResponsiveDayRow(
                                day,
                                index,
                                isWeekend,
                                isVeryNarrow,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],

              SizedBox(height: isSmallScreen ? 24 : 32),

              // Next Button
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Next',
                  onPressed: _handleNextButtonPress,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveDayRow(
    Map<String, dynamic> day,
    int index,
    bool isWeekend,
    bool isVeryNarrow,
  ) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    if (isVeryNarrow) {
      return _buildVeryNarrowLayout(day, index, isWeekend);
    } else if (isSmallScreen) {
      return _buildMobileLayout(day, index, isWeekend);
    } else {
      return _buildDesktopLayout(day, index, isWeekend);
    }
  }

  Widget _buildDesktopLayout(
    Map<String, dynamic> day,
    int index,
    bool isWeekend,
  ) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      children: [
        // Day Name
        SizedBox(
          width: 100,
          child: Text(
            day['day'],
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: isWeekend ? scheme.primary : scheme.onSurface,
            ),
          ),
        ),

        SizedBox(width: 20),

        // Time Pickers or Closed
        Expanded(
          child: day['open']
              ? Row(
                  children: [
                    _GoogleTimeButton(
                      time: day['start'],
                      onPressed: () => _selectTime(context, true, index),
                      isSmall: false,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '–',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    _GoogleTimeButton(
                      time: day['end'],
                      onPressed: () => _selectTime(context, false, index),
                      isSmall: false,
                    ),
                    SizedBox(width: 12),
                    // Apply to All button for this day
                    _buildApplyToAllButton(index),
                    Spacer(),
                  ],
                )
              : Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Closed',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    // Apply to All button for this day (even when closed)
                    _buildApplyToAllButton(index),
                    Spacer(),
                  ],
                ),
        ),

        // Toggle Switch
        Switch.adaptive(
          value: day['open'],
          onChanged: (value) {
            setState(() {
              _workingHours[index]['open'] = value;
            });
          },
          activeColor: scheme.primary,
        ),
      ],
    );
  }

  Widget _buildMobileLayout(
    Map<String, dynamic> day,
    int index,
    bool isWeekend,
  ) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Day Name
            Text(
              day['day'],
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: isWeekend ? scheme.primary : scheme.onSurface,
              ),
            ),
            Spacer(),
            // Toggle Switch
            Switch.adaptive(
              value: day['open'],
              onChanged: (value) {
                setState(() {
                  _workingHours[index]['open'] = value;
                });
              },
              activeColor: scheme.primary,
            ),
          ],
        ),

        SizedBox(height: 12),

        // Time Pickers or Closed
        day['open']
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _GoogleTimeButton(
                        time: day['start'],
                        onPressed: () => _selectTime(context, true, index),
                        isSmall: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '–',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      _GoogleTimeButton(
                        time: day['end'],
                        onPressed: () => _selectTime(context, false, index),
                        isSmall: true,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  _buildApplyToAllButton(index),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Closed',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildApplyToAllButton(index),
                ],
              ),
      ],
    );
  }

  Widget _buildVeryNarrowLayout(
    Map<String, dynamic> day,
    int index,
    bool isWeekend,
  ) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                day['day'],
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isWeekend ? scheme.primary : scheme.onSurface,
                ),
              ),
            ),
            Switch.adaptive(
              value: day['open'],
              onChanged: (value) {
                setState(() {
                  _workingHours[index]['open'] = value;
                });
              },
              activeColor: scheme.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),

        SizedBox(height: 8),

        day['open']
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _GoogleTimeButton(
                    time: day['start'],
                    onPressed: () => _selectTime(context, true, index),
                    isSmall: true,
                  ),
                  SizedBox(height: 8),
                  _GoogleTimeButton(
                    time: day['end'],
                    onPressed: () => _selectTime(context, false, index),
                    isSmall: true,
                  ),
                  SizedBox(height: 8),
                  _buildApplyToAllButton(index),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Closed',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildApplyToAllButton(index),
                ],
              ),
      ],
    );
  }

  Widget _buildApplyToAllButton(int index) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return GestureDetector(
      onTap: () => _applyDaySettingsToAll(index),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 8 : 10,
          vertical: isSmallScreen ? 4 : 6,
        ),
        decoration: BoxDecoration(
          color: scheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: scheme.primary.withOpacity(0.3), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.copy,
              size: isSmallScreen ? 12 : 14,
              color: scheme.primary,
            ),
            SizedBox(width: isSmallScreen ? 4 : 6),
            Text(
              'Apply to All',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: scheme.primary,
                fontSize: isSmallScreen ? 11 : 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleTimeButton extends StatelessWidget {
  final TimeOfDay time;
  final VoidCallback onPressed;
  final bool isSmall;

  const _GoogleTimeButton({
    required this.time,
    required this.onPressed,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    String _formatTime() {
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
      return '$hour:$minute $period';
    }

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmall ? 10 : 12,
          vertical: isSmall ? 6 : 8,
        ),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: scheme.outlineVariant.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.access_time,
              size: isSmall ? 14 : 16,
              color: scheme.onSurfaceVariant,
            ),
            SizedBox(width: isSmall ? 4 : 6),
            Text(
              _formatTime(),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: isSmall ? 13 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
