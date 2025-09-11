import 'package:flutter/material.dart';
import 'package:yelpax_pro/shared/widgets/custom_advanced_dropdown.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';
import 'package:yelpax_pro/shared/widgets/custom_input.dart';

class CustomerRetention extends StatefulWidget {
  const CustomerRetention({super.key});

  @override
  State<CustomerRetention> createState() => _CustomerRetentionState();
}

class _CustomerRetentionState extends State<CustomerRetention> {
  final double campaignCost = 37.5;
  final double campaignCostPerCustomer = 0.25;
  final List<String> offerTypes = [
    'Discount Offer - 10-15% OFF',
    'Service Reminder - Maintenance',
    'Referral Program - Earn Credits',
  ];
  final List<String> _services = [
    'Hair Styling',
    'Barber',
    'Nail Technician',
    'Makeup Artist',
    'Spa Services',
  ];
  String? _selectedOfferType;
  String? _selectedService;
  DateTime? _startDate;
  DateTime? _endDate;

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
    final bool isDiscountOffer =
        _selectedOfferType?.contains('Discount') ?? false;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),
          const SizedBox(height: 16),

          // Campaign Form
          _buildCampaignForm(isDiscountOffer),
          const SizedBox(height: 24),

          // Campaign Dates
          _buildDateSection(),
          const SizedBox(height: 24),

          // Stats Cards
          _buildStatsSection(),
          const SizedBox(height: 24),

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
          'Customer Retention Campaign',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Re-engage past customers with offers and reminders to boost repeat business.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildCampaignForm(bool isDiscountOffer) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Campaign Details',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
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

            // Offer Type
            _buildFormField(
              label: 'Offer Type',
              child: AdvancedDropdown(
                hintText: 'Select offer type',
                items: offerTypes,
                itemToString: (item) => item,
                enableSearch: false,
                onChanged: (value) {
                  setState(() {
                    _selectedOfferType = value;
                  });
                },
              ),
            ),

            // Customer Count
            _buildFormField(
              label: 'Number of Past Customers',
              child: CustomInputField(
                controller: _customerCountController,
                hintText: 'Enter number of customers',
                prefixIcon: Icons.people,
                
              ),
            ),

            // Conditional Discount Field
            if (isDiscountOffer) ...[
              const SizedBox(height: 16),
              _buildFormField(
                label: 'Discount Percentage',
                child: CustomInputField(
                  controller: _discountController,
                  hintText: 'Enter discount percentage (e.g., 15)',
                  prefixIcon: Icons.percent,
               
                ),
              ),
            ],
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

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Campaign Dates',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDatePicker(
                label: 'Start Date',
                selectedDate: _startDate,
                onDateSelected: (date) {
                  setState(() {
                    _startDate = date;
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDatePicker(
                label: 'End Date',
                selectedDate: _endDate,
                onDateSelected: (date) {
                  setState(() {
                    _endDate = date;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime? selectedDate,
    required Function(DateTime) onDateSelected,
  }) {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate != null
                  ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                  : 'Select $label',
              style: TextStyle(
                color: selectedDate != null ? Colors.black : Colors.grey,
              ),
            ),
            Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth > 600;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isWide ? 4 : 2,
          childAspectRatio: isWide ? 1.2 : 1.5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildStatCard(
              title: 'Target Audience',
              value: '\$150',
              subtitle: 'past customers',
              icon: Icons.attach_money,
              color: Colors.blue,
            ),
            _buildStatCard(
              title: 'Expected Reach',
              value: '128',
              subtitle: '85% of audience',
              icon: Icons.people,
              color: Colors.green,
            ),
            _buildStatCard(
              title: 'Avg. Response Rate',
              value: '12-18%',
              subtitle: 'Industry Standard',
              icon: Icons.trending_up,
              color: Colors.orange,
            ),
            _buildStatCard(
              title: 'Campaign Cost',
              value: '\$$campaignCost',
              subtitle: '\$$campaignCostPerCustomer per customer',
              icon: Icons.account_balance_wallet,
              color: Colors.purple,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
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
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
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
            text: 'Save Draft',
            type: CustomButtonType.outline,
            onPressed: () {
              // Handle save draft
            },
          ),
        ),
      ],
    );
  }
}
