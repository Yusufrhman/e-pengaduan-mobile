import 'package:flutter/material.dart';
import 'package:pmobv2/main.dart';
import 'package:pmobv2/models/pengaduan.dart';

class FiturButton extends StatelessWidget {
  const FiturButton(
      {required this.icon,
      required this.label,
      required this.category,
      required this.onTapFitur,
      super.key});
  final void Function(Category category) onTapFitur;
  final Category category;
  final Text label;
  final Icon icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      height: 87.5,
      width: 87.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: kColorScheme.secondaryContainer,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            onTapFitur(category);
          },
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [icon, const SizedBox(height: 5), label],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
