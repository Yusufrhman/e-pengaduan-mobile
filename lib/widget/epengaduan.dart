import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pmobv2/main.dart';
import 'package:pmobv2/models/pengaduan.dart';
import 'package:pmobv2/models/pengguna.dart';
import 'package:pmobv2/providers/user_provider.dart';
import 'package:pmobv2/widget/pengaduan/aduan_screen.dart';
import 'package:pmobv2/widget/berita/berita_screen.dart';
import 'package:pmobv2/widget/pengaduan/form-pengaduan/form_screen.dart';
import 'package:pmobv2/widget/home/home_screen.dart';
import 'package:pmobv2/widget/profile/profile_screen.dart';

class EPengaduan extends ConsumerStatefulWidget {
  const EPengaduan({super.key, required this.user});
  final Pengguna user;
  @override
  ConsumerState<EPengaduan> createState() => _EPengaduanState();
}

class _EPengaduanState extends ConsumerState<EPengaduan> {
  int _currentIndex = 0;
  List<Widget> screen = [];

  @override
  void initState() {
    _loadUserData();
    super.initState();

    screen = [
      HomeScreen(
        onTapFitur: _openAddFormOverlay,
      ),
      BeritaScreen(),
      const AduanScreen(),
      const ProfileScreen()
    ];
  }

  void _loadUserData() async {
    ref.read(userProvider.notifier).setUser(
          id: widget.user.id,
          name: widget.user.name,
          email: widget.user.email,
          phone: widget.user.phone,
          address: widget.user.address,
          imageUrl: widget.user.imageUrl,
          isAdmin: false
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
    content = screen[_currentIndex];

    return Scaffold(
      backgroundColor: kColorScheme.background,
      body: content,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kColorScheme.primary,
        foregroundColor: kColorScheme.primaryContainer,
        child: const Icon(Icons.add),
        onPressed: () {
          _openAddFormOverlay(Category.keamanan);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      bottomNavigationBar: Container(
        color: kColorScheme.primary,
        padding: const EdgeInsets.all(12.0),
        child: GNav(
          gap: 10,
          activeColor: kColorScheme.primary,
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          duration: const Duration(milliseconds: 400),
          tabBackgroundColor: kColorScheme.primaryContainer,
          color: kColorScheme.secondaryContainer,
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Beranda',
            ),
            GButton(
              icon: Icons.newspaper_rounded,
              text: 'Berita',
            ),
            GButton(
              icon: Icons.report,
              text: 'Aduan saya',
            ),
            GButton(
              icon: Icons.person_2_sharp,
              text: 'Profil',
            ),
          ],
          selectedIndex: _currentIndex,
          onTabChange: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
