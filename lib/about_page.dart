import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
    const AboutPage({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('Tentang Aplikasi'),
            ),
            body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        const Text(
                            'Tentang Agendaku',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                            ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                            'Agendaku adalah aplikasi catatan harian yang dirancang untuk membantu pengguna mencatat, mengelola, dan menyelesaikan berbagai agenda harian dengan mudah dan efisien. Aplikasi ini mendukung pencatatan agenda lengkap dengan : ',
                            style: TextStyle(fontSize: 16),
                        ),
                        const Text(
                            ' • 📅 Penambahan judul agenda\n'
                            ' • ⏰ Pemilihan deadline (batas waktu)\n'
                            ' • 🏷️ Kategori agenda (Umum, Kuliah, Kerja, Pribadi)\n'
                            ' • 🔍 Pencarian agenda\n'
                            ' • ✏️ Edit dan hapus catatan\n'
                            ' • 🌗 Mode terang dan gelap (Light/Dark Mode)\n'
                            ' • 💾 Penyimpanan lokal menggunakan SharedPreferences',
                            style: TextStyle(fontSize: 16),                        
                        ),
                        const SizedBox(height: 16),
                        const Text(
                            'Desain aplikasi menggunakan font kustom agar tampil lebih personal dan menarik. Aplikasi ini berjalan sepenuhnya tanpa internet, menjadikannya ringan dan tetap dapat digunakan di mana saja.',
                            style: TextStyle(fontSize: 16),
                        ),
                    ],
                ),
            ),
        );
    }
}