import 'package:intl/intl.dart';

class Berita {
  Berita({
    required this.title,
    required this.description,
    required this.image,
    required this.date,
  });
  final DateTime date;
   String get formattedDate {
    return DateFormat.yMMMMd().format(date);
  }
  final String title, description, image;
}
