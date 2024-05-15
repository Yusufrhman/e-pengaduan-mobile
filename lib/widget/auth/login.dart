import 'package:flutter/material.dart';
import 'package:pmobv2/main.dart';
import 'package:pmobv2/widget/auth/login_checker.dart';
import 'package:pmobv2/widget/auth/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showPassword = false;

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
      await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail, password: _enteredPassword);
      if (!mounted) {
        return;
      }
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginChecker()));
      setState(() {
        _isLoading = false;
      });
    } on FirebaseAuthException catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Authentication failed!"),
            content: const Text("Please make sure a valid input entered"),
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
            Navigator.of(context).pop();
          },
          child: const Text("Batal"),
        ),
        Container(
          decoration: BoxDecoration(
            color: kColorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(100),
          ),
          child: TextButton(
            onPressed: () {
              _submit();
              // Navigator.pop(context);
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => const EPengaduan()),
              // );
            },
            child: Text(
              "Login",
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

    return Padding(
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
              "Masuk",
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
                      "Email",
                      style: TextStyle(
                        fontSize: 16,
                        color: kColorScheme.onPrimaryContainer,
                      ),
                    ),
                    TextFormField(
                      style: TextStyle(color: kColorScheme.primary),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Masukkan Email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: kColorScheme.secondaryContainer,
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            !value.contains("@")) {
                          return "Please enter a valid email address!";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredEmail = value!;
                      },
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
                      obscureText:
                          !_showPassword, // Mengatur apakah teks tersembunyi atau terlihat
                      style: TextStyle(color: kColorScheme.primary),
                      decoration: InputDecoration(
                          hintText: 'Masukkan Kata Sandi',
                          prefixIcon: const Icon(Icons.lock_outline),
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
                          border: InputBorder.none,
                          filled: true,
                          fillColor: kColorScheme.secondaryContainer),
                      validator: (value) {
                        if (value == null || value.trim().length < 6) {
                          return "Password must be atleast 6 characters!";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredPassword = value!;
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
                _openAddAuthOverlay(context, const SignUpScreen());
              },
              child: const Text("Belum Punya Akun? Daftar disini"),
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
    );
  }
}
