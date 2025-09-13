import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:yelpax_pro/features/marketPlace/marketing/presentation/screens/customer_retention.dart';
import 'package:yelpax_pro/features/marketPlace/marketing/presentation/screens/get_more_leads.dart';
import 'package:yelpax_pro/features/marketPlace/marketing/presentation/screens/guarantee.dart';
import 'package:yelpax_pro/features/marketPlace/marketing/presentation/screens/profile_visibility.dart';
import 'package:yelpax_pro/shared/widgets/custom_button.dart';

enum MarketingContentType { video, profileCard, textCard }

class MarketingContent {
  final MarketingContentType type;
  final String? videoUrl;
  final String? name;
  final String? profileUrl;
  final String? description;
  final int? rating; // 0–5 stars
  final List<String>? badges;

  MarketingContent({
    required this.type,
    this.videoUrl,
    this.name,
    this.profileUrl,
    this.description,
    this.rating,
    this.badges,
  });
}

// Content classes for each category


class MarketingDashboard extends StatefulWidget {
  const MarketingDashboard({super.key});

  @override
  State<MarketingDashboard> createState() => _MarketingDashboardState();
}

class _MarketingDashboardState extends State<MarketingDashboard> {
  final ScrollController _scrollController = ScrollController();
  int _currentCarouselIndex = 0;
  int _selectedCategoryIndex = 0;

  final List<String> marketingCategories = [
    'Get More Leads',
    'Profile Visibility',
    'Customer Retention',
    'Guarantee',
  ];

