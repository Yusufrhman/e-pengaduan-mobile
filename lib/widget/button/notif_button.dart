import 'package:flutter/material.dart';
import 'package:pmobv2/main.dart';
import 'package:pmobv2/widget/notif_screen.dart';

class NotifButton extends StatelessWidget {
  const NotifButton({super.key});

  @override
  Widget build(context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: kColorScheme.secondaryContainer,
      ),
      child: Badge(
        label: Text('99'),
        child: IconButton(
          onPressed: () {
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
      ),
    );
  }
}
