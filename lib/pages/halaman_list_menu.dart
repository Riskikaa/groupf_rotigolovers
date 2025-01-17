import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../pages/form_add_menu.dart';
import '../pages/halaman_chef.dart';
import '../utils/config.dart';
import '../utils/restapi.dart';
import '../utils/rotigolovers_model.dart';
import '../pages/welcome_page.dart'; // Add this import

class ListMenu extends StatefulWidget {
  const ListMenu({Key? key}) : super(key: key);

  @override
  ListMenuState createState() => ListMenuState();
}

class ListMenuState extends State<ListMenu> {
  final searchKeyword = TextEditingController();
  DataService ds = DataService();

  List data = [];
  List<MenuModel> menu = [];
  Map<int, bool> isOrderedMap = {};

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

  // Method for deleting menu item
  void deleteMenuItem(int index) async {
    // Optionally confirm before deleting
    bool shouldDelete = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Item'),
              content:
                  const Text('Are you sure you want to delete this menu item?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false;

    if (shouldDelete) {
      String menuId =
          menu[index].id; // Assuming you have a unique 'id' for each menu item

      // Call your API service to delete the specific menu item by its ID
      bool success = await ds.removeId(
          Token, Project, 'menu', appid, menuId); // Pass the ID to remove

      if (success) {
        // Refresh the list after deletion
        setState(() {
          menu.removeAt(index); // Remove the item from the list
        });
      } else {
        // Handle error, maybe show a snackbar or dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete menu item")),
        );
      }
    }
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
          // Add the plus icon button here
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white), // Plus icon
            onPressed: () {
              // Navigate to MenuFormAdd
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MenuFormAdd(),
                ),
              );
            },
          ),
        ],
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
            child: ListView.builder(
              itemCount: menu.length,
              itemBuilder: (context, index) {
                final item = menu[index];

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  leading: Image.network(
                    item.gambar,
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    item.nama_menu,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RP ${NumberFormat('#,##0', 'id_ID').format(int.parse(item.harga))}',
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.brown,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        item.kategori,
                        style: const TextStyle(fontSize: 12.0),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: isOrderedMap[index] ?? false,
                        onChanged: (bool? value) {
                          setState(() {
                            isOrderedMap[index] = value ?? false;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          deleteMenuItem(index);
                        },
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
