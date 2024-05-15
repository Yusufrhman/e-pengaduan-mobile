import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pmobv2/main.dart';
import 'package:pmobv2/widget/berita/form_berita/berita_image_picker.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class FormBeritaScreen extends StatefulWidget {
  const FormBeritaScreen({super.key});

  @override
  State<FormBeritaScreen> createState() => _FormBeritaScreenState();
}

class _FormBeritaScreenState extends State<FormBeritaScreen> {
  File? selectedImage;
  bool _isNoImage = false;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool? _isUpdating;
  @override
  String _title = '';
  String _description = '';

  void _saveBerita() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (selectedImage == null) {
      setState(() {
        _isNoImage = true;
      });
      return;
    }
    setState(() {
      _isNoImage = false;
    });
    _formKey.currentState!.save();
    final beritaId = uuid.v4();
    var _currentDate = DateTime.now().toString();
    setState(() {
      _isLoading = true;
    });
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('berita_images')
          .child("${beritaId}.jpg");
      await storageRef.putFile(selectedImage!);
      final _imageUrl = await storageRef.getDownloadURL();
      await FirebaseFirestore.instance.collection('berita').doc(beritaId).set({
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'title': _title,
        'description': _description,
        'date_added': _currentDate,
        'image_url': _imageUrl
      });
      setState(() {
        _isLoading = false;
      });
    } on FirebaseException catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("failed")),
      );
    }
    if (!mounted) {
      return;
    }
    Navigator.pop(context);
    setState(() {
      _isLoading = false;
    });
  }

  void _updateBerita() async {}

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 16),
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Text("Tambahkan Berita",
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(
                  height: 18,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Judul",
                            style: TextStyle(
                                fontSize: 16,
                                color: kColorScheme.onPrimaryContainer),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.trim() == '') {
                                return 'judul tidak boleh kosong';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _title = newValue!;
                            },
                            style: TextStyle(color: kColorScheme.primary),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Masukkan judul',
                                filled: true,
                                fillColor: kColorScheme.secondaryContainer),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Deskripsi",
                            style: TextStyle(
                                fontSize: 16,
                                color: kColorScheme.onPrimaryContainer),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.trim() == '') {
                                return 'deskripsi tidak boleh kosong';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _description = newValue!;
                            },
                            style: TextStyle(color: kColorScheme.primary),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Masukkan Deskripsi',
                                filled: true,
                                fillColor: kColorScheme.secondaryContainer),
                            maxLines: 7,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      BeritaImagePicker(
                          onSelectImage: (image) {
                            selectedImage = image;
                          },
                          isError: _isNoImage)
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Batal"),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: kColorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(100)),
                      child: TextButton(
                        onPressed: _saveBerita,
                        child: const Text("Tambahkan"),
                      ),
                    ),
                  ],
                )
              ],
            ),
    );
  }
}
