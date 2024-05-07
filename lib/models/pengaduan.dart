enum Category { keamanan, lingkungan, infrastruktur }

enum Status { terkirim, diproses, selesai }

class Pengaduan {
  Pengaduan(
      {required this.title,
      required this.description,
      required this.category,
      required this.image,
      required this.status,
      required this.location});
  final String title, description, image, location;
  final Category category;
  final Status status;
}
