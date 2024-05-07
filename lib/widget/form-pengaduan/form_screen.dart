import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pmobv2/main.dart';
import 'package:pmobv2/models/pengaduan.dart';
import 'package:pmobv2/widget/form-pengaduan/pengaduan_image_picker.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class FormScreen extends StatefulWidget {
  const FormScreen({required this.selectedCategory, super.key});
  final Category selectedCategory;

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  File? _selectedImage;
  bool _isNoImage = false;
  Category _selectedCategory = Category.keamanan;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
  }

  String _title = '';
  String _description = '';
  String _location = '';

  void _savePengaduan() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (_selectedImage == null) {
      setState(() {
        _isNoImage = true;
      });
      return;
    }
    _formKey.currentState!.save();

    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    setState(() {
      _isLoading = true;
    });
    final pengaduanId = uuid.v4();
    var _currentDate = DateTime.now();
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('pengaduan_images')
          .child("${pengaduanId}.jpg");
      await storageRef.putFile(_selectedImage!);
      final _imageUrl = await storageRef.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('pengaduan')
          .doc(pengaduanId)
          .set(
        {
          'userId': currentUserId,
          'title': _title,
          'description': _description,
          'location': _location,
          'image_url': _imageUrl,
          'category': _selectedCategory.name,
          'date_added': _currentDate
        },
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('pengaduan')
          .doc(pengaduanId)
          .set(
        {
          'title': _title,
          'description': _description,
          'location': _location,
          'image_url': _imageUrl,
          'category': _selectedCategory.name,
          'date_added': _currentDate
        },
      );
      setState(() {
        _isLoading = false;
      });
      if (!mounted) {
        return;
      }
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("failed")),
      );
      print(e);
    }
  }

  @override
  Widget build(context) {
    print(Category.keamanan.name);
    return Padding(
      padding: const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 16),
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Text("Ajukan Pengaduan",
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
                            maxLines: 3,
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
                            "Lokasi",
                            style: TextStyle(
                                fontSize: 16,
                                color: kColorScheme.onPrimaryContainer),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.trim() == '') {
                                return 'lokasi tidak boleh kosong';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _location = newValue!;
                            },
                            style: TextStyle(color: kColorScheme.primary),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Masukkan Lokasi',
                                filled: true,
                                fillColor: kColorScheme.secondaryContainer),
                            maxLines: 3,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Category",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: kColorScheme.onPrimaryContainer),
                              ),
                              Container(
                                height: 50,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: kColorScheme.secondaryContainer,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      value: _selectedCategory,
                                      items: Category.values
                                          .map(
                                            (category) => DropdownMenuItem(
                                              value: category,
                                              child: Text(category.name),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) {
                                        if (value == null) {
                                          return;
                                        }
                                        setState(
                                          () {
                                            _selectedCategory = value;
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Foto",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: kColorScheme.onPrimaryContainer),
                              ),
                              Container(
                                height: 50,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: kColorScheme.secondaryContainer,
                                ),
                                child: PengaduanImagePicker(
                                  onSelectImage: (image) {
                                    _selectedImage = image;
                                  },
                                  isError: _isNoImage,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
                        onPressed: _savePengaduan,
                        child: const Text("Ajukan Laporan"),
                      ),
                    ),
                  ],
                )
              ],
            ),
    );
  }
}
