import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:pmobv2/main.dart';
import 'package:pmobv2/widget/home/fitur_button.dart';
import 'package:pmobv2/widget/home/home_carousell.dart';
import 'package:pmobv2/widget/home/home_fitur.dart';
import 'package:pmobv2/widget/home/home_profile.dart';
import 'package:pmobv2/models/pengaduan.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.onTapFitur, super.key});
  final void Function(Category category) onTapFitur;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<FiturButton> fiturPengaduan = [];
  List<FiturButton> fiturLainnya = [];

  @override
  void initState() {
    super.initState();
    fiturPengaduan = [
      FiturButton(
        category: Category.keamanan,
        icon: Icon(
          Icons.local_police,
          size: 32,
          color: kColorScheme.primary,
        ),
        label: Text(
          "keamanan",
          style: TextStyle(
            fontSize: 12,
            color: kColorScheme.primary,
          ),
        ),
        onTapFitur: widget.onTapFitur,
      ),
      FiturButton(
        category: Category.lingkungan,
        icon: Icon(
          Icons.local_florist,
          size: 32,
          color: kColorScheme.primary,
        ),
        label: Text(
          "lingkungan",
          style: TextStyle(
            fontSize: 12,
            color: kColorScheme.primary,
          ),
        ),
        onTapFitur: widget.onTapFitur,
      ),
      FiturButton(
        category: Category.infrastruktur,
        onTapFitur: widget.onTapFitur,
        icon: Icon(
          Elusive.road,
          size: 32,
          color: kColorScheme.primary,
        ),
        label: Text(
          "infrastruktur",
          style: TextStyle(
            fontSize: 12,
            color: kColorScheme.primary,
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(context) {
    return ListView(
      children: [
        const HomeProfile(),
        const HomeCarousell(),
        HomeFitur(
          title: "PENGADUAN",
          fiturs: fiturPengaduan,
          onTapFitur: widget.onTapFitur,
        ),
      ],
    );
  }
}
