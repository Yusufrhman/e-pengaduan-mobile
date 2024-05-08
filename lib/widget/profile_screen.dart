import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmobv2/main.dart';
import 'package:pmobv2/providers/user_provider.dart';
import 'package:pmobv2/widget/profilescreen/profile_button.dart';
import 'package:pmobv2/widget/profilescreen/update_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;
final user = _firebase.currentUser!;

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _userData = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: _userData['image_url'] == null ||
                              _userData['image_url'] == ''
                          ? const Image(
                              image: AssetImage('assets/images/profile.jpeg'),
                              fit: BoxFit.cover,
                            )
                          : Image.network(_userData['image_url']!,
                              fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userData['name']!,
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          _userData['email']!,
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),

              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: kColorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '150',
                          style: TextStyle(
                            color: kColorScheme.primary,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Poin Kontribusi',
                          style: TextStyle(
                            color: kColorScheme.primary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const VerticalDivider(
                      color: Colors.white,
                      thickness: 3,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '27',
                          style: TextStyle(
                            color: kColorScheme.primary,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Keluhan',
                          style: TextStyle(
                            color: kColorScheme.primary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),

              // Menu
              ProfileButton(
                title: "Edit Profile",
                icon: Icons.settings,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UpdateProfileScreen()),
                  );
                },
              ),
              ProfileButton(
                title: "Change Password",
                icon: Icons.password,
                onPress: () {},
              ),
              ProfileButton(
                title: "Notification",
                icon: Icons.notifications,
                onPress: () {},
              ),
              const SizedBox(
                height: 24,
              ),
              ProfileButton(
                title: "Logout",
                icon: Icons.logout,
                endIcon: false,
                textColor: Colors.red,
                onPress: () async {
                  ref.watch(userProvider.notifier).setUser(
                      id: '',
                      name: '',
                      email: '',
                      address: '',
                      phone: '',
                      imageUrl: '');
                  await _firebase.signOut();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
