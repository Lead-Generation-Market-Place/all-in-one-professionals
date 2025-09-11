import 'package:flutter/material.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';

class ProfileVisibility extends StatefulWidget {
  const ProfileVisibility({super.key});

  @override
  State<ProfileVisibility> createState() => _ProfileVisibilityState();
}

class _ProfileVisibilityState extends State<ProfileVisibility> {
  int _selectedChipIndex = 0;
  final List<String> _chipLabels = ['Visibility Settings', 'Profile Preview'];

  bool isPublic = true;

  // For feature toggles - now with multiple items
  List<bool> _featureToggles = [true, true]; // Add more as needed

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Chips
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 12,
              children: List.generate(_chipLabels.length, (index) {
                return ChoiceChip(
                  label: Text(_chipLabels[index]),
                  selected: _selectedChipIndex == index,
                  onSelected: (_) {
                    setState(() {
                      _selectedChipIndex = index;
                    });
                  },
                  selectedColor: Theme.of(context).colorScheme.primary,
                  backgroundColor: Colors.grey[200],
                  labelStyle: TextStyle(
                    color: _selectedChipIndex == index
                        ? Colors.white
                        : Colors.black,
                  ),
                );
              }),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(12),
            child: CustomButton(
              text: 'Select Subscription Plan',
              onPressed: () {
                Navigator.pushNamed(context, AppRouter.subscription_plan);
              },
            ),
          ),

          /// Dynamic content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildChipContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildChipContent() {
    return _selectedChipIndex == 0
        ? _buildVisibilitySettings()
        : _buildProfilePreview();
  }

  // Function to show all toggles
  void _showAllToggles() {
    setState(() {
      for (int i = 0; i < _featureToggles.length; i++) {
        _featureToggles[i] = true;
      }
    });
  }

  // Function to hide all toggles
  void _hideAllToggles() {
    setState(() {
      for (int i = 0; i < _featureToggles.length; i++) {
        _featureToggles[i] = false;
      }
    });
  }

  Widget _buildVisibilitySettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Section Title
        const Text(
          "Visibility Controls",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        /// Info + Switch
        const SizedBox(height: 24),

        /// Show/Hide Buttons - Updated with onPressed functions
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _showAllToggles,
              icon: const Icon(Icons.visibility),
              label: const Text("Show All"),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: _hideAllToggles,
              icon: const Icon(Icons.visibility_off),
              label: const Text("Hide All"),
            ),
          ],
        ),

        const SizedBox(height: 24),

        /// Visibility Option Tile 1
        Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Row Title + Badge
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Total Hires',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        '5 Credits',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Show your total number of hires to increase trust.',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                const SizedBox(height: 12),

                /// Toggle Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Switch(
                      value: _featureToggles[0],
                      onChanged: (val) {
                        setState(() {
                          _featureToggles[0] = val;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        /// Visibility Option Tile 2
        Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Row Title + Badge
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Completed Projects',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        '3 Credits',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Display your completed projects to showcase experience.',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                const SizedBox(height: 12),

                /// Toggle Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Switch(
                      value: _featureToggles[1],
                      onChanged: (val) {
                        setState(() {
                          _featureToggles[1] = val;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        /// Conditional UI if private
        if (!isPublic) ...[
          const Text(
            "Approved Followers",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(child: Text("No approved followers yet")),
          ),
        ],
      ],
    );
  }

  Widget _buildProfilePreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Profile Preview",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "This is how your profile appears to others:",
          style: TextStyle(color: Colors.grey[700]),
        ),
        const SizedBox(height: 24),

        /// Profile Card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1160&q=80",
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "John Doe",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Professional Stylist",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),

                /// Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    _ProfileStat(label: "Followers", value: "125"),
                    _ProfileStat(label: "Following", value: "87"),
                    _ProfileStat(label: "Rating", value: "4.8"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
