import 'package:flutter/material.dart';
import 'package:pmobv2/models/berita.dart';
import 'package:pmobv2/widget/beritascreen/berita_card.dart';
import 'package:pmobv2/widget/beritascreen/berita_header.dart';

class BeritaScreen extends StatelessWidget {
  BeritaScreen({super.key});
  final List<Berita> beritaList = [
    Berita(
        title: "Jalan Desa Wiyung Telah Di Perbaiki",
        description:
            "Pemerintah Desa Wiyung telah menyelesaikan proyek perbaikan jalan yang dinanti-nantikan oleh warga. Setelah melalui proses yang intensif, jalan yang sebelumnya rusak parah kini telah mendapatkan perhatian serius dari pihak berwenang dan diperbaiki dengan baik. Langkah ini tidak hanya memperbaiki kondisi infrastruktur, tetapi juga membawa angin segar bagi kemajuan Desa Wiyung secara keseluruhan. Warga pun menyambut baik penyelesaian proyek ini dengan rasa lega. Mereka tidak lagi harus khawatir menghadapi jalan yang berlubang dan rusak saat hendak bepergian. Kondisi jalan yang lebih baik diharapkan tidak hanya meningkatkan aksesibilitas, tetapi juga membuka peluang baru bagi perkembangan ekonomi lokal, karena memperlancar arus transportasi barang dan jasa. Dengan demikian, perbaikan jalan ini bukan hanya sekadar proyek infrastruktur, tetapi juga merupakan investasi dalam kesejahteraan dan perkembangan Desa Wiyung ke arah yang lebih baik",
        image: "assets/images/jalan.jpeg"),
    Berita(
        title: "Jalan Tol ke Desa Wiyung Telah Di Bangun",
        description:
            "Pembangunan infrastruktur yang telah lama dinantikan, yaitu jalan tol menuju Desa Wiyung, akhirnya telah selesai dibangun. Proyek ini merupakan hasil kolaborasi antara pemerintah pusat dan pemerintah daerah untuk meningkatkan konektivitas dan aksesibilitas ke daerah pedesaan. Dengan selesainya pembangunan jalan tol ini, diharapkan akan mempercepat pertumbuhan ekonomi di Desa Wiyung dengan membuka akses yang lebih mudah bagi warga setempat serta memperluas potensi pariwisata dan perdagangan. Keberadaan jalan tol ini juga diharapkan dapat mengurangi kemacetan di jalan-jalan utama dan meningkatkan keselamatan pengguna jalan. Dengan standar konstruksi yang tinggi dan fasilitas yang memadai, jalan tol ini tidak hanya akan memudahkan mobilitas penduduk lokal, tetapi juga memperkuat konektivitas antarwilayah dan memperluas pasar bagi produk-produk lokal. Dengan demikian, pembangunan jalan tol ini tidak hanya merupakan sebuah infrastruktur, tetapi juga investasi dalam pembangunan ekonomi dan sosial yang berkelanjutan bagi Desa Wiyung dan sekitarnya.",
        image: "assets/images/tol.jpeg"),
    Berita(
        title: "Pembangunan Puskesmas Desa Wiyung Selesai",
        description:
            "Desa Wiyung kini telah melangkah maju dengan selesainya proyek pembangunan Puskesmas baru di wilayah tersebut. Pembangunan Puskesmas ini telah menjadi sorotan masyarakat karena dianggap sebagai langkah penting dalam meningkatkan pelayanan kesehatan bagi penduduk desa dan sekitarnya. Dengan selesainya pembangunan ini, diharapkan akan terjadi peningkatan aksesibilitas dan kualitas layanan kesehatan bagi masyarakat Desa Wiyung. Puskesmas yang baru ini dilengkapi dengan fasilitas yang memadai dan tenaga medis yang berkualitas, sehingga dapat memberikan pelayanan kesehatan yang lebih baik dan komprehensif kepada masyarakat. Selain itu, keberadaan Puskesmas ini juga diharapkan dapat memperkuat sistem pemantauan kesehatan masyarakat, meningkatkan kesadaran akan pentingnya kesehatan preventif, dan memberikan akses yang lebih mudah bagi masyarakat untuk mendapatkan perawatan medis yang diperlukan. Dengan demikian, pembangunan Puskesmas Desa Wiyung tidak hanya menjadi simbol kemajuan dalam sektor kesehatan, tetapi juga merupakan langkah penting dalam meningkatkan kesejahteraan dan kualitas hidup masyarakat Desa Wiyung.",
        image: "assets/images/puskesmas.jpeg"),
  ];
  @override
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: beritaList.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const BeritaHeader();
        } else {
          final beritaIndex = index - 1;
          return BeritaCard(
            berita: beritaList[beritaIndex],
          );
        }
      },
    );
  }
}
