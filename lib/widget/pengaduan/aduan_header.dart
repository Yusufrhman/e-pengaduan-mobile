import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmobv2/providers/user_provider.dart';
import 'package:pmobv2/widget/button/notif_button.dart';

class AduanHeader extends ConsumerStatefulWidget {
  const AduanHeader({super.key});

  @override
  ConsumerState<AduanHeader> createState() => _AduanHeaderState();
}

class _AduanHeaderState extends ConsumerState<AduanHeader> {
  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userProvider);
    bool isAdmin = userData['isAdmin'];
    return Padding(
      padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isAdmin
              ? Text(
                  "List Pengaduan User",
                  style: Theme.of(context).textTheme.titleLarge,
                )
              : Text(
                  "Pengaduan Saya",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
          isAdmin ? const SizedBox() : const NotifButton()
        ],
      ),
    );
  }
}
