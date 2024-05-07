import 'package:flutter/material.dart';
import 'package:pmobv2/main.dart';
import 'package:pmobv2/models/berita.dart';

class OneBeritaScreen extends StatelessWidget {
  const OneBeritaScreen({required this.berita, super.key});
  final Berita berita;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kColorScheme.background,
        appBar: AppBar(
          backgroundColor: kColorScheme.primary,
          foregroundColor: kColorScheme.primaryContainer,
          toolbarHeight: 65,
        ),
        body: ListView(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(48),
                ),
                child: Image.asset(
                  berita.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    berita.title,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    berita.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.justify,
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
