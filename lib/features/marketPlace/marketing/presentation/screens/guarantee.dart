import 'package:flutter/material.dart';
import 'package:yelpax_pro/shared/widgets/custom_advanced_dropdown.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';

class Guarantee extends StatefulWidget {
  const Guarantee({super.key});

  @override
  State<Guarantee> createState() => _GuaranteeState();
}

class _GuaranteeState extends State<Guarantee> {
  final double campaignCost = 37.5;
  final double campaignCostPerCustomer = 0.25;

  final List<String> _services = [
    'Hair Styling',
    'Barber',
    'Nail Technician',
    'Makeup Artist',
    'Spa Services',
  ];

  final List<String> _guarantee_duration = [
    '7 days',
    '30 days',
    '90 days Save 5%',
    '1 year Save 15%',
  ];

  String? _selectedService;
  String? _selectedGuaranteeDuration;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isProShieldEnabled = false;
  bool _isAnnualBilling = false;

  // Track selected guarantee type
  String? _selectedGuaranteeType;

  // Guarantee types with their costs and details
  final Map<String, Map<String, dynamic>> _guaranteeTypes = {
    'Satisfaction Guarantee': {
      'cost': 15,
      'savings': 0.25,
      'coverage': 8,
      'subtitle': 'Full refund if not satisfied with the service',
      'icon': Icons.attach_money,
      'color': Colors.blue,
    },
    'Workmanship Guarantee': {
      'cost': 25,
      'savings': 0.20,
      'coverage': 10,
      'subtitle': 'Free fixes for workmanship issues for 90 days',
      'icon': Icons.build,
      'color': Colors.green,
    },
    'Double-Back Guarantee': {
      'cost': 35,
      'savings': 0.15,
      'coverage': 15,
      'subtitle': "We'll send another pro if you're not happy",
      'icon': Icons.trending_up,
      'color': Colors.orange,
    },
  };

  // Form controllers
  final TextEditingController _customerCountController =
      TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  @override
  void dispose() {
    _customerCountController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate credit details based on selection
    final int currentCredits = 67;
    int selectedCost = 0;
    double savingsPercentage = 0;
    int coverage = 0;

    if (_selectedGuaranteeType != null &&
        _guaranteeTypes.containsKey(_selectedGuaranteeType)) {
      selectedCost = _guaranteeTypes[_selectedGuaranteeType]!['cost'];
      savingsPercentage = _guaranteeTypes[_selectedGuaranteeType]!['savings'];
      coverage = _guaranteeTypes[_selectedGuaranteeType]!['coverage'];
    }

    final int totalCost = selectedCost;
    final int savingsAmount = (totalCost * savingsPercentage).round();
    final int finalCost = totalCost - savingsAmount;
    final int remainingCredits = currentCredits - finalCost;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),
          const SizedBox(height: 16),

          // Toggle for ProShield
          _buildProShieldToggle(),
          const SizedBox(height: 16),

          // Campaign Form
          _buildCampaignForm(),
          const SizedBox(height: 24),

          // Stats Cards
          _buildStatsSection(),
          const SizedBox(height: 24),

          // Credit Summary
          _buildCreditSummary(
            totalCost: totalCost,
            savingsAmount: savingsAmount,
            finalCost: finalCost,
            remainingCredits: remainingCredits,
            coverage: coverage,
            savingPercentage: savingsPercentage
          ),
          const SizedBox(height: 24),

          // Update Guarantee Button
          CustomButton(
            text: 'Update Guarantee',
            onPressed: () {
              // Handle update guarantee
            },
          ),
          const SizedBox(height: 16),

