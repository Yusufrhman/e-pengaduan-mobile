import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pmobv2/admin/admin_menu.dart';
import 'package:pmobv2/models/pengguna.dart';
import 'package:pmobv2/widget/auth/auth_screen.dart';
import 'package:pmobv2/widget/epengaduan.dart';

class LoginChecker extends StatelessWidget {
  const LoginChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(snapshot.data!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final currentuser = snapshot.data!.data()!;
                  Pengguna user = Pengguna(
                      id: snapshot.data!.id,
                      name: currentuser['name'],
                      email: currentuser['email'],
                      phone: currentuser['phone'],
                      address: currentuser['address'],
                      imageUrl: currentuser['image_url']);

                  if (currentuser['isAdmin'] == true) {
                    return AdminMenu(
                      user: user,
                    );
                  }
                  return EPengaduan(
                    user: user,
                  );
                });
          }
          return const AuthScreen();
        });
  }
}
