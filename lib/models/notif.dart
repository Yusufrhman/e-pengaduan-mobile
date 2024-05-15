import 'package:intl/intl.dart';

class Notif {
  Notif(
      {required this.id,
      required this.title,
      required this.content,
      required this.date,
      required this.imageUrl});
  final DateTime date;
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  String get formattedDate {
    return DateFormat.yMMMEd().format(date);
  }
}
