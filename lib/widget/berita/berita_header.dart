import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmobv2/providers/user_provider.dart';
import 'package:pmobv2/widget/button/notif_button.dart';

class BeritaHeader extends ConsumerWidget {
  const BeritaHeader({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _userData = ref.watch(userProvider);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Berita",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          _userData['isAdmin'] ? const SizedBox() : const NotifButton()
        ],
      ),
    );
  }
}
