import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pmobv2/main.dart';
import 'package:pmobv2/widget/auth_screen.dart';
import 'package:pmobv2/widget/epengaduan.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: Column(
          children: [
            Lottie.asset("assets/lottie/splash.json"),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "E-Pengaduan",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      splashTransition: SplashTransition.sizeTransition,
      pageTransitionType: PageTransitionType.bottomToTop,
      splashIconSize: 270,
      nextScreen: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const EPengaduan();
          } else {
            return const AuthScreen();
          }
        },
      ),
      backgroundColor: kColorScheme.primary,
      duration: 1100,
    );
  }
}
