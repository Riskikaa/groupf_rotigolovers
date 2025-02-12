import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../pages/halaman_list_menu.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils/rotigolovers_model.dart';
import '../utils/restapi.dart';
import '../utils/config.dart';
import 'welcome_page.dart';
import 'halaman_detail_penjualan.dart';

class RotigoloversLaporan extends StatefulWidget {
  const RotigoloversLaporan({Key? key}) : super(key: key);

  @override
  RotigoloversLaporanState createState() => RotigoloversLaporanState();
}

class RotigoloversLaporanState extends State<RotigoloversLaporan> {
  final searchKeyword = TextEditingController();
  DataService ds = DataService();
  List data = [];
  List<RotigoloversModel> rotigolovers = [];
  Map<String, List<RotigoloversModel>> laporanPerTanggal = {};
  late DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    selectAllRotigolovers();
  }

  Future<void> selectAllRotigolovers() async {
    try {
      data =
          jsonDecode(await ds.selectAll(Token, Project, 'rotigolovers', appid));

      rotigolovers = data.map((e) => RotigoloversModel.fromJson(e)).toList();

      laporanPerTanggal.clear();
      for (var item in rotigolovers) {
        String tanggal = item.tanggal;
        if (!laporanPerTanggal.containsKey(tanggal)) {
          laporanPerTanggal[tanggal] = [];
        }
        laporanPerTanggal[tanggal]!.add(item);
      }

      setState(() {});
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  double hitungTotalPemasukan(String tanggal) {
    return laporanPerTanggal[tanggal]?.fold(
            0.0,
            (total, item) =>
                total! + (double.tryParse(item.total_pembelian) ?? 0.0)) ??
        0.0;
  }

  // Fungsi untuk menghitung total penjualan keseluruhan
  double hitungTotalPenjualanKeseluruhan() {
    return rotigolovers.fold(
        0.0,
        (total, item) =>
            total + (double.tryParse(item.total_pembelian) ?? 0.0));
  }

  void logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WelcomePage()),
    );
  }

  // Fungsi untuk formatkan uang dalam format 'Rp'
  String formatCurrency(double amount) {
    final currency = 'Rp ${amount.toStringAsFixed(0)}';
    return currency;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard Laporan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.brown,
              ),
              child: const Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add, color: Colors.brown),
              title: const Text('Menu', style: TextStyle(color: Colors.brown)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ListMenu()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.list, color: Colors.brown),
              title:
                  const Text('Laporan', style: TextStyle(color: Colors.brown)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.brown),
              title:
                  const Text('Logout', style: TextStyle(color: Colors.brown)),
              onTap: logout,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Laporan Penjualan - Rotigolovers',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TableCalendar(
              firstDay: DateTime.utc(2020, 01, 01),
              lastDay: DateTime.utc(2025, 12, 31),
              focusedDay: _selectedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                });
              },
            ),
            const SizedBox(height: 20),
            // Menampilkan Total Penjualan Keseluruhan
            Text(
              'Total Penjualan Keseluruhan: ${formatCurrency(hitungTotalPenjualanKeseluruhan())}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (laporanPerTanggal[_selectedDay.toString().split(' ')[0]] !=
                null)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 1,
                itemBuilder: (context, index) {
                  String selectedDate = _selectedDay.toString().split(' ')[0];

                  return ListTile(
                    title: Text(
                      'Tanggal: $selectedDate',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Total: ${formatCurrency(hitungTotalPemasukan(selectedDate))}',
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RotigoloversDetail(
                            tanggal: selectedDate,
                            laporan: laporanPerTanggal[selectedDate] ?? [],
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            else
              const Text('Tidak ada laporan untuk tanggal ini.'),
          ],
        ),
      ),
    );
  }
}
