import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pmobv2/models/berita.dart';
import 'package:pmobv2/widget/berita/one_berita_screen.dart';

class HomeCarousell extends StatefulWidget {
  const HomeCarousell({super.key});

  @override
  State<HomeCarousell> createState() => _HomeCarousellState();
}

class _HomeCarousellState extends State<HomeCarousell> {
  QuerySnapshot? querySnapshot;
  bool isLoading = true;
  late List<QueryDocumentSnapshot> _beritaList;

  void _loadBerita() async {
    try {
      querySnapshot = await FirebaseFirestore.instance
          .collection('berita')
          .orderBy('date_added', descending: false)
          .limit(4)
          .get();
      _beritaList = querySnapshot!.docs.toList();
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
    _loadBerita();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double carouselWidth = screenWidth * 0.9;

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SizedBox(
            width: carouselWidth,
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 2.0,
                enlargeCenterPage: true,
              ),
              items: _beritaList.map(
                (item) {
                  return GestureDetector(
                    child: SizedBox(
                      child: Container(
                        margin: const EdgeInsets.all(5.0),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                          child: Stack(
                            children: <Widget>[
                              Image.network(item['image_url'],
                                  fit: BoxFit.cover, width: double.infinity),
                              Positioned(
                                bottom: 0.0,
                                left: 0.0,
                                right: 0.0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(200, 0, 0, 0),
                                        Color.fromARGB(0, 0, 0, 0)
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  child: Text(
                                    item['title'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OneBeritaScreen(
                            berita: Berita(
                                title: item['title'],
                                description: item['description'],
                                image: item['image_url'],
                                date: DateTime.parse(item['date_added'])),
                          ),
                        ),
                      );
                    },
                  );
                },
              ).toList(),
            ),
          );
  }
}
