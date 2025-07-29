import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/core/constants/app_colors.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/controllers/profile_provider.dart';
import 'package:yelpax_pro/shared/widgets/bottom_navbar.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isSetupFinished = false;
  int stepNumber = 2;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        bottomNavigationBar: const BottomNavbar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Completion Banner
              if (!isSetupFinished) _buildProfileCompletionBanner(),

              // Profile Header
              _buildProfileHeader(),

              // Profile Picture Section
              _buildProfilePictureSection(),

              // Profile Action Buttons
              _buildProfileActionButtons(),

              // Business Info Section
              _buildBusinessInfoSection(),

              // Credentials Section
              _buildCredentialsSection(),

              // Professional License Section
              _buildProfessionalLicenseSection(),

              // Photos & Videos Section
              _buildPhotosVideosSection(),

              // Featured Projects Section
              _buildFeaturedProjectsSection(),

              // Review Section
              _buildReviewSection(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 1. Profile Completion Banner Widget
  Widget _buildProfileCompletionBanner() {
    return Container(
      color: AppColors.accent,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wrap the Text with Flexible to allow wrapping
          Flexible(
            child: Text(
              'Only $stepNumber setup tasks left before you can start getting leads.',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              softWrap: true,
              maxLines: 2, // Optional: limit to 2 lines
              overflow: TextOverflow
                  .ellipsis, // Optional: fade or ellipsis if too long
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Finish Setup'),
          ),
        ],
      ),
    );
  }

  // 2. Profile Header Widget
  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Profile',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Changed from AppColors.textPrimary
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.calendar_today,
                  color: Colors.grey, // Changed from AppColors.neutral700
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.grey,
                ), // Changed from AppColors.neutral700
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRouter.editProfilePicture);
                },
                child: const Row(
                  children: [
                    Icon(Icons.edit, color: AppColors.primaryBlue, size: 20),
                    SizedBox(width: 4),
                    Text(
                      'Edit',
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
                  border: Border.all(color: AppColors.primaryBlue, width: 4),
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
                    color: AppColors.primaryBlue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 16),
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
                  color: AppColors.neutral700,
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
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral700,
                ),
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
                    side: const BorderSide(
                      color: AppColors.primaryBlue,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'See how you rank',
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Preview profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Business info',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Changed from AppColors.textPrimary
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
              const Text(
                'Your introduction',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRouter.editYourIntroduction);
                },
                child: const Row(
                  children: [
                    Icon(Icons.edit, color: AppColors.primaryBlue, size: 20),
                    SizedBox(width: 4),
                    Text(
                      'Edit',
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.person_outline,
                  color: Colors.grey,
                ), // Changed from AppColors.neutral700
                SizedBox(width: 12),
                Text(
                  'Credentials',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black, // Changed from AppColors.textPrimary
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Add a background check badge to your profile by getting a check from our third party website checker. This will help you win customer\'s trust and get hired more.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey, // Changed from AppColors.textSecondary
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: AppColors.primaryBlue),
                ),
              ),
              child: const Text(
                'Start a background check',
                style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 7. Professional License Section Widget
  Widget _buildProfessionalLicenseSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.person_outline,
                      color: Colors.grey,
                    ), // Changed from AppColors.neutral700
                    SizedBox(width: 12),
                    Text(
                      'Professional license',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color:
                            Colors.black, // Changed from AppColors.textPrimary
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Customers prefer to hire licensed professionals. If you don\'t already have a license, we recommend that you get one.',
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            Colors.grey, // Changed from AppColors.textSecondary
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRouter.addBusinessLicense,
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: AppColors.primaryBlue),
                        ),
                      ),
                      child: const Text(
                        'Add a license',
                        style: TextStyle(
                          color: AppColors.primaryBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
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
                const Text(
                  'Photos & Videos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black, // Changed from AppColors.textPrimary
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.addPhotosAndVideoes);
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: AppColors.primaryBlue,
                    size: 18,
                  ),
                  label: const Text(
                    'Edit',
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
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
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add_circle_outline,
                          color: Colors.blue,
                          size: 36,
                        ),
                      ),
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () {},
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
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Show off your business",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Include photos of your work (before and after), team, workspace, or equipment.",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(text: 'Add Photos',enabled: true,onPressed: (){

                  },)
                  // ElevatedButton(
                  //   onPressed: () {},
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.black,
                  //     padding: const EdgeInsets.symmetric(vertical: 12),
                  //   ),
                  //   child: const Text("Add photos",style: TextStyle(color: Colors.white),),
                  // ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
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
                    const Text(
                      'Featured Projects',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add_circle_outline_rounded),
                      label: const Text('Add Project'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  "No featured projects yet.",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Reviews",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    Text(
                      "0.0",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.star_border, color: Colors.teal),
                    Icon(Icons.star_border, color: Colors.teal),
                    Icon(Icons.star_border, color: Colors.teal),
                    Icon(Icons.star_border, color: Colors.teal),
                    Icon(Icons.star_border, color: Colors.teal),
                  ],
                ),
                const SizedBox(height: 4),
                const Text("0 reviews", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 16),
                ...List.generate(5, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Text(
                          "${5 - index} ★",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: 0,
                            backgroundColor: Colors.grey.shade200,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text("0%"),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.emoji_emotions,
                            size: 28,
                            color: Colors.black,
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.star, size: 24, color: Colors.amber),
                          SizedBox(width: 6),
                          Icon(
                            Icons.favorite,
                            size: 24,
                            color: Colors.lightBlue,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Import and request reviews",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Get reviews from past customers, even if they're not on Thumbtack.",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 16),
                     CustomButton(text: 'Get Reviews',enabled: true , onPressed: (){
                      
                     },)
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
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRouter.editBusinessInfo);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Icon(icon), // Changed from AppColors.neutral700
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black, // Changed from AppColors.textPrimary
            ),
          ),
          subtitle: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: isPlaceholder
                  ? Colors.grey[600] // Changed from AppColors.textTertiary
                  : Colors.grey, // Changed from AppColors.textSecondary
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: Colors.grey, // Changed from AppColors.neutral700
          ),
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
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRouter.editBusinessFAQS);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Icon(icon), // Changed from AppColors.neutral700
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black, // Changed from AppColors.textPrimary
            ),
          ),
          subtitle: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: isPlaceholder
                  ? Colors.grey[600] // Changed from AppColors.textTertiary
                  : Colors.grey, // Changed from AppColors.textSecondary
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: Colors.grey, // Changed from AppColors.neutral700
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  // Placeholder Widget
  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, size: 32, color: Colors.grey[500]),
            const SizedBox(height: 8),
            Text(
              'Add Photo',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
