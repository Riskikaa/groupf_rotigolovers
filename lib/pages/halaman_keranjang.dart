import 'package:flutter/material.dart';
// import 'package:groupf_rotigolovers/pages/halaman_konfirmasi.dart';

class HalamanKeranjang extends StatefulWidget {
  final List<Map<String, String>> cartItems;

  const HalamanKeranjang({Key? key, required this.cartItems}) : super(key: key);

  @override
  _HalamanKeranjangState createState() => _HalamanKeranjangState();
}

class _HalamanKeranjangState extends State<HalamanKeranjang> {
  late List<Map<String, dynamic>> cartWithQuantities;

  @override
  void initState() {
    super.initState();
    // Initialize cart items with default quantity, notes, and temperature
    cartWithQuantities = widget.cartItems
        .map((item) => {
              'name': item['name'],
              'price': item['price'],
              'quantity': 1,
              'category': item['category'] ?? 'No Category',
              'notes': '',
              'jenis': 'None',
            })
        .toList();
  }

  void updateQuantity(int index, String newQuantity) {
    setState(() {
      final parsedQuantity = int.tryParse(newQuantity);
      if (parsedQuantity != null && parsedQuantity > 0) {
        cartWithQuantities[index]['quantity'] = parsedQuantity;
      }
    });
  }

  void updateNotes(int index, String newNotes) {
    setState(() {
      cartWithQuantities[index]['notes'] = newNotes;
    });
  }

  void updateJenis(int index, String newJenis) {
    setState(() {
      cartWithQuantities[index]['jenis'] = newJenis;
    });
  }

  // void confirmOrder() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => FormInput(cartItems: cartWithQuantities),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Keranjang',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown,
      ),
      body: cartWithQuantities.isEmpty
          ? const Center(
              child: Text(
                'Keranjang kosong!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartWithQuantities.length,
                    itemBuilder: (context, index) {
                      final item = cartWithQuantities[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        elevation: 4,
                        child: ExpansionTile(
                          leading: const Icon(Icons.shopping_cart,
                              color: Colors.brown),
                          title: Text(
                            item['name'] ?? 'No Name',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            'Harga: ${item['price'] ?? 'No Price'}',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'Kategori: ${item['category']}',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: DropdownButton<String>(
                                value: item['jenis'],
                                onChanged: (newValue) {
                                  updateJenis(index, newValue ?? 'None');
                                },
                                items: <String>['None', 'Hot', 'Ice']
                                    .map((value) => DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        ))
                                    .toList(),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon:
                                        const Icon(Icons.remove_circle_outline),
                                    color: Colors.brown,
                                    onPressed: () {
                                      if (item['quantity'] > 1) {
                                        updateQuantity(index,
                                            (item['quantity'] - 1).toString());
                                      }
                                    },
                                  ),
                                  Expanded(
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      controller: TextEditingController(
                                        text: '${item['quantity']}',
                                      ),
                                      onChanged: (newQuantity) {
                                        updateQuantity(index, newQuantity);
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    color: Colors.brown,
                                    onPressed: () {
                                      updateQuantity(index,
                                          (item['quantity'] + 1).toString());
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: 'Catatan',
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: 3,
                                onChanged: (newNotes) {
                                  updateNotes(index, newNotes);
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(10.0),
                //   child: ElevatedButton(
                //     onPressed: confirmOrder,
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.brown,
                //       padding: const EdgeInsets.symmetric(
                //           vertical: 15, horizontal: 40),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(8),
                //       ),
                //     ),
                //     child: const Text(
                //       'Konfirmasi Pesanan',
                //       style: TextStyle(
                //         fontSize: 16,
                //         fontWeight: FontWeight.bold,
                //         color:
                //             Colors.white, // Mengubah warna teks menjadi putih
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
    );
  }
}
