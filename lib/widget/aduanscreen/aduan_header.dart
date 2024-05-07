import 'package:flutter/material.dart';
import 'package:pmobv2/widget/button/notif_button.dart';

class AduanHeader extends StatelessWidget {
  const AduanHeader({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Pengaduan Saya",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const NotifButton()
        ],
      ),
    );
  }
}
