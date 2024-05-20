import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pmobv2/main.dart';
import 'package:pmobv2/models/berita.dart';
import 'package:pmobv2/widget/berita/berita_card.dart';
import 'package:pmobv2/widget/berita/berita_header.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BeritaScreen extends StatefulWidget {
  BeritaScreen({Key? key}) : super(key: key);

  @override
  State<BeritaScreen> createState() => _BeritaScreenState();
}

class _BeritaScreenState extends State<BeritaScreen> {
  QuerySnapshot? querySnapshot;
  bool isLoading = true;
  List<QueryDocumentSnapshot> _beritaList = [];

  final _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await _loadBerita('');
    _refreshController.refreshCompleted();
  }

  Future _loadBerita(String searchQuery) async {
    try {
      QuerySnapshot newQuerySnapshot = await FirebaseFirestore.instance
          .collection('berita')
          .where('title', isGreaterThanOrEqualTo: searchQuery)
          .where('title', isLessThanOrEqualTo: searchQuery + '\uf8ff')
          // .limit(5)
          .get();
      setState(() {
        querySnapshot = newQuerySnapshot;
        _beritaList = querySnapshot!.docs.toList();
      });
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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return SafeArea(
      child: Column(
        children: [
          const BeritaHeader(),
          Container(
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
          ),
          Expanded(
            child: SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              onRefresh: _onRefresh,
              header: WaterDropHeader(
                complete: SizedBox(),
                waterDropColor: kColorScheme.primaryContainer,
              ),
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus? mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    body = Text('');
                  } else if (mode == LoadStatus.loading) {
                    body = CircularProgressIndicator();
                  } else if (mode == LoadStatus.failed) {
                    body = Text("");
                  } else if (mode == LoadStatus.canLoading) {
                    body = Text("");
                  } else {
                    body = Text("No more Data");
                  }
                  return Container(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              child: ListView.builder(
                padding: EdgeInsets.only(top: 0),
                itemCount: _beritaList.length,
                itemBuilder: (context, index) {
                  if (isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (querySnapshot == null || querySnapshot!.docs.isEmpty) {
                    return const Center(child: Text('No data available'));
                  }
                  final beritaIndex = index;
                  _beritaList.sort(
                      (b, a) => (a['date_added']).compareTo(b['date_added']));
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
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
