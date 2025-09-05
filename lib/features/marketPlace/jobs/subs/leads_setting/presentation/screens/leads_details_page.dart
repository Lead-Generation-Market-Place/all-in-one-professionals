import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/core/constants/app_colors.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';

class LeadsDetailsPage extends StatefulWidget {
  const LeadsDetailsPage({super.key});

  @override
  State<LeadsDetailsPage> createState() => _LeadsDetailsPageState();
}

class _LeadsDetailsPageState extends State<LeadsDetailsPage> {
  String? _selectedReminder;
  final String phone = '079**************'; // Example phone number
  final String email = 'm**************9@g****l.com'; // Example email
  final int credits = 8; // Example credits
  void _showReminderBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Set a reminder',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildReminderOption('In 30 minutes', Icons.access_time),
              _buildReminderOption('In 1 hour', Icons.access_time),
              _buildReminderOption('In 3 hours', Icons.access_time),
              _buildReminderOption('Tomorrow at 09:00', Icons.calendar_today),
              _buildReminderOption('Monday at 09:00', Icons.calendar_today),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Create reminder',
                isFullWidth: true,
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Reminder set for $_selectedReminder'),
                      backgroundColor: colorScheme.surface,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showResponsesBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.info_outline,
                  size: 30,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Response Limit Notice',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'A maximum number of 5 professionals can respond to each request.\n\n'
                'Being the first to reply will increase your chances of getting a response from the customer.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Got it',
                isFullWidth: true,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReminderOption(String text, IconData icon) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedReminder = text;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _selectedReminder == text
                ? theme.colorScheme.primary.withOpacity(0.1)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _selectedReminder == text
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant,
              width: _selectedReminder == text ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Text(text, style: theme.textTheme.bodyMedium),
              const Spacer(),
              if (_selectedReminder == text)
                Icon(
                  Icons.check_circle,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lead Details'),
        centerTitle: true,

       
      
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.primary.withOpacity(0.25),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.primary,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Muna',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Staines-Upon-Thames, TW18',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.work,
                              size: 16,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'House Cleaning',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Be the first to respond banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surface,

                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: colorScheme.primary.withOpacity(0.25),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      // color: colorScheme.primary.withOpacity(0.15),
                      // shape: BoxShape.circle,
                      // boxShadow: [
                      // BoxShadow(
                      //   color: colorScheme.primary.withOpacity(0.25),
                      //   blurRadius: 6,
                      //   offset: const Offset(0, 3),
                      // ),
                      // ],
                    ),
                    child: Icon(
                      Icons.timer,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Be the 1st to respond',
                          // style: theme.textTheme.headlineSmall?.copyWith(
                          //   color: colorScheme.primary,
                          //   fontWeight: FontWeight.w700,
                          //   letterSpacing: 0.3,
                          // ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            OutlinedButton(
                              onPressed: _showResponsesBottomSheet,
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: theme.colorScheme.outlineVariant,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                textStyle: theme.textTheme.labelLarge,
                              ),
                              child: const Text('Details'),
                            ),
                            const SizedBox(width: 14),
                            CustomButton(
                              text: 'Set reminder',
                              onPressed: _showReminderBottomSheet,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Highlights section
            Text(
              'Highlights',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildHighlightChip('Urgent', Icons.warning_amber_rounded),
                _buildHighlightChip(
                  'High hiring intent',
                  Icons.trending_up_rounded,
                ),
                _buildHighlightChip('Verified phone', Icons.verified_rounded),
                _buildHighlightChip('Frequent user', Icons.star_rounded),
              ],
            ),

            const SizedBox(height: 24),
            Text(
              'Contact Details',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(2),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.phone, size: 20, color: colorScheme.primary),
                      SizedBox(width: 12),
                      Text(phone), // assuming phone is a variable
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.email, size: 20, color: colorScheme.primary),
                      SizedBox(width: 12),
                      Text(email), // assuming phone is a variable
                    ],
                  ),

                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.credit_card_outlined,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                      SizedBox(width: 12),
                      Text(
                        '${credits} credits',
                      ), // assuming phone is a variable
                    ],
                  ),
                ],
              )
              
            ),
      

      

            const SizedBox(height: 24),

            // Details section
            Text(
              'Details',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              'What type of property needs cleaning?',
              'House',
              Icons.home_work,
            ),
            _buildDetailRow(
              'How often do you need cleaning?',
              'Weekly',
              Icons.calendar_today,
            ),
            _buildDetailRow(
              'How many bedroom(s) need cleaning?',
              '3 bedrooms',
              Icons.bed,
            ),
            _buildDetailRow(
              'How many bathroom(s) need cleaning?',
              '1 bathroom + 1 additional toilet',
              Icons.bathtub,
            ),
            _buildDetailRow(
              'How many reception room(s) need cleaning?',
              '1',
              Icons.living,
            ),
            _buildDetailRow(
              'What type of cleaning would you like?',
              'Standard cleaning',
              Icons.cleaning_services,
            ),
            _buildDetailRow(
              'Do you currently have a cleaner?',
              'Yes, replacing a current cleaner',
              Icons.person,
            ),
            _buildDetailRow(
              'When are the best days for cleaning?',
              'Any',
              Icons.event_available,
            ),
            _buildDetailRow(
              'Will you be supplying cleaning materials/equipment?',
              'Yes - Cleaning materials and equipment',
              Icons.cleaning_services,
            ),
            _buildDetailRow(
              'How likely are you to make a hiring decision?',
              'I\'m ready to hire now',
              Icons.thumb_up,
            ),

            const SizedBox(height: 16),

            // Additional details
            // Container(
            //   padding: const EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: colorScheme.surface,
            //     borderRadius: BorderRadius.circular(16),
            //     border: Border.all(
            //       color: colorScheme.primary.withOpacity(0.25),
            //     ),
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Row(
            //         children: [
            //           Icon(
            //             Icons.note,
            //             size: 18,
            //             color: theme.colorScheme.onSurfaceVariant,
            //           ),
            //           const SizedBox(width: 8),
            //           Text(
            //             'Additional Details',
            //             style: TextStyle(
            //               fontWeight: FontWeight.bold,
            //               color: theme.colorScheme.onSurface,
            //             ),
            //           ),
            //         ],
            //       ),
            //       const SizedBox(height: 8),
            //       Text(
            //         'I need 4 to 5 hours once a week',
            //         style: theme.textTheme.bodyMedium,
            //       ),
            //     ],
            //   ),
            // ),

            const SizedBox(height: 24),

            // Location
            Text(
              'Location',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 200, // Set your desired height
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.primary.withOpacity(0.25),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    51.4300,
                    -0.5167,
                  ), // Example: Staines-Upon-Thames
                  zoom: 14,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId('lead_location'),
                    position: LatLng(51.4300, -0.5167),
                    infoWindow: InfoWindow(title: 'Customer Location'),
                  ),
                },
                myLocationEnabled: false,
                zoomControlsEnabled: false,
                onMapCreated: (GoogleMapController controller) {
                  // Optional: store the controller
                },
              ),
            ),

            const SizedBox(height: 32),

            // Contact button
            // Contact + Pass buttons
            SafeArea(
              child: Row(
                children: [
                  Expanded(
                    flex: 3, // 3/4 of the row
                    child: CustomButton(
                      text: 'Contact Muna',
                      isFullWidth: true,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRouter.response_credits,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1, // 1/4 of the row
                    child: CustomButton(
                      text: 'Pass',
                      isFullWidth: true,
                      onPressed: () {
                        Navigator.pop(context); // or whatever action you want
                      },
                    ),
                  ),
                ],
              ),
            ),

           
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightChip(String text, IconData icon) {
    final theme = Theme.of(context);
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(text),

      side: BorderSide(color: theme.colorScheme.outlineVariant),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  
  Widget _buildDetailRow(String question, String answer, IconData icon) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  answer,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
