import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:groupf_rotigolovers/pages/halaman_struk.dart';
import '../utils/restapi.dart';
import '../utils/config.dart';
import '../utils/rotigolovers_model.dart';

class FormInput extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  const FormInput({Key? key, required this.cartItems}) : super(key: key);

  @override
  _FormInputState createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  final _formKey = GlobalKey<FormState>();
  final namaPelangganController = TextEditingController();
  final notesController = TextEditingController();
  final tanggalController = TextEditingController();
  final nomorMejaController = TextEditingController();
  final totalPembelianController = TextEditingController();

  String namaKasir = 'Kasir 1'; // Default value for dropdown
  final DataService dataService = DataService();

  @override
  void initState() {
    super.initState();
    _calculateTotalPembayaran();
    // Set the default date to today's date
    tanggalController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  void _calculateTotalPembayaran() {
    double total = 0;
    for (var item in widget.cartItems) {
      double price = double.tryParse(item['price']?.toString() ?? '0.0') ?? 0.0;
      int quantity = item['quantity'] ?? 0;
      total += price * quantity;
    }
    totalPembelianController.text = total.toStringAsFixed(2);
  }

  Future<void> confirmOrder() async {
    if (_formKey.currentState!.validate()) {
      final namaPelanggan = namaPelangganController.text;
      final notes = notesController.text;
      final tanggal = tanggalController.text;
      final nomorMeja = nomorMejaController.text;
      final totalPembayaran = totalPembelianController.text;

      if (kDebugMode) {
        print('Nama Pelanggan: $namaPelanggan');
        print('Catatan: $notes');
        print('Tanggal: $tanggal');
        print('Kasir: $namaKasir');
        print('Nomor Meja: $nomorMeja');
        print('Total Pembayaran: $totalPembayaran');
        print('Cart Items: ${widget.cartItems}');
      }

      final transaksi = RotigoloversModel(
        id: DateTime.now().toString(),
        nama_menu: widget.cartItems.map((item) => item['name']).join(', '),
        quantity: widget.cartItems
            .map((item) => item['quantity'].toString())
            .join(', '),
        jenis: widget.cartItems.map((item) => item['jenis']).join(', '),
        notes: widget.cartItems.map((item) => item['notes']).join(', '),
        tanggal: tanggal,
        nama_kasir: namaKasir,
        nomor_meja: nomorMeja,
        nama_pelanggan: namaPelanggan,
        total_pembelian: totalPembayaran,
      );

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Pesanan Berhasil!'),
            content: const Text('Pesanan Anda telah dikonfirmasi.'),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StrukPage(transaksi: transaksi),
                    ),
                  );
                  try {
                    var response =
                        jsonDecode(await dataService.insertRotigolovers(
                      appid,
                      transaksi.nama_menu,
                      transaksi.quantity,
                      transaksi.jenis,
                      transaksi.tanggal,
                      transaksi.notes,
                      transaksi.nama_kasir,
                      transaksi.nomor_meja,
                      transaksi.nama_pelanggan,
                      transaksi.total_pembelian,
                    ));

                    if (kDebugMode) print(response);

                    if (response is Map && response['data'] != null) {
                      List<dynamic> rotigoloversList = response['data'];
                      List<RotigoloversModel> rotigolovers = rotigoloversList
                          .map((e) => RotigoloversModel.fromJson(e))
                          .toList();

                      if (rotigolovers.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StrukPage(
                              transaksi: rotigolovers.first,
                            ),
                          ),
                        );
                      } else {
                        if (kDebugMode)
                          print('Error: Response contains no data');
                      }
                    } else {
                      if (kDebugMode) {
                        print('Error: Unexpected response structure');
                      }
                    }
                  } catch (e) {
                    if (kDebugMode) print('Error: $e');
                  }
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Formulir Pesanan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Detail Keranjang:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 10),
              ...widget.cartItems.map((item) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text(
                      item['name'] ?? 'No Name',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Jenis: ${item['jenis']}'),
                        Text('Jumlah: ${item['quantity']}'),
                        Text('Harga: ${item['price']}'),
                        Text('Catatan: ${item['notes']}'),
                      ],
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 16.0),

              // Nama Pelanggan
              TextFormField(
                controller: namaPelangganController,
                decoration: const InputDecoration(
                  labelText: 'Nama Pelanggan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama pelanggan wajib diisi.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Dropdown Nama Kasir
              DropdownButtonFormField<String>(
                value: namaKasir,
                items: const [
                  DropdownMenuItem(value: 'Kasir 1', child: Text('Kasir 1')),
                  DropdownMenuItem(value: 'Kasir 2', child: Text('Kasir 2')),
                ],
                onChanged: (newValue) {
                  setState(() {
                    namaKasir = newValue!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Nama Kasir',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),

              // Tanggal
              TextFormField(
                controller: tanggalController,
                decoration: const InputDecoration(
                  labelText: 'Tanggal',
                  hintText: 'YYYY-MM-DD',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      tanggalController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal wajib diisi.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Nomor Meja
              TextFormField(
                controller: nomorMejaController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Meja',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor meja wajib diisi.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Konfirmasi Pesanan
              ElevatedButton(
                onPressed: confirmOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors
                      .brown, // Anda bisa mengganti dengan warna latar belakang yang diinginkan
                ),
                child: const Text(
                  'Konfirmasi Pesanan',
                  style: TextStyle(
                    color: Colors.white, // Mengubah warna teks menjadi putih
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