  final List<MarketingContent> marketingItems = [
    MarketingContent(
      type: MarketingContentType.profileCard,
      name: "Sarah Doe",
      profileUrl:
          "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1287&q=80",
      description:
          "Top-rated stylist from NY with over 5 years of experience specializing in modern haircuts and color techniques.",
      rating: 5,
      badges: ["Top Rated", "Style Expert"],
    ),
    MarketingContent(
      type: MarketingContentType.textCard,
      description:
          "Our services increased client engagement by 45% and boosted repeat business by 32% in the last quarter.",
    ),
    MarketingContent(
      type: MarketingContentType.video,
      videoUrl: "https://www.example.com/sample_video.mp4", // placeholder
    ),
    MarketingContent(
      type: MarketingContentType.profileCard,
      name: "Michael Chen",
      profileUrl:
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1287&q=80",
      description:
          "Award-winning barber known for precision cuts and beard styling. Trained in London and Milan.",
      rating: 4,
      badges: ["Award Winner", "Precision Specialist"],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Marketing',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
          bottom: TabBar(
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: const [
              Tab(text: 'Review Based Marketing'),
              Tab(text: 'Marketing Center'),
            ],
          ),
        ),
        body: TabBarView(
          children: [_reviewBasedMarketing(), _marketingCenter()],
        ),
      ),
    );
  }

  Widget _reviewBasedMarketing() {
    return ListView(
      padding: const EdgeInsets.all(16),
      controller: _scrollController,
      children: [
        const Text(
          'Review–Driven Marketing for Professionals',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),

        const SizedBox(height: 12),
        Text(
          'Turn your satisfied customers into your best sales tool. Share reviews as ready-made posts on Instagram/TikTok or directly to Shootak, and increase your visibility in search results.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        const SizedBox(height: 24),

        // Carousel with indicators
        Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 240,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.85,
                aspectRatio: 2.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentCarouselIndex = index;
                  });
                },
              ),
              items: marketingItems.map((item) {
                return Builder(builder: (context) => _buildCarouselItem(item));
              }).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: marketingItems.asMap().entries.map((entry) {
                return Container(
                  width: 12.0,
                  height: 12.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                 
                  ),
                );
              }).toList(),
            ),
          ],
        ),

        const SizedBox(height: 28),

        // Action buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download, size: 18),
              label: const Text('Download'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.share, size: 18),
              label: const Text('Share to shootak'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        CustomButton(
          text: 'Download to share',
          enabled: true,
          onPressed: () {},
        ),
        const SizedBox(height: 28),

        // Metrics section
        const Text(
          'Your Marketing Impact',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildMetricCard('45%', 'Engagement Increase'),
            _buildMetricCard('32%', 'Repeat Business'),
            _buildMetricCard('28%', 'New Clients'),
          ],
        ),

        const SizedBox(height: 28),

        // Tips section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
              color: Theme.of(context).disabledColor,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.lightbulb_outline, color: Colors.amber),
                  SizedBox(width: 8),
                  Text(
                    'Pro Tip',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Share customer reviews within 24 hours of receiving them for maximum impact. Tag your location and use relevant hashtags to increase visibility.',
                style: TextStyle(height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            // color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              // color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCarouselItem(MarketingContent item) {
    switch (item.type) {
      case MarketingContentType.profileCard:
        return LayoutBuilder(
          builder: (context, constraints) {
            final bool isSmallScreen = constraints.maxWidth < 400;
            final double spacing = isSmallScreen ? 4.0 : 8.0;

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            
             
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row with profile image, name, and rating
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Image
                        Container(
                          width: isSmallScreen ? 56 : 64,
                          height: isSmallScreen ? 56 : 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 0.2),
                           
                          ),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              item.profileUrl ?? '',
                            ),
                            radius: isSmallScreen ? 28 : 32,
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 12 : 16),

                        // Name and Rating
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name
                              Text(
                                item.name ?? 'Unknown',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isSmallScreen ? 15 : 16,
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 4 : 6),

                              // Rating
                              Row(
                                children: [
                                  Wrap(
                                    children: List.generate(5, (index) {
                                      return Icon(
                                        index < (item.rating ?? 0)
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.amber,
                                        size: isSmallScreen ? 16 : 18,
                                      );
                                    }),
                                  ),
                                  SizedBox(width: isSmallScreen ? 4 : 6),
                                  Text(
                                    '${item.rating ?? 0}/5',
                                    style: TextStyle(
                                    
                                      fontSize: isSmallScreen ? 11 : 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Description (below row)
                    if (item.description != null) ...[
                      SizedBox(height: isSmallScreen ? 8 : 12),
                      Text(
                        item.description!,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 13 : 14,
                        
                          height: 1.4,
                        ),
                      ),
                    ],

                    // Badges (below description)
                    if (item.badges != null && item.badges!.isNotEmpty) ...[
                      SizedBox(height: isSmallScreen ? 8 : 12),
                      _buildResponsiveBadges(
                        item.badges!,
                        context,
                        isSmallScreen,
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );

      case MarketingContentType.textCard:
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.analytics, size: 32, color: Colors.blue),
                  const SizedBox(height: 12),
                  Text(
                    item.description ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );

      case MarketingContentType.video:
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Container(
                height: 240,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1551632811-561732d1e306?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
                    ),
                    fit: BoxFit.cover,
                    opacity: 0.7,
                  ),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.play_circle_filled,
                  size: 64,
                  color: Colors.white,
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                child: Text(
                  'Client Testimonial',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  
                  ),
                ),
              ),
            ],
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  // Helper method to build responsive badges
  Widget _buildResponsiveBadges(
    List<String> badges,
    BuildContext context,
    bool isSmallScreen,
  ) {
    return Wrap(
      spacing: isSmallScreen ? 4.0 : 8.0,
      runSpacing: isSmallScreen ? 4.0 : 6.0,
      children: badges.map((badge) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 8.0 : 12.0,
            vertical: isSmallScreen ? 4.0 : 6.0,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            badge,
            style: TextStyle(
              fontSize: isSmallScreen ? 11 : 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.inversePrimary
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _marketingCenter() {
    return Column(
      children: [
        // Scrollable horizontal ChoiceChips
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(marketingCategories.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(marketingCategories[index]),
                    
                    selected: _selectedCategoryIndex == index,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                    },
            
                    selectedColor: Theme.of(context).colorScheme.primary,
                    labelStyle: TextStyle(
                      color: _selectedCategoryIndex == index
                          ? Colors.white
                          : Theme.of(context).primaryColorDark,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),

        // Category content below - Removed Expanded and used Flexible with fit: FlexFit.loose
        Flexible(
          fit: FlexFit.loose,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _buildCategoryContent(),
          ),
        ),
      ],
    );
  }


  Widget _buildCategoryContent() {
    switch (_selectedCategoryIndex) {
      case 0:
        return GetMoreLeadsContent();
      case 1:
        return ProfileVisibility();
      case 2:
        return CustomerRetention();
      case 3:
        return Guarantee();
      default:
        return GetMoreLeadsContent();
    }
  }
}