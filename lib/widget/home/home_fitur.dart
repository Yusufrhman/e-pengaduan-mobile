import 'package:flutter/material.dart';
import 'package:pmobv2/models/pengaduan.dart';
import 'package:pmobv2/widget/home/fitur_button.dart';

class HomeFitur extends StatelessWidget {
  const HomeFitur({required this.title, required this.fiturs, required this.onTapFitur, super.key});
  final void Function(Category category) onTapFitur;
  final List<FiturButton> fiturs;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [for (var fitur in fiturs) fitur],
              ),
            ),
          )
        ],
      ),
    );
  }
}
