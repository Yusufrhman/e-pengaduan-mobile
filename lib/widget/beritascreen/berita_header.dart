import 'package:flutter/material.dart';
import 'package:pmobv2/widget/button/notif_button.dart';

class BeritaHeader extends StatelessWidget {
  const BeritaHeader({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Berita",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const NotifButton()
        ],
      ),
    );
  }
}
