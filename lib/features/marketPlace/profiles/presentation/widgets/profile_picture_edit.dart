import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/core/constants/app_colors.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/controllers/profile_provider.dart';
import 'package:yelpax_pro/shared/widgets/custom_input.dart';

class ProfilePictureEdit extends StatelessWidget {
  ProfilePictureEdit({super.key});
  final formKeyEditProfilePicture = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Basic info',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Profile Image with Edit Icon
              Container(
                width: 180,
                height: 180,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Selector<ProfileProvider, String>(
                      selector: (_, provider) => provider.businessImageUrl,
                      builder: (context, imageUrl, child) {
                        return Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.black,
                              width: 2,
                            ),
                          ),
                          child: imageUrl.isNotEmpty
                              ? ClipOval(
                                  child: Image.file(
                                    File(imageUrl),
                                    width: 180,
                                    height: 180,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            _buildPlaceholder(context),
                                  ),
                                )
                              : _buildPlaceholder(context),
                        );
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        profileProvider.showImagePickerBottomSheet(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Change Photo Button
              TextButton(
                onPressed: () {
                  profileProvider.showImagePickerBottomSheet(context);
                },
                child: const Text(
                  'Change photo',
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Examples and Tips Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Examples and Tips Header
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Colors.grey[700],
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Examples and tips',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // In your ProfilePictureEdit widget, replace the SizedBox with:
                    SizedBox(
                      height: 70,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 6,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 16),
                        itemBuilder: (context, index) => Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/${index + 1}.jpg',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Tips List
                    _buildTip('Make sure to smile.'),
                    _buildTip('Take photo in daylight. No flash.'),
                    _buildTip('Use a solid background.'),
                    _buildTip('Hold camera slightly higher than eye level.'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Business Name Section
              Form(
                key: formKeyEditProfilePicture,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomInputField(
                      label: 'Business Name',
                      hintText: 'Enter your business name',
                      controller: profileProvider.businessNameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your business name.';
                        } else if (value.length > 50) {
                          return 'Maximum 50 characters allowed.';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        profileProvider.onBusinessNameChanged(value);
                        formKeyEditProfilePicture.currentState?.validate();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      // color: Colors.grey[300],
      // child: const Icon(Icons.image, size: 10, color: Colors.white),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Text('•', style: TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }


  Widget _buildProfileCompletionBanner() {
    return Container(
      color: AppColors.black,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wrap the Text with Flexible to allow wrapping
          Flexible(
            child:
                // Replace your static Text widget with:
                Selector<ProfileProvider, int>(
                  selector: (_, provider) => provider.stepNumber,
                  builder: (context, stepnumber, child) {
                    return Text(
                      'Only $stepnumber setup tasks left before you can start getting leads.',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      softWrap: true,
                      maxLines: 2, // Optional: limit to 2 lines
                      overflow: TextOverflow
                          .ellipsis, // Optional: fade or ellipsis if too long
                    );
                  },
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
}
