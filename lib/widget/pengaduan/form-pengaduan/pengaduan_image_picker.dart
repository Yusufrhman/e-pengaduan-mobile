import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pmobv2/main.dart';

// ignore: must_be_immutable
class PengaduanImagePicker extends StatefulWidget {
  PengaduanImagePicker(
      {super.key,
      required this.onSelectImage,
      this.currentImage,
      required this.isError});
  final void Function(File image) onSelectImage;
  File? currentImage;
  final bool isError;

  @override
  State<PengaduanImagePicker> createState() => _PengaduanImagePickerState();
}

class _PengaduanImagePickerState extends State<PengaduanImagePicker> {
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
    Widget _content = Container(
      color: widget.isError
          ? const Color.fromARGB(255, 255, 158, 151)
          : Colors.transparent,
      child: Row(
        children: [
          Icon(
            Icons.photo,
            size: 32,
            color: kColorScheme.primary,
          ),
          const Text("Pilih Gambar")
        ],
      ),
    );
    if (widget.currentImage != null) {
      _content = Image.network(widget.currentImage!.path);
    }
    if (_selectedImage != null) {
      _content = Image.file(_selectedImage!);
    }

    return GestureDetector(onTap: _pickImage, child: _content);
  }
}
