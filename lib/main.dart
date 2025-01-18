import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:groupf_rotigolovers/firebase_options.dart';

import '../pages/welcome_page.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';
import '../pages/login_admin.dart';
import '../pages/halaman_menu.dart';
import '../pages/halaman_laporan_penjualan.dart';
import '../pages/halaman_chef.dart';
import '../pages/form_add_menu.dart';
import '../pages/halaman_detail_penjualan.dart';

Future<void> main() async {
  // Memastikan binding Flutter sudah diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Menjalankan aplikasi dengan DevicePreview jika bukan mode rilis (release)
  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // Aktifkan DevicePreview di luar mode rilis
      builder: (context) => const MyApp(), // Gantikan dengan widget utama Anda
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'welcome_page',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case 'welcome_page':
            return MaterialPageRoute(builder: (_) => const WelcomePage());
          case 'login_page':
            return MaterialPageRoute(builder: (_) => LoginPage());
          case 'register_page':
            return MaterialPageRoute(builder: (_) => RegisterPage());
          case 'login_admin':
            return MaterialPageRoute(builder: (_) => AdminLoginPage());
          case 'halaman_menu':
            return MaterialPageRoute(builder: (_) => const RotigoloversList());
          case 'halaman_laporan_penjualan':
            return MaterialPageRoute(
                builder: (_) => const RotigoloversLaporan());
          case 'halaman_chef':
            return MaterialPageRoute(builder: (_) => const RotigoloversChef());
          case 'form_add_menu':
            return MaterialPageRoute(builder: (_) => const MenuFormAdd());
          case 'halaman_detail_penjualan':
            if (settings.arguments is Map) {
              final args = settings.arguments as Map;
              return MaterialPageRoute(
                builder: (_) => RotigoloversDetail(
                  tanggal: args['tanggal'],
                  laporan: args['laporan'],
                ),
              );
            }
            return _errorRoute();
          default:
            return _errorRoute();
        }
      },
    );
  }

  MaterialPageRoute _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(
          child: Text("Halaman tidak ditemukan."),
        ),
      ),
    );
  }
}
