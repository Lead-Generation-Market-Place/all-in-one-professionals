import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/core/constants/app_colors.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/controllers/profile_provider.dart';

class PhotosVideos extends StatefulWidget {
  const PhotosVideos({super.key});

  @override
  State<PhotosVideos> createState() => _PhotosVideosState();
}

class _PhotosVideosState extends State<PhotosVideos> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).fetchUserImages();
    });
  }

  bool isSetupFinished = false;
  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSuggestions(),
                    const SizedBox(height: 12),
                    _buildPhotoGrid(profileProvider),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          const Text(
            'Photos & Videos',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Photo suggestions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _buildSuggestionItem(
            Icons.compare_arrows,
            'Your work (before and after)',
          ),
          _buildSuggestionItem(Icons.person_outline, 'You on the job'),
          _buildSuggestionItem(Icons.work_outline, 'Equipment or workspace'),
          _buildSuggestionItem(Icons.people_outline, 'Team or co-workers'),
          const SizedBox(height: 16),
          const Text(
            'Press and hold photos to drag and rearrange.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(fontSize: 15, color: Colors.grey[800])),
        ],
      ),
    );
  }

  Widget _buildPhotoGrid(ProfileProvider provider) {
    final images = provider.userImageUrls;
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: images.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildAddPhotoButton(provider);
        }

        final imageUrl = images[index - 1];
        final isVideo =
            imageUrl.toLowerCase().contains('.mp4') ||
            imageUrl.toLowerCase().contains('.mov');

        return GestureDetector(
          onTap: () {
            // Navigator.pushNamed(
            //   context,
            //   Routes.photoVideoPreviewer,
            //   arguments: {'images': images, 'initialIndex': index - 1},
            // );
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                ),
              ),
              if (isVideo)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.play_circle_outline,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddPhotoButton(ProfileProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: InkWell(
        onTap: () => _showImagePickerBottomSheet(context, provider),
        child: Center(
          child: Icon(
            Icons.add_circle_outline,
            size: 32,
            color: Colors.blue[400],
          ),
        ),
      ),
    );
  }

  void _showImagePickerBottomSheet(
    BuildContext context,
    ProfileProvider provider,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Add Photos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _showMediaTypeDialog(context, provider, ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take a Photo or Video'),
              onTap: () {
                Navigator.pop(context);
                _showMediaTypeDialog(context, provider, ImageSource.camera);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showMediaTypeDialog(
    BuildContext context,
    ProfileProvider provider,
    ImageSource source,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Select Media Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Image'),
              onTap: () {
                Navigator.pop(context);
                provider.pickMedia(source: source, isVideo: false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Video'),
              onTap: () {
                Navigator.pop(context);
                provider.pickMedia(source: source, isVideo: true);
              },
            ),
          ],
        ),
      ),
    );
  }
}
