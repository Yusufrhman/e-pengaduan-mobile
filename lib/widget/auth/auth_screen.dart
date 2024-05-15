import 'package:flutter/material.dart';
import 'package:pmobv2/main.dart';
import 'package:pmobv2/widget/auth/login.dart';
import 'package:pmobv2/widget/auth/signup.dart';

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
      backgroundColor: kColorScheme.primary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _openAddAuthOverlay(context, const LoginScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kColorScheme.primaryContainer,
                      foregroundColor:
                          kColorScheme.primary, // Warna teks button
                    ).copyWith(
                        fixedSize: MaterialStateProperty.all(
                            Size.fromWidth(MediaQuery.of(context).size.width))),
                    child: Text(
                      "Masuk",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: kColorScheme.primary, fontSize: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _openAddAuthOverlay(context, const SignUpScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kColorScheme.primaryContainer,
                      foregroundColor: kColorScheme.primary,
                    ).copyWith(
                        fixedSize: MaterialStateProperty.all(
                            Size.fromWidth(MediaQuery.of(context).size.width))),
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
      ),
    );
  }
}
