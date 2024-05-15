import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pmobv2/main.dart';
import 'package:pmobv2/widget/notif/notif_screen.dart';

class NotifButton extends StatelessWidget {
  const NotifButton({super.key});

  @override
  Widget build(context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: kColorScheme.secondaryContainer,
      ),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Badge(
              label: Text(
                  snapshot.data!.data()!['unread_notif'].length.toString()),
              child: IconButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({'unread_notif': []});
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NotifScreen(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.notifications_outlined,
                  size: 32,
                  color: kColorScheme.primary,
                ),
              ),
            );
          }),
    );
  }
}
