import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pmobv2/main.dart';
import 'package:pmobv2/widget/auth/login.dart';

final _firebase = FirebaseAuth.instance;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  bool _isLoading = false;
  void _openAddAuthOverlay(BuildContext context, Widget navigate) {
    Navigator.pop(context);
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => navigate,
    );
  }

  var _enteredEmail = '';
  var _enteredName = '';

  var _enteredPassword = '';

  final _form = GlobalKey<FormState>();
  void _submit() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail, password: _enteredPassword);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredentials.user!.uid)
          .set(
        {
          'name': _enteredName,
          'email': _enteredEmail,
          'phone': '',
          'address': '',
          'image_url': '',
          'isAdmin': false,
          "unread_notif": []
        },
      );
      if (!mounted) {
        return;
      }
      Navigator.pop(context);
      setState(() {
        _isLoading = false;
      });
    } on FirebaseAuthException catch (error) {
      setState(() {
        _isLoading = false;
      });
      print(error);
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Authentication failed!"),
            content: const Text("Please sake sure a valid input entered"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: const Text("ok"))
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(context) {
    Widget _content = Row(
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
            borderRadius: BorderRadius.circular(100),
          ),
          child: TextButton(
            onPressed: _submit,
            child: Text(
              "Daftar",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: kColorScheme.primary),
            ),
          ),
        ),
      ],
    );
    if (_isLoading) {
      _content = const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            top: 32,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Daftar",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: kColorScheme.primary,
                      fontSize: 36,
                    ),
              ),
              const SizedBox(
                height: 18,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nama",
                        style: TextStyle(
                          fontSize: 16,
                          color: kColorScheme.onPrimaryContainer,
                        ),
                      ),
                      TextFormField(
                        style:
                            TextStyle(color: kColorScheme.primary, height: 2),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: kColorScheme.secondaryContainer,
                          hintText: 'Masukkan Nama Lengkap',
                          prefixIcon: const Icon(Icons.person_2_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Masukkan Nama dengan benar!";
                          }
                          return null;
                        },
                        onSaved: (newValue) => _enteredName = newValue!,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 16,
                          color: kColorScheme.onPrimaryContainer,
                        ),
                      ),
                      TextFormField(
                        style:
                            TextStyle(color: kColorScheme.primary, height: 2),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: kColorScheme.secondaryContainer,
                          hintText: 'Masukkan Email',
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              !value.contains("@")) {
                            return "Masukkan email dengan benar!";
                          }
                          return null;
                        },
                        onSaved: (value) => _enteredEmail = value!,
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
                        "Kata Sandi",
                        style: TextStyle(
                          fontSize: 16,
                          color: kColorScheme.onPrimaryContainer,
                        ),
                      ),
                      TextFormField(
                        obscureText: !_showPassword,
                        style:
                            TextStyle(color: kColorScheme.primary, height: 2),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: kColorScheme.secondaryContainer,
                          hintText: 'Masukkan Kata Sandi',
                          prefixIcon: Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(_showPassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().length < 6) {
                            return "Kata sandi harus minimal 6 karakter!";
                          }
                          _enteredPassword = value;
                          return null;
                        },
                        onSaved: (value) => _enteredPassword = value!,
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
                        "Konfirmasi Kata Sandi",
                        style: TextStyle(
                          fontSize: 16,
                          color: kColorScheme.onPrimaryContainer,
                        ),
                      ),
                      TextFormField(
                        obscureText: !_showConfirmPassword,
                        style:
                            TextStyle(color: kColorScheme.primary, height: 2),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: kColorScheme.secondaryContainer,
                          hintText: 'Masukkan Ulang Kata Sandi',
                          prefixIcon: Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(_showConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _showConfirmPassword = !_showConfirmPassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value != _enteredPassword) {
                            return "Kata Sandi tidak cocok!";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  _openAddAuthOverlay(context, LoginScreen());
                },
                child: const Text("Sudah Punya Akun? Masuk"),
              ),
              const SizedBox(
                height: 8,
              ),
              _content,
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
