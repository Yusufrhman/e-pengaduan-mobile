import 'package:flutter/material.dart';
import 'package:pmobv2/main.dart';
import 'package:pmobv2/models/berita.dart';
import 'package:pmobv2/widget/berita/one_berita_screen.dart';

class BeritaCard extends StatelessWidget {
  const BeritaCard({required this.berita, super.key});
  final Berita berita;

  double _getFontSize(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 400) {
      return 14.0;
    } else if (screenWidth >= 400 && screenWidth < 600) {
      return 16.0;
    } else {
      return 18.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: (MediaQuery.of(context).size.width / 2) - 24,
              height: MediaQuery.of(context).size.height / 7,
              child: Image.network(
                berita.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: (MediaQuery.of(context).size.width / 2) - 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                      text: berita.title,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: _getFontSize(context),
                            fontWeight: FontWeight.bold,
                            color: kColorScheme.primary,
                          )),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: kColorScheme.secondaryContainer,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => OneBeritaScreen(
                              berita: berita,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 0),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "view",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: kColorScheme.primary, fontSize: 13),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                size: 13,
                                color: kColorScheme.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
