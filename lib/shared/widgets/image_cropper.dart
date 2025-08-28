import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageCropperScreen extends StatefulWidget {
  final File imageFile;

  const ImageCropperScreen({super.key, required this.imageFile});

  @override
  State<ImageCropperScreen> createState() => _ImageCropperScreenState();
}

class _ImageCropperScreenState extends State<ImageCropperScreen> {
  bool isCropping = false;

  Color? _toolbarColor;
  Color? _toolbarWidgetColor;

  @override
  void initState() {
    super.initState();

    // Defer cropping until after the widget has been laid out
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startCropping();
    });
  }

  Future<void> _startCropping() async {
    // Read Theme safely here AFTER the widget is built
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    setState(() {
      isCropping = true;
    });

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: widget.imageFile.path,
      aspectRatio: const CropAspectRatio(
        ratioX: 1,
        ratioY: 1,
      ), // enforce square crop
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: colorScheme.primary,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true,
          cropStyle: CropStyle.circle, //  Add circular overlay on Android
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioLockEnabled: true,
          cropStyle: CropStyle.circle, //  Add circular overlay on iOS
        ),
      ],
    );


    setState(() {
      isCropping = false;
    });

    if (!mounted) return;

    if (croppedFile != null) {
      Navigator.pop(context, File(croppedFile.path)); // Return cropped image
    } else {
      Navigator.pop(context, null); // Return null if cancelled
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isCropping
            ? const CircularProgressIndicator()
            : const Text('Image cropping cancelled'),
      ),
    );
  }
}
