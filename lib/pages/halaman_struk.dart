import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:groupf_rotigolovers/utils/rotigolovers_model.dart';
import 'package:groupf_rotigolovers/pages/halaman_menu.dart';

class StrukPage extends StatelessWidget {
  final RotigoloversModel transaksi;

  StrukPage({required this.transaksi});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: SingleChildScrollView(
        child: Container(
          width: 350, // Lebar struk
          color: const Color(0xFFF6E4D7), // Warna background coklat muda
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 17.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                        255, 165, 135, 90), // Warna coklat untuk header
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Rotigolovers Store",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4), // Spasi antara teks
                      Text(
                        "Coffee - Eatry - Breads - Cake",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Gambar Coffee Pack
                Image.asset(
                  'assets/coffee pack.png',
                  height: 130,
                ),
                const SizedBox(height: 16),
                // Thank You Message
                const Text(
                  "Thank You For Your Orders!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A4E23),
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFF6A4E23), thickness: 1),
                const Text(
                  "Order Confirmation",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // Informasi Struk
                _buildReceiptRow('Kasir:', transaksi.nama_kasir),
                _buildReceiptRow('Tanggal:', transaksi.tanggal),
                const SizedBox(height: 12),
                const Text(
                  'Pesanan:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                _buildReceiptRow('Nama Pelanggan:', transaksi.nama_pelanggan),
                _buildReceiptRow('Menu:', transaksi.nama_menu),
                _buildReceiptRow('Quantity:', transaksi.quantity),
                const SizedBox(height: 12),
                _buildReceiptRow(
                  'Total Pembelian:',
                  '${NumberFormat.simpleCurrency(locale: 'id_ID').format(double.parse(transaksi.total_pembelian))}',
                ),
                const SizedBox(height: 16),
                // Footer
                Center(
                  child: Text(
                    'Terima Kasih!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF6A4E23),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // "Next" Button to navigate to the menu page
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the menu page (RotigoloversList)
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RotigoloversList(),
                      ),
                    );
                  },
                  child: const Text('Next'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                    // Button color
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14.0),
          ),
        ],
      ),
    );
  }
}
