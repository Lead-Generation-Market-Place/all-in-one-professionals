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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
              surface: Theme.of(context).colorScheme.surface,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
            dialogBackgroundColor: Theme.of(context).colorScheme.surface,
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

      // Show apply to all dialog
      _showApplyToAllDialog(context, isStart, picked, index);
    }
  }

  void _showApplyToAllDialog(
    BuildContext context,
    bool isStart,
    TimeOfDay time,
    int index,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Apply to all days?',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          content: Text(
            'Do you want to apply this ${isStart ? 'start' : 'end'} time to all days?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _applyTimeToAll(isStart, time);
                Navigator.pop(context);
              },
              child: Text('Apply to All'),
            ),
          ],
        );
      },
    );
  }

  void _applyTimeToAll(bool isStart, TimeOfDay time) {
    setState(() {
      for (int i = 0; i < _workingHours.length; i++) {
        if (_workingHours[i]['open']) {
          if (isStart) {
            _workingHours[i]['start'] = time;
          } else {
            _workingHours[i]['end'] = time;
          }
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Time applied to all days'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _applyAllSettings() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Apply to all days?'),
          content: Text(
            'This will apply the first day\'s settings to all other days.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _applyAllDaysSettings();
              },
              child: Text('Apply to All'),
            ),
          ],
        );
      },
    );
  }

  void _applyAllDaysSettings() {
    setState(() {
      final referenceDay = _workingHours[0];
      for (int i = 1; i < _workingHours.length; i++) {
        _workingHours[i]['open'] = referenceDay['open'];
        _workingHours[i]['start'] = referenceDay['start'];
        _workingHours[i]['end'] = referenceDay['end'];
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Settings applied to all days'),
        duration: Duration(seconds: 2),
      ),
    );
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
        // actions: [
        //   if (!isVerySmallScreen)
        //     IconButton(
        //       icon: Icon(Icons.copy),
        //       onPressed: _applyAllSettings,
        //       tooltip: 'Apply to all days',
        //     ),
        // ],
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
              // Header with Availability Toggle
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
                      Icons.business_center,
                      color: scheme.primary,
                      size: isSmallScreen ? 24 : 28,
                    ),
                    SizedBox(width: isSmallScreen ? 12 : 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Business Status',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: isSmallScreen ? 16 : 18,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            _isAvailable
                                ? 'Currently accepting new jobs'
                                : 'Not accepting new jobs',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: _isAvailable,
                      onChanged: (value) {
                        setState(() {
                          _isAvailable = value;
                        });
                      },
                      activeColor: scheme.primary,
                    ),
                  ],
                ),
              ),

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
                  if (!isSmallScreen) SizedBox(width: 16),
                  if (!isSmallScreen)
                    OutlinedButton.icon(
                      onPressed: _applyAllSettings,
                      icon: Icon(Icons.copy, size: 18),
                      label: Text('Apply to All'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 12 : 16,
                          vertical: isSmallScreen ? 10 : 12,
                        ),
                      ),
                    ),
                ],
              ),

              if (isSmallScreen) SizedBox(height: 12),
              if (isSmallScreen)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _applyAllSettings,
                    icon: Icon(Icons.copy, size: 18),
                    label: Text('Apply to All Days'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
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
                              : scheme.surfaceVariant.withOpacity(0.2),
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

              SizedBox(height: isSmallScreen ? 24 : 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Availability saved successfully'),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: scheme.primary,
                    foregroundColor: scheme.onPrimary,
                    padding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 16 : 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Save Changes',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: isSmallScreen ? 16 : 18,
                    ),
                  ),
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
                        color: scheme.surfaceVariant.withOpacity(0.3),
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
            ? Row(
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
              )
            : Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: scheme.surfaceVariant.withOpacity(0.3),
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
                ],
              )
            : Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: scheme.surfaceVariant.withOpacity(0.3),
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
      ],
    );
  }

  String _formatTimeOfDay(TimeOfDay tod) {
    final hour = tod.hourOfPeriod == 0 ? 12 : tod.hourOfPeriod;
    final minute = tod.minute.toString().padLeft(2, '0');
    final period = tod.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
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
          color: scheme.surfaceVariant.withOpacity(0.2),
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
