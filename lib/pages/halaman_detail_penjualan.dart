import 'package:flutter/material.dart';
import '../utils/rotigolovers_model.dart';

class RotigoloversDetail extends StatelessWidget {
  final String tanggal;
  final List<RotigoloversModel> laporan;

  const RotigoloversDetail({
    Key? key,
    required this.tanggal,
    required this.laporan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Penjualan: $tanggal"),
        backgroundColor: Colors.brown,
      ),
      body: laporan.isEmpty
          ? const Center(
              child: Text(
                "Tidak ada data untuk tanggal ini.",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: laporan.length,
              itemBuilder: (context, index) {
                final item = laporan[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nama Menu: ${item.nama_menu}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text("Quantity: ${item.quantity}"),
                        Text("Jenis: ${item.jenis}"),
                        Text("Catatan: ${item.notes ?? 'Tidak ada'}"),
                        Text("Kasir: ${item.nama_kasir}"),
                        Text("Pelanggan: ${item.nama_pelanggan}"),
                        Text(
                          "Total: Rp ${item.total_pembelian}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
