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
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 2,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/images/auth_background3.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _openAddAuthOverlay(context, const LoginScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kColorScheme.primaryContainer,
                        foregroundColor: kColorScheme.primary,
                        fixedSize: Size(MediaQuery.of(context).size.width, 50),
                      ),
                      child: Text(
                        "Masuk",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: kColorScheme.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.w900),
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
                        backgroundColor:
                            kColorScheme.primaryContainer.withOpacity(0.3),
                        foregroundColor: kColorScheme.background,
                        fixedSize: Size(MediaQuery.of(context).size.width, 50),
                      ),
                      child: Text(
                        "Daftar",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: kColorScheme.background,
                            fontSize: 18,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
