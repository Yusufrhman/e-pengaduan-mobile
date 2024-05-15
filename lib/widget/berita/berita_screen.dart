import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pmobv2/main.dart';
import 'package:pmobv2/models/berita.dart';
import 'package:pmobv2/widget/berita/berita_card.dart';
import 'package:pmobv2/widget/berita/berita_header.dart';

class BeritaScreen extends StatefulWidget {
  BeritaScreen({Key? key}) : super(key: key);

  @override
  State<BeritaScreen> createState() => _BeritaScreenState();
}

class _BeritaScreenState extends State<BeritaScreen> {
  QuerySnapshot? querySnapshot;
  bool isLoading = true;
  late List<QueryDocumentSnapshot> _beritaList;

  void _loadBerita(String searchQuery) async {
    try {
      querySnapshot = await FirebaseFirestore.instance
          .collection('berita')
          .where('title', isGreaterThanOrEqualTo: searchQuery)
          .where('title', isLessThanOrEqualTo: searchQuery + '\uf8ff')
          .get();
    } catch (e) {
      print('Error loading berita: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadBerita('');
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: querySnapshot!.docs.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const BeritaHeader();
        }
        if (index == 1) {
          return Container(
            padding: const EdgeInsets.only(right: 10, left: 10, bottom: 20),
            child: TextFormField(
              onChanged: (value) {
                _loadBerita(value);
                setState(() {});
              },
              style: TextStyle(
                color: kColorScheme.primary,
              ),
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: kColorScheme.primary,
                  ),
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: kColorScheme.primary)),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kColorScheme.primary, width: 2)),
                  hintText: 'Search by title...',
                  filled: true,
                  fillColor: kColorScheme.background),
            ),
          );
        } else {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (querySnapshot == null || querySnapshot!.docs.isEmpty) {
            return const Center(child: Text('No data available'));
          }
          final beritaIndex = index - 2;
          _beritaList = querySnapshot!.docs.toList();
          _beritaList
              .sort((b, a) => (a['date_added']).compareTo(b['date_added']));
          final berita = _beritaList[beritaIndex];
          return BeritaCard(
            berita: Berita(
              title: berita['title'],
              description: berita['description'],
              image: berita['image_url'],
              date: DateTime.parse(
                berita['date_added'],
              ),
            ),
          );
        }
      },
    );
  }
}
