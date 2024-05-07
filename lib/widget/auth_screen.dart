import 'package:flutter/material.dart';
import 'package:pmobv2/main.dart';
import 'package:pmobv2/widget/authscreen/login.dart';
import 'package:pmobv2/widget/authscreen/signup.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});
  void _openAddAuthOverlay(BuildContext context, Widget navigate) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => navigate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              kColorScheme.primary,
              kColorScheme.primary.withOpacity(0.8)
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "E-Pengaduan",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 42,
                  color: kColorScheme.background,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Adukan Keluhanmu disini!",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 16,
                    color: kColorScheme.primaryContainer,
                  ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _openAddAuthOverlay(context, const LoginScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kColorScheme.primaryContainer,
                    foregroundColor: kColorScheme.primary, // Warna teks button
                  ),
                  child: Text(
                    "Masuk",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: kColorScheme.primary, fontSize: 16),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                ElevatedButton(
                  onPressed: () {
                    _openAddAuthOverlay(context, const SignUpScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kColorScheme.primaryContainer,
                    foregroundColor: kColorScheme.primary, // Warna teks button
                  ),
                  child: Text(
                    "Daftar",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: kColorScheme.primary, fontSize: 16),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
