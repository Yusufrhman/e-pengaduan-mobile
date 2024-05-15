import 'package:flutter/material.dart';
import 'package:pmobv2/main.dart';
import 'package:pmobv2/models/notif.dart';

class NotifCard extends StatelessWidget {
  const NotifCard({super.key, required this.notif});
  final Notif notif;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.12,
            width: MediaQuery.of(context).size.height * 0.12,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              child: Image.network(
                notif.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notif.title,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: kColorScheme.primary, fontWeight: FontWeight.bold),
                ),
                Text(
                  notif.content,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: kColorScheme.primary, fontSize: 15),
                ),
                Text(
                  notif.formattedDate,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: kColorScheme.primary.withOpacity(0.5),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
