import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmobv2/main.dart';
import 'package:pmobv2/models/pengaduan.dart';
import 'package:pmobv2/providers/user_provider.dart';
import 'package:pmobv2/widget/aduan_screen.dart';
import 'package:pmobv2/widget/berita_screen.dart';
import 'package:pmobv2/widget/form-pengaduan/form_screen.dart';
import 'package:pmobv2/widget/home_screen.dart';
import 'package:pmobv2/widget/profile_screen.dart';

class EPengaduan extends ConsumerStatefulWidget {
  const EPengaduan({super.key});
  @override
  ConsumerState<EPengaduan> createState() => _EPengaduanState();
}

class _EPengaduanState extends ConsumerState<EPengaduan> {
  int _currentIndex = 0;
  List<Widget> screen = [];
  var _isLoading = true;

  @override
  void initState() {
    _loadUserData();
    super.initState();

    screen = [
      HomeScreen(
        onTapFitur: _openAddFormOverlay,
      ),
      BeritaScreen(),
      const Center(
        child: Icon(Icons.access_alarm),
      ),
      AduanScreen(),
      const ProfileScreen()
    ];
  }

  void _loadUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .get();
    setState(() {
      _isLoading = false;
    });
    ref.watch(userProvider.notifier).setUser(
          id: currentUser.uid,
          name: userData.data()!['name'],
          email: userData.data()!['email'],
          phone: userData.data()!['phone'],
          address: userData.data()!['address'],
          imageUrl: userData.data()!['image_url'],
        );
  }

  changeScreen(int i) {
    setState(() {
      _currentIndex = i;
    });
  }

  void _openAddFormOverlay(Category category) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => FormScreen(
        selectedCategory: category,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (!_isLoading) {
      content = screen[_currentIndex];
    } else {
      content = Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      backgroundColor: kColorScheme.background,
      body: content,
      bottomNavigationBar: ConvexAppBar(
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        style: TabStyle.fixedCircle,
        height: 60,
        items: const [
          TabItem(icon: Icons.home, title: 'Beranda'),
          TabItem(icon: Icons.newspaper, title: 'Berita'),
          TabItem(icon: Icons.add),
          TabItem(icon: Icons.report, title: 'Aduan'),
          TabItem(icon: Icons.people, title: 'Profil'),
        ],
        onTap: (int i) {
          if (i == 2) {
            setState(() {
              _openAddFormOverlay(Category.keamanan);
            });
          } else {
            setState(() {
              _currentIndex = i;
            });
          }
        },
      ),
    );
  }
}
