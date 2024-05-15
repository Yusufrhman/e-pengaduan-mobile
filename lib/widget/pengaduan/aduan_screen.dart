import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmobv2/main.dart';
import 'package:pmobv2/models/pengaduan.dart';
import 'package:pmobv2/providers/user_provider.dart';
import 'package:pmobv2/widget/pengaduan/aduan_accordion.dart';
import 'package:pmobv2/widget/pengaduan/aduan_header.dart';

class AduanScreen extends ConsumerStatefulWidget {
  const AduanScreen({super.key});

  @override
  ConsumerState<AduanScreen> createState() => _AduanScreenState();
}

class _AduanScreenState extends ConsumerState<AduanScreen> {
  String? _selectedFilterStatus;
  String _searchQuery = '';

  void _filterStatus(Status status) {
    if (status.name == _selectedFilterStatus) {
      _selectedFilterStatus = null;
    } else {
      _selectedFilterStatus = status.name;
    }
    setState(() {});
  }

  ButtonStyle _buttonStyle(Status status) {
    final bool isSelected = status.name == _selectedFilterStatus;
    return ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(
        isSelected ? kColorScheme.background : kColorScheme.primary,
      ),
      side: MaterialStateProperty.all<BorderSide>(
        BorderSide(
          color: kColorScheme.primary,
          width: 1,
        ),
      ),
      textStyle: MaterialStateProperty.all<TextStyle>(
        Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
      ),
      minimumSize: MaterialStateProperty.all<Size>(Size(0, 40)),
      backgroundColor: MaterialStateProperty.all<Color>(
        isSelected ? kColorScheme.primary : kColorScheme.background,
      ),
    );
  }

  @override
  void initState() {
    _selectedFilterStatus = 'terkirim';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _userData = ref.watch(userProvider);
    bool _isAdmin = _userData['isAdmin'];
    return ListView(
      children: [
        const AduanHeader(),
        Container(
          padding: const EdgeInsets.only(right: 10, left: 10, top: 20),
          child: TextFormField(
            onChanged: (value) {
              _searchQuery = value;
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
        Container(
          padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                TextButton.icon(
                    onPressed: () {
                      _filterStatus(Status.terkirim);
                    },
                    icon: const Icon(
                      Icons.send,
                    ),
                    label: const Text('Terkirim'),
                    style: _buttonStyle(Status.terkirim)),
                const SizedBox(
                  width: 5,
                ),
                TextButton.icon(
                    onPressed: () {
                      _filterStatus(Status.diproses);
                    },
                    icon: const Icon(
                      Icons.move_to_inbox,
                    ),
                    label: const Text('Diproses'),
                    style: _buttonStyle(Status.diproses)),
                const SizedBox(
                  width: 5,
                ),
                TextButton.icon(
                    onPressed: () {
                      _filterStatus(Status.selesai);
                    },
                    icon: const Icon(
                      Icons.done_all,
                    ),
                    label: const Text('Selesai'),
                    style: _buttonStyle(Status.selesai)),
                const SizedBox(
                  width: 5,
                ),
                TextButton.icon(
                    onPressed: () {
                      _filterStatus(Status.ditolak);
                    },
                    icon: const Icon(
                      Icons.cancel,
                    ),
                    label: const Text('Ditolak'),
                    style: _buttonStyle(Status.ditolak)),
              ],
            ),
          ),
        ),
        StreamBuilder(
            stream: _isAdmin
                ? FirebaseFirestore.instance
                    .collection('pengaduan')
                    // .where('title', isGreaterThanOrEqualTo: _searchQuery)
                    // .where('title',
                    //     isLessThanOrEqualTo: _searchQuery + '\uf8ff')
                    .where('status', isEqualTo: _selectedFilterStatus)
                    .snapshots()
                : FirebaseFirestore.instance
                    .collection('pengaduan')
                    // .where('title', isGreaterThanOrEqualTo: _searchQuery)
                    // .where('title', isLessThanOrEqualTo: _searchQuery + '\uf8ff')
                    .where('userId',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .where('status', isEqualTo: _selectedFilterStatus)
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: const Center(
                    child: Text('Belum ada pengaduan'),
                  ),
                );
              }

              var pengaduanList = snapshot.data!.docs;
              pengaduanList
                  .sort((a, b) => (a['date_added']).compareTo(b['date_added']));
              pengaduanList = pengaduanList.reversed.toList();
              return AduanAccordion(pengaduanList: pengaduanList);
            }),
      ],
    );
  }
}
