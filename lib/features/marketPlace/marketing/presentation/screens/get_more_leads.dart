import 'package:flutter/material.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/shared/widgets/custom_advanced_dropdown.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';

class GetMoreLeadsContent extends StatefulWidget {
  const GetMoreLeadsContent({super.key});

  @override
  State<GetMoreLeadsContent> createState() => _GetMoreLeadsContentState();
}

class _GetMoreLeadsContentState extends State<GetMoreLeadsContent> {
  final List<String> _countries = ['United States', 'Canada', 'UK'];
  final List<String> _services = [
    'Hair Styling',
    'Barber',
    'Nail Technician',
    'Makeup Artist',
    'Spa Services',
  ];
  String? _selectedCountry;
  String? _selectedService;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lead Generation Campaign',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Get featured at the top of search results and receive qualified leads directly.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),

          // Estimated Costs Cards
          Row(
            children: [
              Expanded(
                child: _buildCostCard(
                  title: 'Estimated Cost',
                  value: '\$85',
                  subtitle: 'per month',
                  icon: Icons.attach_money,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCostCard(
                  title: 'Estimated Leads',
                  value: '12-15',
                  subtitle: 'per month',
                  icon: Icons.people,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Visibility Metrics Section
          _buildVisibilityMetrics(),
          const SizedBox(height: 24),

          // Form Section
          _buildCampaignForm(),
          const SizedBox(height: 24),

          CustomButton(
            text: 'Select Subscription plan',
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.subscription_plan);
            },
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              CustomButton(text: 'Launch Campaign', onPressed: () {}),
              const SizedBox(width: 12),

              CustomButton(
                text: 'Save Draft',
                type: CustomButtonType.outline,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCostCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: color.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }

  Widget _buildVisibilityMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.visibility, size: 20, color: Colors.blue),
            const SizedBox(width: 8),
            const Text(
              'Visibility Metrics',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Text(
              'Learn more',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Search Impression Share
        _buildMetricProgress(
          title: 'Search Impression Share',
          value: 78,
          color: Colors.blue,
        ),
        const SizedBox(height: 12),

        // Top Placement Rate
        _buildMetricProgress(
          title: 'Top Placement Rate',
          value: 65,
          color: Colors.green,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildMetricProgress({
    required String title,
    required int value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Text(
              '$value%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: value / 100,
          backgroundColor: color.withOpacity(0.2),
          color: color,
          borderRadius: BorderRadius.circular(4),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildCampaignForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Campaign Details',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),

        // Service Type
        const Text(
          'Service Type',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        AdvancedDropdown(
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
        const SizedBox(height: 16),

        // Target Location
        const Text(
          'Target Location',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        AdvancedDropdown(
          hintText: 'Select your location',
          items: _countries,
          itemToString: (item) => item,
          enableSearch: true,
          onChanged: (value) {
            setState(() {
              _selectedCountry = value;
            });
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
