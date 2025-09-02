import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/features/marketPlace/jobs/presentation/widgets/finish_setup.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/controllers/profile_provider.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';
import '../../../../../shared/widgets/custom_appbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isSetupFinished = false;
  int stepNumber = 2;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

@override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      left: false,
      right: false,
      child: Scaffold(
        body: Column(
          children: [
            // 🔹 Optional banner
            if (!isSetupFinished)
              ProfileCompletionBanner(
                stepNumber: 3,
                onFinishSetupPressed: () {
                  Navigator.pushNamed(context, AppRouter.signUpProcessScreen);
                },
              ),

            // 🔹 Custom AppBar placed manually below banner
            CustomAppBar(
              title: 'Leads',

              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRouter.homeServicesNotifications,
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.settingsScreen);
                  },
                ),
              ],
            ),


            // 🔹 Scrollable content below AppBar
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // _buildProfileHeader(),
                    _buildProfilePictureSection(),
                    _buildProfileActionButtons(),
                    _buildBusinessInfoSection(),
                    _buildCredentialsSection(),
                    _buildProfessionalLicenseSection(),
                    _buildPhotosVideosSection(),
                    _buildFeaturedProjectsSection(),
                    _buildReviewSection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  // 2. Profile Header Widget
  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      color: Theme.of(context).appBarTheme.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Profile',
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 3. Profile Picture Section Widget
  Widget _buildProfilePictureSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRouter.editProfilePicture);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(width: 4),
                  ],
                ),
              ),
            ],
          ),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 4),
                ),
                child: ClipOval(
                  child: Image.network(
                    "https://randomuser.me/api/portraits/men/1.jpg",
                    width: 180,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPlaceholder(),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRouter.editProfilePicture);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).unselectedWidgetColor,
                    border: Border.all(width: 2),
                  ),
                  child: const Icon(Icons.edit, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Replace your static Text widget with:
          Selector<ProfileProvider, String>(
            selector: (_, provider) => provider.name,
            builder: (context, name, child) {
              return Text(
                name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),

          const SizedBox(height: 4),

          Selector<ProfileProvider, String>(
            selector: (_, provider) => provider.companyName,
            builder: (context, companyName, child) {
              return Text(
                companyName,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              );
            },
          ),
        ],
      ),
    );
  }

  // 4. Profile Action Buttons Widget
  Widget _buildProfileActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'See how you rank',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Preview profile',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // 5. Business Info Section Widget
  Widget _buildBusinessInfoSection() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Business info',
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoItem(
            icon: Icons.phone,
            title: 'Phone Number',
            value: '(555) 123-4567',
            isPlaceholder: false,
          ),
          _buildInfoItem(
            icon: Icons.language,
            title: 'Website',
            value: 'www.example.com',
            isPlaceholder: false,
          ),
          _buildInfoItem(
            icon: Icons.location_on,
            title: 'Address',
            value: '123 Main St, Anytown, USA',
            isPlaceholder: false,
          ),
          _buildInfoItem(
            icon: Icons.calendar_today,
            title: 'Year Founded',
            value: '2010',
            isPlaceholder: false,
          ),
          _buildInfoItem(
            icon: Icons.group,
            title: 'Number of Employees',
            value: '15',
            isPlaceholder: false,
          ),
          _buildInfoItem(
            icon: Icons.share,
            title: 'Social Media',
            value: '@abcconstruction',
            isPlaceholder: false,
          ),
          _buildInfoItemForBusinessFAQS(
            icon: Icons.question_answer,
            title: 'Business FAQs',
            value: 'View FAQs',
            isPlaceholder: false,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your introduction',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRouter.editYourIntroduction);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    SizedBox(width: 4),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 35),
        ],
      ),
    );
  }

  // 6. Credentials Section Widget
  Widget _buildCredentialsSection() {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person_outline, color: theme.iconTheme.color),
                const SizedBox(width: 12),
                Text(
                  'Credentials',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Add a background check badge to your profile by getting a check from our third party website checker. This will help you win customer\'s trust and get hired more.',
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 16),

            CustomButton(
              text: 'Start a background check',
              enabled: true,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  // 7. Professional License Section Widget
  Widget _buildProfessionalLicenseSection() {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person_outline, color: theme.iconTheme.color),
                    const SizedBox(width: 12),
                    Text(
                      'Professional license',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customers prefer to hire licensed professionals. If you don\'t already have a license, we recommend that you get one.',
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                    ),
                    const SizedBox(height: 16),

                    CustomButton(
                      text: 'Add Professional License',
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRouter.addBusinessLicense,
                        );
                      },
                      enabled: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // 8. Photos & Videos Section Widget
  Widget _buildPhotosVideosSection() {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Photos & Videos',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.addPhotosAndVideoes);
                  },
                  icon: Icon(
                    Icons.edit,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRouter.addPhotosAndVideoes,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.dividerTheme.color ?? Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.add_circle_outline,
                          size: 36,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRouter.addPhotosAndVideoes,
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        "https://picsum.photos/300/300?random=$index",
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.dividerTheme.color ?? Colors.grey,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Show off your business",
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Include photos of your work (before and after), team, workspace, or equipment.",
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRouter.addPhotosAndVideoes,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 25,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("Add photos"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 9. Featured Projects Section Widget
  Widget _buildFeaturedProjectsSection() {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Featured Projects',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    CustomButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRouter.addFeatureProject,
                        );
                      },
                      text: 'Add Project',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.dividerTheme.color ?? Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRouter.addFeatureProject,
                          );
                        },
                        icon: Icon(
                          Icons.add,
                          size: 40,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection() {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Reviews",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      "0.0",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ...List.generate(
                      5,
                      (index) => Icon(
                        Icons.star_border,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text("0 reviews", style: theme.textTheme.bodySmall),
                const SizedBox(height: 16),
                ...List.generate(5, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Text(
                          "${5 - index} ★",
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: 0,
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHighest,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text("0%", style: theme.textTheme.bodySmall),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.dividerTheme.color ?? Colors.grey,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.emoji_emotions,
                            size: 28,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.star,
                            size: 24,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.favorite,
                            size: 24,
                            color: theme.colorScheme.primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Import and request reviews",
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Get reviews from past customers, even if they're not on Thumbtack.",
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'Get Reviews',
                        enabled: true,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
    bool isPlaceholder = false,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRouter.editBusinessInfo);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: theme.colorScheme.surfaceDim,
        ),
        child: ListTile(
          leading: Icon(icon),
          title: Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 14),
          ),
          trailing: Icon(Icons.chevron_right, color: theme.iconTheme.color),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildInfoItemForBusinessFAQS({
    required IconData icon,
    required String title,
    required String value,
    bool isPlaceholder = false,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRouter.editBusinessFAQS);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: theme.colorScheme.surfaceDim,
        ),
        child: ListTile(
          leading: Icon(icon),
          title: Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 14),
          ),
          trailing: Icon(Icons.chevron_right, color: theme.iconTheme.color),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  // Placeholder Widget
  Widget _buildPlaceholder() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, size: 32),
            const SizedBox(height: 8),
            Text('Add Photo', style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
