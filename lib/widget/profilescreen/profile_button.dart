import 'package:flutter/material.dart';
import 'package:pmobv2/main.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
    super.key,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onPress,
        child: SizedBox(
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: kColorScheme.secondaryContainer,
                ),
                child: Icon(icon, color: kColorScheme.primary),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kColorScheme.secondary),
              ),
              const Spacer(),
              endIcon
                  ? Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18.0,
                        color: Colors.grey,
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
