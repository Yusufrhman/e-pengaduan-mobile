import 'dart:math';

import 'package:accordion/controllers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmobv2/main.dart';
import 'package:pmobv2/models/pengaduan.dart';
import 'package:pmobv2/providers/user_provider.dart';
import 'package:pmobv2/widget/pengaduan/form-pengaduan/form_screen.dart';

class AduanAccordion extends ConsumerStatefulWidget {
  const AduanAccordion({super.key, required this.pengaduanList});
  final List<dynamic> pengaduanList;
  @override
  ConsumerState<AduanAccordion> createState() => _AduanAccordionState();
}

class _AduanAccordionState extends ConsumerState<AduanAccordion> {
  void _openAddFormOverlay(Pengaduan pengaduan) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => FormScreen(
        pengaduan: pengaduan,
      ),
    );
  }

  void _showConfirmDelete(Pengaduan pengaduan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Hapus pengaduan?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'Anda tidak dapat membatalkan tindakan ini, yakin hapus "${pengaduan.title}"?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(
                  kColorScheme.error,
                ),
                padding: MaterialStateProperty.all(EdgeInsets.all(0))),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("batal"),
          ),
          Ink(
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    kColorScheme.error,
                  ),
                  foregroundColor: MaterialStateProperty.all(
                    kColorScheme.background,
                  ),
                  padding: MaterialStateProperty.all(EdgeInsets.all(0))),
              onPressed: () async {
                await _deletePengaduan(pengaduan);
                if (!mounted) {
                  return;
                }
                Navigator.pop(context);
              },
              child: const Text("hapus"),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deletePengaduan(Pengaduan pengaduan) async {
    try {
      await FirebaseFirestore.instance
          .collection('pengaduan')
          .doc(pengaduan.id)
          .delete();
    } on FirebaseException catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("failed")),
      );
      print(e);
    }
  }

  void _showConfirmDecline(Pengaduan pengaduan, String reporterId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Tolak pengaduan?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'Anda tidak dapat membatalkan tindakan ini, yakin tolak "${pengaduan.title}"?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(
                  kColorScheme.error,
                ),
                padding: MaterialStateProperty.all(EdgeInsets.all(0))),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("batal"),
          ),
          Ink(
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    kColorScheme.error,
                  ),
                  foregroundColor: MaterialStateProperty.all(
                    kColorScheme.background,
                  ),
                  padding: MaterialStateProperty.all(EdgeInsets.all(0))),
              onPressed: () async {
                await _changeStatus(pengaduan, Status.ditolak, reporterId);
                if (!mounted) {
                  return;
                }
                Navigator.pop(context);
              },
              child: const Text("tolak"),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _changeStatus(
      Pengaduan pengaduan, Status status, String reporterId) async {
    try {
      await FirebaseFirestore.instance
          .collection('pengaduan')
          .doc(pengaduan.id)
          .update({'status': status.name});
      await FirebaseFirestore.instance
          .collection('users')
          .doc(reporterId)
          .collection('notification')
          .add({
        'title': pengaduan.title,
        'content': 'Aduan anda telah ${status.name}',
        'image_url': pengaduan.image,
        'date_added': DateTime.now().toString()
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(reporterId)
          .update({
        'unread_notif': FieldValue.arrayUnion([uuid.v1()])
      });
    } on FirebaseException catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("failed")),
      );
      print(e);
    }
  }

  @override
  Widget build(context) {
    final userData = ref.watch(userProvider);
    bool isAdmin = userData['isAdmin'];
    return Accordion(
      disableScrolling: true,
      headerBackgroundColor: kColorScheme.secondaryContainer,
      contentBackgroundColor: kColorScheme.secondaryContainer,
      contentBorderWidth: 0,
      contentHorizontalPadding: 20,
      scaleWhenAnimating: true,
      openAndCloseAnimation: true,
      headerPadding: const EdgeInsets.all(12),
      sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
      sectionClosingHapticFeedback: SectionHapticFeedback.light,
      children: widget.pengaduanList
          .map(
            (pengaduan) => AccordionSection(
              rightIcon: const Icon(
                Icons.keyboard_arrow_down,
                color: Color.fromRGBO(0, 0, 0, 0.541),
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
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Text(pengaduan['title'],
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          pengaduan['category'],
                          style: TextStyle(
                              fontSize: 14, color: kColorScheme.secondary),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                              color: pengaduan['status'] == 'terkirim'
                                  ? const Color.fromARGB(255, 255, 238, 168)
                                  : pengaduan['status'] == 'diproses'
                                      ? const Color.fromARGB(255, 180, 230, 255)
                                      : pengaduan['status'] == 'ditolak'
                                          ? const Color.fromARGB(
                                              255, 255, 194, 185)
                                          : const Color.fromARGB(
                                              255, 187, 255, 207),
                              borderRadius: BorderRadius.circular(100)),
                          child: Text(
                            pengaduan['status'],
                            style: pengaduan['status'] == 'terkirim'
                                ? const TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 253, 107, 4),
                                  )
                                : pengaduan['status'] == 'diproses'
                                    ? const TextStyle(
                                        fontSize: 14,
                                        color: Color.fromARGB(255, 0, 79, 175),
                                      )
                                    : pengaduan['status'] == 'ditolak'
                                        ? const TextStyle(
                                            fontSize: 14,
                                            color:
                                                Color.fromARGB(255, 123, 0, 0),
                                          )
                                        : const TextStyle(
                                            fontSize: 14,
                                            color:
                                                Color.fromARGB(255, 0, 137, 27),
                                          ),
                          ),
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
                    const SizedBox(
                      height: 8,
                    ),
                    isAdmin
                        ? Text('Pengirim: ${pengaduan['userId']}',
                            style: Theme.of(context).textTheme.bodyMedium)
                        : const SizedBox(),
                    pengaduan['status'] != Status.terkirim.name
                        ? isAdmin
                            ? pengaduan['status'] == Status.diproses.name
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton.icon(
                                        onPressed: () {
                                          _showConfirmDecline(
                                              Pengaduan(
                                                id: pengaduan.id,
                                                title: pengaduan['title'],
                                                description:
                                                    pengaduan['description'],
                                                category: getCategoryFromString(
                                                    pengaduan['category']),
                                                image: pengaduan['image_url'],
                                                status: getStatusFromString(
                                                    pengaduan['status']),
                                                location: pengaduan['location'],
                                                date: DateTime.parse(
                                                  pengaduan['date_added'],
                                                ),
                                              ),
                                              pengaduan['userId']);
                                        },
                                        icon: Icon(
                                          Icons.cancel,
                                          color: kColorScheme.error,
                                        ),
                                        label: Text(
                                          'Tolak',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: kColorScheme.error,
                                                  fontSize: 14),
                                        ),
                                      ),
                                      TextButton.icon(
                                        onPressed: () {
                                          _changeStatus(
                                              Pengaduan(
                                                  id: pengaduan.id,
                                                  title: pengaduan['title'],
                                                  description:
                                                      pengaduan['description'],
                                                  category:
                                                      getCategoryFromString(
                                                          pengaduan[
                                                              'category']),
                                                  image: pengaduan['image_url'],
                                                  status: getStatusFromString(
                                                      pengaduan['status']),
                                                  location:
                                                      pengaduan['location'],
                                                  date: DateTime.parse(
                                                      pengaduan['date_added'])),
                                              Status.selesai,
                                              pengaduan['userId']);
                                        },
                                        icon: const Icon(
                                          Icons.done_all_rounded,
                                          color: Color.fromARGB(255, 0, 161, 5),
                                        ),
                                        label: Text(
                                          'Selesai',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: const Color.fromARGB(
                                                      255, 0, 161, 5),
                                                  fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox()
                            : const SizedBox()
                        : isAdmin
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      _showConfirmDecline(
                                          Pengaduan(
                                            id: pengaduan.id,
                                            title: pengaduan['title'],
                                            description:
                                                pengaduan['description'],
                                            category: getCategoryFromString(
                                                pengaduan['category']),
                                            image: pengaduan['image_url'],
                                            status: getStatusFromString(
                                                pengaduan['status']),
                                            location: pengaduan['location'],
                                            date: DateTime.parse(
                                              pengaduan['date_added'],
                                            ),
                                          ),
                                          pengaduan['userId']);
                                    },
                                    icon: Icon(
                                      Icons.cancel,
                                      color: kColorScheme.error,
                                    ),
                                    label: Text(
                                      'Tolak',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: kColorScheme.error,
                                              fontSize: 14),
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      _changeStatus(
                                          Pengaduan(
                                            id: pengaduan.id,
                                            title: pengaduan['title'],
                                            description:
                                                pengaduan['description'],
                                            category: getCategoryFromString(
                                                pengaduan['category']),
                                            image: pengaduan['image_url'],
                                            status: getStatusFromString(
                                                pengaduan['status']),
                                            location: pengaduan['location'],
                                            date: DateTime.parse(
                                              pengaduan['date_added'],
                                            ),
                                          ),
                                          Status.diproses,
                                          pengaduan['userId']);
                                    },
                                    icon: Icon(
                                      Icons.check_circle,
                                      color: kColorScheme.primary,
                                    ),
                                    label: Text(
                                      'Terima',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: kColorScheme.primary,
                                              fontSize: 14),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      _openAddFormOverlay(
                                        Pengaduan(
                                          id: pengaduan.id,
                                          title: pengaduan['title'],
                                          description: pengaduan['description'],
                                          category: getCategoryFromString(
                                              pengaduan['category']),
                                          image: pengaduan['image_url'],
                                          status: getStatusFromString(
                                              pengaduan['status']),
                                          location: pengaduan['location'],
                                          date: DateTime.parse(
                                            pengaduan['date_added'],
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: kColorScheme.primary,
                                    ),
                                    label: Text(
                                      'Edit',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: kColorScheme.primary,
                                              fontSize: 14),
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      _showConfirmDelete(Pengaduan(
                                          id: pengaduan.id,
                                          title: pengaduan['title'],
                                          description: pengaduan['description'],
                                          category: getCategoryFromString(
                                              pengaduan['category']),
                                          image: pengaduan['image_url'],
                                          status: getStatusFromString(
                                              pengaduan['status']),
                                          location: pengaduan['location'],
                                          date: DateTime.parse(
                                              pengaduan['date_added'])));
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: kColorScheme.error,
                                    ),
                                    label: Text(
                                      'Hapus',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: kColorScheme.error,
                                              fontSize: 14),
                                    ),
                                  ),
                                ],
                              )
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
