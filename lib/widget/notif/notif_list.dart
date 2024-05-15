import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pmobv2/models/notif.dart';
import 'package:pmobv2/widget/notif/notif_card.dart';

// ignore: must_be_immutable
class NotifList extends StatelessWidget {
  NotifList({super.key, required this.notifList});
  List<QueryDocumentSnapshot<Map<String, dynamic>>> notifList;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: notifList.length,
      itemBuilder: (context, index) {
        return NotifCard(
          notif: Notif(
            id: notifList[index].id,
            title: notifList[index]['title'],
            content: notifList[index]['content'],
            date: DateTime.parse(notifList[index]['date_added']),
            imageUrl: notifList[index]['image_url'],
          ),
        );
      },
    );
  }
}
