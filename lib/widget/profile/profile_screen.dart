import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmobv2/main.dart';
import 'package:pmobv2/providers/user_provider.dart';
import 'package:pmobv2/widget/notif/notif_screen.dart';
import 'package:pmobv2/widget/profile/profile_button.dart';
import 'package:pmobv2/widget/profile/update_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;
final user = _firebase.currentUser!;

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late int _totalPengaduan;
  late int _totalPengaduanSelesai;

  bool _isLoadingPengaduan = true;

  void _loadPengaduanUser() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    Future<QuerySnapshot> pengaduanSelesai = FirebaseFirestore.instance
        .collection('pengaduan')
        .where('userId', isEqualTo: uid)
        .where('status', isEqualTo: 'selesai')
        .get();

    Future<QuerySnapshot> pengaduanUser = FirebaseFirestore.instance
        .collection('pengaduan')
        .where('userId', isEqualTo: uid)
        .get();

    List<QuerySnapshot> results =
        await Future.wait([pengaduanSelesai, pengaduanUser]);

    _totalPengaduanSelesai = results[0].docs.length;
    _totalPengaduan = results[1].docs.length;
    setState(() {
      _isLoadingPengaduan = false;
    });
  }

  void _showChangePassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Change Your Password?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'We will send the password change link to your email',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(kColorScheme.primary),
              padding: MaterialStateProperty.all(EdgeInsets.all(0)),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          Ink(
            child: TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(kColorScheme.primaryContainer),
                foregroundColor:
                    MaterialStateProperty.all(kColorScheme.primary),
                padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
              ),
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.sendPasswordResetEmail(
                    email: FirebaseAuth.instance.currentUser!.email!,
                  );

                  if (!mounted) return;

                  Navigator.pop(context);

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        'Success',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      content: Text(
                        'We have sent the password change link to your email',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      actions: [
                        Ink(
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  kColorScheme.primaryContainer),
                              foregroundColor: MaterialStateProperty.all(
                                  kColorScheme.primary),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(0)),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Ok"),
                          ),
                        ),
                      ],
                    ),
                  );
                } catch (e) {
                  Navigator.pop(context);

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        'Error',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      content: Text(
                        'An error occurred while sending the password reset email. Please try again.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      actions: [
                        Ink(
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  kColorScheme.primaryContainer),
                              foregroundColor: MaterialStateProperty.all(
                                  kColorScheme.primary),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(0)),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Ok"),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text("Send"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    _loadPengaduanUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              _userData['isAdmin']
                  ? const SizedBox()
                  : Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: kColorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _isLoadingPengaduan
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _totalPengaduan.toString(),
                                      style: TextStyle(
                                        color: kColorScheme.primary,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Total Pengaduan',
                                      style: TextStyle(
                                        color: kColorScheme.primary,
                                        fontSize: 12,
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
                                      _totalPengaduanSelesai.toString(),
                                      style: TextStyle(
                                        color: kColorScheme.primary,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Pengaduan Selesai',
                                      style: TextStyle(
                                        color: kColorScheme.primary,
                                        fontSize: 12,
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
              const SizedBox(
                height: 10,
              ),
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
                onPress: () {
                  _showChangePassword();
                },
              ),
              _userData['isAdmin']
                  ? const SizedBox()
                  : ProfileButton(
                      title: "Notification",
                      icon: Icons.notifications,
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NotifScreen()));
                      },
                    ),
              const SizedBox(
                height: 48,
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
