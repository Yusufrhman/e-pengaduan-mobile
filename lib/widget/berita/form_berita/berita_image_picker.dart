import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pmobv2/main.dart';

class BeritaImagePicker extends StatefulWidget {
  BeritaImagePicker(
      {super.key, required this.onSelectImage, required this.isError});
  final void Function(File image) onSelectImage;
  final bool isError;

  @override
  State<BeritaImagePicker> createState() => _BeritaImagePickerState();
}

class _BeritaImagePickerState extends State<BeritaImagePicker> {
  File? _selectedImage;
  void _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery, maxWidth: 600);
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
    Widget _content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.photo,
          size: 32,
          color: kColorScheme.primary,
        ),
        const Text("Pilih Gambar")
      ],
    );

    if (_selectedImage != null) {
      _content = Image.file(_selectedImage!);
    }

    return Ink(
      color: widget.isError
          ? const Color.fromARGB(255, 255, 158, 151)
          : kColorScheme.secondaryContainer,
      child: InkWell(
        onTap: _pickImage,
        child: SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: _content),
      ),
    );
  }
}
