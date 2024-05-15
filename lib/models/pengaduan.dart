enum Category { keamanan, lingkungan, infrastruktur }

enum Status { terkirim, diproses, selesai, ditolak }

class Pengaduan {
  Pengaduan({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.image,
    required this.status,
    required this.location,
    required this.date,

  });
  final String id;

  final String title;
  final String description;
  final String image;
  final String location;
  final Category category;
  final Status status;
  final DateTime date;

}

Category getCategoryFromString(String str) {
  try {
    return Category.values.firstWhere((e) => e.name == str);
  } catch (e) {
    throw Exception("Invalid category string: $str");
  }
}

Status getStatusFromString(String str) {
  try {
    return Status.values.firstWhere((e) => e.name == str);
  } catch (e) {
    throw Exception("Invalid status string: $str");
  }
}
