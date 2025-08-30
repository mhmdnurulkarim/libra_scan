import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/constants/color_constans.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  final username = "mhmdnurulkarim";

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tentang Developer"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('asset/about/me.jpg'),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: const [
                  Text(
                    "Muhammad Nurul Karim",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Android Developer",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              "Tentang Saya",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Saya merupakan mahasiswa aktif pada Program Studi Sistem Informasi di Universitas Metamedia, Kota Padang, yang ditempuh sejak tahun 2021. Sebelumnya, saya menempuh pendidikan menengah kejuruan di SMK Negeri 1 Kota Bengkulu, dengan jurusan Teknik Komputer dan Jaringan. Selama menjalani masa studi, saya secara aktif mengembangkan keahlian di bidang pengembangan aplikasi mobile, khususnya menggunakan Java, Kotlin, dan Flutter.",
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),

            const Text(
              "Kontak",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            GestureDetector(
              onTap: () => _launchUrl("mailto:$username@email.com"),
              child: Text(
                "📧 Email: $username@email.com",
                style: TextStyle(color: ColorConstant.primaryColor(context)),
              ),
            ),
            const SizedBox(height: 6),

            GestureDetector(
              onTap: () => _launchUrl("https://github.com/$username"),
              child: Text(
                "💻 GitHub: github.com/$username",
                style: TextStyle(color: ColorConstant.primaryColor(context)),
              ),
            ),
            const SizedBox(height: 6),

            GestureDetector(
              onTap: () => _launchUrl("https://linkedin.com/in/$username"),
              child: Text(
                "🔗 LinkedIn: linkedin.com/in/$username",
                style: TextStyle(color: ColorConstant.primaryColor(context)),
              ),
            ),

            const SizedBox(height: 20),

            GestureDetector(
              onTap:
                  () => _launchUrl(
                    "https://drive.google.com/file/d/12XKwTEQY_NxuGoC2kBw2BawESnN_7ulM/view?usp=drivesdk",
                  ),
              child: Text(
                "📄 Lihat CV Selengkapnya",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorConstant.primaryColor(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
