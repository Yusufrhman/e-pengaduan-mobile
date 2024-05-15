import 'package:flutter/material.dart';
import 'package:pmobv2/main.dart';
import 'package:pmobv2/models/notif.dart';

List<Notif> notif = [
  Notif(
      id: '1',
      title: 'ini judul',
      content: 'pengaduan anda telah berubah status',
      imageUrl: 'assets/images/godzilla.jpeg',
      date: DateTime.now()),
  Notif(
      id: '1',
      title: 'ini judul',
      content: 'pengaduan anda telah berubah status',
      imageUrl: 'assets/images/godzilla.jpeg',
      date: DateTime.now()),
  Notif(
      id: '1',
      title: 'ini judul',
      content: 'pengaduan anda telah berubah status',
      imageUrl: 'assets/images/godzilla.jpeg',
      date: DateTime.now()),
  Notif(
      id: '1',
      title: 'ini judul',
      content: 'pengaduan anda telah berubah status',
      imageUrl: 'assets/images/godzilla.jpeg',
      date: DateTime.now()),
];

class NotifScreen extends StatelessWidget {
  const NotifScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: notif.length,
        itemBuilder: (context, index) {
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
                    child: Image.asset(
                      notif[index].imageUrl,
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
                        notif[index].title,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: kColorScheme.primary,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        notif[index].content,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: kColorScheme.primary, fontSize: 15),
                      ),
                      Text(
                        notif[index].formattedDate,
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
        },
      ),
    );
  }
}
