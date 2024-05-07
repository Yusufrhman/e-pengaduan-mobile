import 'package:accordion/controllers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmobv2/main.dart';
import 'package:pmobv2/models/pengaduan.dart';
import 'package:pmobv2/providers/user_provider.dart';

class AduanAccordion extends ConsumerWidget {
  const AduanAccordion({super.key, required this.pengaduanList});
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> pengaduanList;

  @override
  Widget build(context, WidgetRef ref) {
    var userData = ref.watch(userProvider);
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userData['id'])
            .collection('pengaduan')
            .orderBy('date_added')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Belum ada pengaduan, mulai mengadukan'),
            );
          }

          final pengaduanList = snapshot.data!.docs;
          return Accordion(
            disableScrolling: true,
            headerBackgroundColor: kColorScheme.secondaryContainer,
            contentBackgroundColor: kColorScheme.secondaryContainer,
            contentBorderWidth: 0,
            contentHorizontalPadding: 20,
            scaleWhenAnimating: true,
            openAndCloseAnimation: true,
            headerPadding:
                const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
            sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
            sectionClosingHapticFeedback: SectionHapticFeedback.light,
            children: pengaduanList
                .map(
                  (pengaduan) => AccordionSection(
                    rightIcon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black54,
                      size: 20,
                    ),
                    isOpen: false,
                    header: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: (MediaQuery.of(context).size.width / 3),
                            height: MediaQuery.of(context).size.height / 8,
                            child: Image.network(
                              pengaduan['image_url'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width / 2) - 24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(pengaduan['title'],
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                pengaduan['category'],
                                style: TextStyle(
                                    fontSize: 14,
                                    color: kColorScheme.secondary),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 255, 238, 168),
                                    borderRadius: BorderRadius.circular(100)),
                                child: const Text('terkirim',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 253, 107, 4),
                                    )),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    content: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Deskripsi",
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(pengaduan['description'],
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Location",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(pengaduan['location'],
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          );
        });
  }
}
