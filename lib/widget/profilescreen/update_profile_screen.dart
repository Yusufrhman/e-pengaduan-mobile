import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmobv2/main.dart';
import 'package:pmobv2/providers/user_provider.dart';
import 'package:pmobv2/widget/profilescreen/profile_image_picker.dart';

class UpdateProfileScreen extends ConsumerStatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  ConsumerState<UpdateProfileScreen> createState() =>
      _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends ConsumerState<UpdateProfileScreen> {
  String? _enteredName, _enteredPhone, _enteredAddress;
  File? _selectedImage;
  bool _isLoading = false;

  final _form = GlobalKey<FormState>();
  void _updateProfile() async {
    final _isValid = _form.currentState!.validate();

    if (!_isValid || _selectedImage == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 2),
        content: const Text("Update failed"),
        action: SnackBarAction(
            label: "ok",
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();
            }),
      ));
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    final _userData = ref.watch(userProvider);

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('user_images')
        .child("${_userData['id']}.jpg");
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': _selectedImage!.path},
    );
    if (kIsWeb) {
      await storageRef.putData(await _selectedImage!.readAsBytes(), metadata);
    } else {
      await storageRef.putFile(_selectedImage!, metadata);
    }
    final _imageUrl = await storageRef.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(_userData['id'])
        .update({
      'name': _enteredName,
      'phone': _enteredPhone,
      'address': _enteredAddress,
      'image_url': _imageUrl,
    });

    ref.watch(userProvider.notifier).setUser(
        id: _userData['id']!,
        name: _enteredName!,
        email: _userData['email']!,
        phone: _enteredPhone,
        address: _enteredAddress,
        imageUrl: _imageUrl);
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      content: const Text("Update Success!"),
      action: SnackBarAction(
          label: "ok",
          onPressed: () {
            ScaffoldMessenger.of(context).clearSnackBars();
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final _userData = ref.watch(userProvider);
    Widget content = ElevatedButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size(double.infinity, 50)),
      ),
      onPressed: _updateProfile,
      child: Text(
        "Update Profile",
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: kColorScheme.primary),
      ),
    );
    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: kColorScheme.primary),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            ProfileImagePicker(onSelectImage: (image) {
              _selectedImage = image;
            }),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 16,
                        color: kColorScheme.onPrimaryContainer,
                      ),
                    ),
                    TextFormField(
                      initialValue: _userData['email'],
                      readOnly: true,
                      style: TextStyle(color: kColorScheme.primary),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: kColorScheme.secondaryContainer,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Nama",
                      style: TextStyle(
                        fontSize: 16,
                        color: kColorScheme.onPrimaryContainer,
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.trim().length < 1) {
                          return "Masukkan nama dengan benar!";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _enteredName = newValue;
                      },
                      initialValue: _userData['name'],
                      style: TextStyle(color: kColorScheme.primary),
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.edit_outlined),
                        prefixIcon: const Icon(Icons.person_2_outlined),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: kColorScheme.secondaryContainer,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "No HP",
                      style: TextStyle(
                        fontSize: 16,
                        color: kColorScheme.onPrimaryContainer,
                      ),
                    ),
                    TextFormField(
                      onSaved: (newValue) {
                        _enteredPhone = newValue;
                      },
                      initialValue: _userData['phone'],
                      style: TextStyle(color: kColorScheme.primary),
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.edit_outlined),
                        prefixIcon: const Icon(Icons.phone_android_outlined),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: kColorScheme.secondaryContainer,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Alamat",
                      style: TextStyle(
                          fontSize: 16, color: kColorScheme.onPrimaryContainer),
                    ),
                    TextFormField(
                      onSaved: (newValue) {
                        _enteredAddress = newValue;
                      },
                      initialValue: _userData['address'],
                      style: TextStyle(color: kColorScheme.primary),
                      decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.edit_outlined),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: kColorScheme.secondaryContainer),
                      maxLines: 3,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    content
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
