import 'dart:convert';
import 'package:flutter/material.dart';
import '../pages/halaman_menu.dart';
import '../pages/welcome_page.dart';
import '../utils/rotigolovers_model.dart';
import '../utils/restapi.dart';
import '../utils/config.dart';

class RotigoloversChef extends StatefulWidget {
  const RotigoloversChef({Key? key}) : super(key: key);

  @override
  RotigoloversChefState createState() => RotigoloversChefState();
}

class RotigoloversChefState extends State<RotigoloversChef> {
  final searchKeyword = TextEditingController();
  bool searchStatus = false;
  DataService ds = DataService();

  List data = [];
  List<RotigoloversModel> rotigolovers = [];
  List<bool> buttonStates = [];
  List<RotigoloversModel> search_data = [];

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
      buttonStates = List<bool>.filled(rotigolovers.length, false);
      setState(() {});
    } catch (e) {
      showErrorSnackBar('Failed to load data: $e');
    }
  }

  void filterRotigolovers(String enteredKeyword) {
    setState(() {
      search_data = enteredKeyword.isEmpty
          ? rotigolovers
          : rotigolovers
              .where((item) => item.nama_menu
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
              .toList();
    });
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              "Coffe - Eatry - Breads - Cake",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      drawer: buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            searchStatus ? searchField() : Container(),
            const SizedBox(height: 10),
            Expanded(
              child: rotigolovers.isEmpty
                  ? buildEmptyState()
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: rotigolovers.length,
                      itemBuilder: (context, index) {
                        final item = rotigolovers[index];
                        return buildOrderCard(item, index);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.brown),
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
          ListTile(
            leading: const Icon(Icons.kitchen, color: Colors.brown),
            title: const Text('Chef'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RotigoloversChef(),
                ),
              );
            },
          ),
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
    );
  }

  Widget buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, color: Colors.brown, size: 50),
          const SizedBox(height: 10),
          const Text(
            'No orders found!',
            style: TextStyle(fontSize: 18, color: Colors.brown),
          ),
        ],
      ),
    );
  }

  Widget buildOrderCard(RotigoloversModel item, int index) {
    return InkWell(
      onTap: () {},
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.brown.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.brown.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(5, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.fastfood, color: Colors.brown, size: 20),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(item.nama_menu,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text('Jumlah: ${item.quantity}',
                  style: const TextStyle(fontSize: 14)),
              Text('Jenis: ${item.jenis}',
                  style: const TextStyle(fontSize: 14)),
              Text('Notes: ${item.notes}',
                  style: const TextStyle(fontSize: 14)),
              Text('Pelanggan: ${item.nama_pelanggan}',
                  style: const TextStyle(fontSize: 14)),
              const Spacer(),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      if (buttonStates[index]) {
                        if (index < rotigolovers.length) {
                          rotigolovers.removeAt(index);
                          buttonStates.removeAt(index);
                        }
                      } else {
                        buttonStates[index] = true;
                      }
                    });
                  },
                  icon: Icon(buttonStates[index]
                      ? Icons.check_circle
                      : Icons.play_arrow),
                  label: Text(buttonStates[index] ? 'Selesai' : 'Buat'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    backgroundColor:
                        buttonStates[index] ? Colors.green : Colors.brown,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchField() {
    return TextField(
      controller: searchKeyword,
      autofocus: true,
      onChanged: filterRotigolovers,
      decoration: InputDecoration(
        hintText: 'Cari pesanan...',
        prefixIcon: const Icon(Icons.search, color: Colors.brown),
        filled: true,
        fillColor: Colors.brown.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
