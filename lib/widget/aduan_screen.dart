import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pmobv2/models/pengaduan.dart';
import 'package:pmobv2/widget/aduanscreen/aduan_accordion.dart';
import 'package:pmobv2/widget/aduanscreen/aduan_header.dart';

// ignore: must_be_immutable
class AduanScreen extends StatelessWidget {
  AduanScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AduanHeader(),
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('pengaduan')
                .orderBy('date_added')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('Belum ada pengaduan, mulai mengadukan'),
                );
              }

              final pengaduanList = snapshot.data!.docs;
              return ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) {
                  return AduanAccordion(
                    pengaduanList: pengaduanList,
                  );
                },
              );
            }),
      ],
    );
  }
}
