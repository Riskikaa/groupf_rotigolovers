import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:groupf_rotigolovers/pages/halaman_chef.dart';
// import 'package:groupf_rotigolovers/pages/halaman_keranjang.dart';
import 'package:groupf_rotigolovers/utils/config.dart';
import 'package:groupf_rotigolovers/utils/restapi.dart';
import 'package:groupf_rotigolovers/utils/rotigolovers_model.dart';

import 'package:groupf_rotigolovers/pages/welcome_page.dart';

class RotigoloversList extends StatefulWidget {
  const RotigoloversList({Key? key}) : super(key: key);

  @override
  RotigoloversListState createState() => RotigoloversListState();
}

class RotigoloversListState extends State<RotigoloversList> {
  final searchKeyword = TextEditingController();
  DataService ds = DataService();

  List data = [];
  List<MenuModel> menu = [];
  Map<int, bool> isOrderedMap = {};

  List<MenuModel> search_data = [];
  List<MenuModel> search_data_pre = [];

  String selectedCategory = 'Semua'; // Tambahkan kategori default
  final List<String> categories = [
    'Semua',
    'Makanan',
    'Minuman'
  ]; // Pilihan kategori

  @override
  void initState() {
    super.initState();
    selectAllMenu();
  }

  Future<void> selectAllMenu() async {
    data = jsonDecode(await ds.selectAll(Token, Project, 'menu', appid));
    menu = data.map((e) => MenuModel.fromJson(e)).toList();

    for (int i = 0; i < menu.length; i++) {
      isOrderedMap[i] = false;
    }

    setState(() {
      menu = menu;
    });
  }

  void filterMenu(String enteredKeyword) {
    // Salin semua data menu
    List<MenuModel> filteredMenu =
        data.map((e) => MenuModel.fromJson(e)).toList();

    // Filter berdasarkan kata kunci pencarian
    if (enteredKeyword.isNotEmpty) {
      filteredMenu = filteredMenu
          .where((item) => item.nama_menu
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    // Filter berdasarkan kategori
    if (selectedCategory != 'Semua') {
      filteredMenu = filteredMenu
          .where((item) =>
              item.kategori.toLowerCase() == selectedCategory.toLowerCase())
          .toList();
    }

    setState(() {
      menu = filteredMenu;
    });
  }

  void filterByCategory(String category) {
    // Ubah kategori yang dipilih
    setState(() {
      selectedCategory = category;
    });

    // Terapkan filter
    filterMenu(searchKeyword.text);
  }

  List<Map<String, String>> getCartItems() {
    List<Map<String, String>> items = [];
    for (int i = 0; i < menu.length; i++) {
      if (isOrderedMap[i] == true) {
        items.add({
          'photo': menu[i].gambar,
          'name': menu[i].nama_menu,
          'price': menu[i].harga,
          'category': menu[i].kategori,
        });
      }
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.brown,
        flexibleSpace: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                "Rotigolovers Store",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Coffee - Eatery - Breads - Cake",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              // IconButton(
              //   icon: const Icon(Icons.shopping_cart, color: Colors.white),
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => HalamanKeranjang(
              //             cartItems:
              //                 getCartItems()), // Pass the correct data here
              //       ),
              //     );
              //   },
              // ),
              if (getCartItems().isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${getCartItems().length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.brown,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/logo.png'),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Rotigolovers Store',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Coffe - Eatry - Breads - Cake',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.store, color: Colors.brown),
              title: const Text('Kasir'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RotigoloversList(),
                  ),
                );
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.kitchen, color: Colors.brown),
            //   title: const Text('Chef'),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const RotigoloversChef(),
            //       ),
            //     );
            //   },
            // ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WelcomePage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchKeyword,
                    onChanged: filterMenu,
                    decoration: InputDecoration(
                      hintText: 'Search menu...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: selectedCategory,
                  items: categories
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      filterByCategory(value);
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: menu.length,
              itemBuilder: (context, index) {
                final item = menu[index];

                return Card(
                  elevation: 5.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Image.network(
                          item.gambar,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.nama_menu,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'RP ${NumberFormat('#,##0', 'id_ID').format(int.parse(item.harga))}',
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Kategori: ${item.kategori}',
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              item.deskripsi,
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isOrderedMap[index] = !isOrderedMap[index]!;
                          });
                        },
                        child:
                            Text(isOrderedMap[index]! ? 'Batalkan' : 'Pesan'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
