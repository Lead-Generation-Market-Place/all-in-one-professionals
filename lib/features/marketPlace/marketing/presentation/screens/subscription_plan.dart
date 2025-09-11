import 'package:flutter/material.dart';

class SubscriptionPlan extends StatefulWidget {
  const SubscriptionPlan({super.key});

  @override
  State<SubscriptionPlan> createState() => _SubscriptionPlanState();
}

class _SubscriptionPlanState extends State<SubscriptionPlan> {
  int _selectedPlanIndex = 1; // Default to monthly
  final List<SubscriptionOption> _plans = [
    SubscriptionOption(
      type: 'Weekly',
      price: 9.99,
      period: 'week',
      description: 'Perfect for trying out our services',
      features: [
        'All basic features',
        '5 lead credits',
        'Email support',
        '7-day access',
      ],
      popular: false,
    ),
    SubscriptionOption(
      type: 'Monthly',
      price: 29.99,
      period: 'month',
      description: 'Our most popular plan for professionals',
      features: [
        'All premium features',
        '20 lead credits',
        'Priority support',
        'Advanced analytics',
        'Customizable profile',
      ],
      popular: true,
      savings: null,
    ),
    SubscriptionOption(
      type: 'Annual',
      price: 299.99,
      period: 'year',
      description: 'Best value for serious professionals',
      features: [
        'All premium features',
        'Unlimited lead credits',
        '24/7 priority support',
        'Advanced analytics',
        'Customizable profile',
        'Featured placement',
        'Dedicated account manager',
      ],
      popular: false,
      savings: '17%', // Calculated: (29.99*12 - 299.99) / (29.99*12)
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Choose Your Plan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Subscription Plans',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose the plan that works best for your business needs',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),

            // Plan Selection Cards
            _buildPlanCards(),
            const SizedBox(height: 32),

            // Features Comparison
            const Text(
              'Plan Comparison',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            _buildFeaturesTable(),
            const SizedBox(height: 32),

            // CTA Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showConfirmationDialog(context, _plans[_selectedPlanIndex]);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Subscribe Now',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Security & Guarantee
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.security, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Secure payment · 30-day money-back guarantee',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSmallScreen = constraints.maxWidth < 600;

        return isSmallScreen
            ? Column(
                children: _plans.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildPlanCard(entry.value, entry.key),
                  );
                }).toList(),
              )
            : Row(
                children: _plans.asMap().entries.map((entry) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: _buildPlanCard(entry.value, entry.key),
                    ),
                  );
                }).toList(),
              );
      },
    );
  }

  Widget _buildPlanCard(SubscriptionOption plan, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlanIndex = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _selectedPlanIndex == index
                ? Colors.blue
                : Colors.grey[300]!,
            width: _selectedPlanIndex == index ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Popular badge
            if (plan.popular) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'MOST POPULAR',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Plan type
            Text(
              plan.type,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _selectedPlanIndex == index ? Colors.blue : Colors.black,
              ),
            ),
            const SizedBox(height: 4),

            // Description
            Text(
              plan.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),

            // Price
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${plan.price}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '/${plan.period}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Savings badge
            if (plan.savings != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Save ${plan.savings}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Features list
            ...plan.features
                .map(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle, size: 16, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feature,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),

            const SizedBox(height: 20),

            // Select button
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: _selectedPlanIndex == index
                    ? Colors.blue
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _selectedPlanIndex == index
                      ? Colors.blue
                      : Colors.grey[300]!,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                _selectedPlanIndex == index ? 'Selected' : 'Select Plan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _selectedPlanIndex == index
                      ? Colors.white
                      : Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesTable() {
    final allFeatures = _plans.expand((plan) => plan.features).toSet().toList();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          // Header row
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Feature',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Weekly',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Monthly',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Annual',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Feature rows
          ...allFeatures
              .map(
                (feature) => Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey[100]!)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          feature,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Expanded(
                        child: Icon(
                          _plans[0].features.contains(feature)
                              ? Icons.check_circle
                              : Icons.remove,
                          color: _plans[0].features.contains(feature)
                              ? Colors.green
                              : Colors.grey[400],
                          size: 20,
                        ),
                      ),
                      Expanded(
                        child: Icon(
                          _plans[1].features.contains(feature)
                              ? Icons.check_circle
                              : Icons.remove,
                          color: _plans[1].features.contains(feature)
                              ? Colors.green
                              : Colors.grey[400],
                          size: 20,
                        ),
                      ),
                      Expanded(
                        child: Icon(
                          _plans[2].features.contains(feature)
                              ? Icons.check_circle
                              : Icons.remove,
                          color: _plans[2].features.contains(feature)
                              ? Colors.green
                              : Colors.grey[400],
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, SubscriptionOption plan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Subscription'),
        content: Text(
          'You are about to subscribe to the ${plan.type} plan for \$${plan.price}/${plan.period}.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle subscription logic here
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

class SubscriptionOption {
  final String type;
  final double price;
  final String period;
  final String description;
  final List<String> features;
  final bool popular;
  final String? savings;

  SubscriptionOption({
    required this.type,
    required this.price,
    required this.period,
    required this.description,
    required this.features,
    required this.popular,
    this.savings,
  });
}