          // Action Buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ProShield Guarantee',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Build trust and win more customers with our comprehensive satisfaction guarantee program.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildProShieldToggle() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Enable ProShield Guarantee',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            Switch(
              value: _isProShieldEnabled,
              onChanged: (value) {
                setState(() {
                  _isProShieldEnabled = value;
                });
              },
              activeThumbColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditSummary({
    required int totalCost,
    required int savingsAmount,
    required int finalCost,
    required int remainingCredits,
    required int coverage,
    required double savingPercentage
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Credit Summary',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),

            if (_selectedGuaranteeType == null)
              Text(
                'Select a guarantee type to see cost details',
                style: Theme.of(context).textTheme.bodyMedium,
              )
            else ...[
              Text(
                'This guarantee will cost',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '$finalCost Credits',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (savingsAmount > 0)
                    Text(
                      'save ${(savingPercentage * 100).round()}%',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Coverage: $coverage Credits',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'You will have $remainingCredits credits remaining',
                style: TextStyle(
                  color: remainingCredits < 0 ? Colors.red : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // Divider line
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(),
              ),

              // Benefits list
              _buildBenefitItem(
                'Includes claim processing and customer support',
              ),
              _buildBenefitItem(
                'Marketing materials to promote your guarantee',
              ),
              _buildBenefitItem('No hidden fees or setup costs'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.green[700], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildCampaignForm() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Service Type
            _buildFormField(
              label: 'Service Type',
              child: AdvancedDropdown(
                hintText: 'Select your service',
                items: _services,
                itemToString: (item) => item,
                enableSearch: true,
                onChanged: (value) {
                  setState(() {
                    _selectedService = value;
                  });
                },
              ),
            ),

            // Guarantee Duration
            _buildFormField(
              label: 'Guarantee Duration',
              child: AdvancedDropdown(
                hintText: 'Select your guarantee duration',
                items: _guarantee_duration,
                itemToString: (item) => item,
                enableSearch: true,
                onChanged: (value) {
                  setState(() {
                    _selectedGuaranteeDuration = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 10),

            // Billing Cycle Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Annual Billing (Save 15%)',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Switch(
                  value: _isAnnualBilling,
                  onChanged: (value) {
                    setState(() {
                      _isAnnualBilling = value;
                    });
                  },
                  activeThumbColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        child,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Guarantee Type',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            // Determine the number of columns based on available width
            int crossAxisCount = 2;
            if (constraints.maxWidth > 900) {
              crossAxisCount = 4;
            } else if (constraints.maxWidth > 600) {
              crossAxisCount = 2;
            } else {
              crossAxisCount = 1;
            }

            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              childAspectRatio: _calculateChildAspectRatio(
                constraints.maxWidth,
              ),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: _guaranteeTypes.entries.map((entry) {
                final String title = entry.key;
                final Map<String, dynamic> details = entry.value;

                return _buildStatCard(
                  title: title,
                  value: '${details['cost']} credits',
                  subtitle: details['subtitle'],
                  coverage: 'Coverage: ${details['coverage']} Credits',
                  icon: details['icon'],
                  color: details['color'],
                  isSelected: _selectedGuaranteeType == title,
                  onTap: () {
                    setState(() {
                      _selectedGuaranteeType = title;
                    });
                  },
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  double _calculateChildAspectRatio(double width) {
    if (width > 900) return 1.2;
    if (width > 600) return 1.5;
    return 1.8;
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required String coverage,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: isSelected ? 4 : 2,
        color: isSelected ? color.withOpacity(0.1) : null,
        shape: RoundedRectangleBorder(
          side: isSelected
              ? BorderSide(color: color, width: 2)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 18, color: color),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: color,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    coverage,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 400) {
          // Wide layout: buttons side by side
          return Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Launch Campaign',
                  onPressed: () {
                    // Handle campaign launch
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: 'Buy more credits',
                  type: CustomButtonType.outline,
                  onPressed: () {
                    // Handle buy more credits
                  },
                ),
              ),
            ],
          );
        } else {
          // Narrow layout: buttons stacked
          return Column(
            children: [
              CustomButton(
                text: 'Launch Campaign',
                onPressed: () {
                  // Handle campaign launch
                },
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Buy more credits',
                type: CustomButtonType.outline,
                onPressed: () {
                  // Handle buy more credits
                },
              ),
            ],
          );
        }
      },
    );
  }
}
