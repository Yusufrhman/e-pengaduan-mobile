import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pmobv2/main.dart';
import 'package:pmobv2/providers/user_provider.dart';

class ProfileImagePicker extends ConsumerStatefulWidget {
  const ProfileImagePicker({super.key, required this.onSelectImage});
  final void Function(File image) onSelectImage;

  @override
  ConsumerState<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends ConsumerState<ProfileImagePicker> {
  File? _selectedImage;
  void _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selectedImage = File(pickedImage.path);
    });
    widget.onSelectImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    final _userData = ref.watch(userProvider);
    Widget _profileImage = Image.network(
      _userData['image_url']!,
      fit: BoxFit.cover,
    );
    if (_userData['image_url'] == "" || _userData['image_url']!.trim() == "") {
      _profileImage = Image.asset(
        'assets/images/profile.jpeg',
        fit: BoxFit.cover,
      );
    }

    if (_selectedImage != null) {
      if (kIsWeb) {
        _profileImage = Image.network(_selectedImage!.path, fit: BoxFit.cover);
      } else {
        _profileImage = Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
        );
      }
    }
    return Center(
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.height * 0.15,
            height: MediaQuery.of(context).size.height * 0.15,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(100), child: _profileImage),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.height * 0.05,
              height: MediaQuery.of(context).size.height * 0.05,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: kColorScheme.primary,
              ),
              child: IconButton(
                onPressed: _pickImage,
                icon: const Icon(
                  Icons.camera_alt,
                  size: 18.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
