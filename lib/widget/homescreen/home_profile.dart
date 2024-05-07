import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmobv2/main.dart';
import 'package:pmobv2/providers/user_provider.dart';
import 'package:pmobv2/widget/button/notif_button.dart';

class HomeProfile extends ConsumerWidget {
  const HomeProfile({super.key, required this.name});
  final String name;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _userData = ref.watch(userProvider);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child:
                  _userData['image_url'] == null || _userData['image_url'] == ''
                      ? const Image(
                          width: 50,
                          height: 50,
                          image: AssetImage('assets/images/profile.jpeg'),
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          width: 50,
                          height: 50,
                          _userData['image_url']!,
                          fit: BoxFit.cover),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome Back,",
                  style: TextStyle(
                      color: Color.fromARGB(255, 136, 136, 136), fontSize: 15),
                ),
                SizedBox(
                  width: 200,
                  child: Text(
                    _userData['name']!,
                    style: TextStyle(fontSize: 16, color: kColorScheme.primary),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const NotifButton()
        ],
      ),
    );
  }
}
