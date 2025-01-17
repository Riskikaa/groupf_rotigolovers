class RotigoloversModel {
  final String id;
  final String nama_menu;
  final String quantity;
  final String jenis;
  final String tanggal;
  final String notes;
  final String nama_kasir;
  final String nomor_meja;
  final String nama_pelanggan;
  final String total_pembelian;

  RotigoloversModel(
      {required this.id,
      required this.nama_menu,
      required this.quantity,
      required this.jenis,
      required this.tanggal,
      required this.notes,
      required this.nama_kasir,
      required this.nomor_meja,
      required this.nama_pelanggan,
      required this.total_pembelian});

  factory RotigoloversModel.fromJson(Map data) {
    return RotigoloversModel(
        id: data['_id'],
        nama_menu: data['nama_menu'],
        quantity: data['quantity'],
        jenis: data['jenis'],
        tanggal: data['tanggal'],
        notes: data['notes'],
        nama_kasir: data['nama_kasir'],
        nomor_meja: data['nomor_meja'],
        nama_pelanggan: data['nama_pelanggan'],
        total_pembelian: data['total_pembelian']);
  }

  get status => null;
}

class MenuModel {
  final String id;
  final String nama_menu;
  final String harga;
  final String deskripsi;
  final String kategori;
  final String gambar;

  MenuModel(
      {required this.id,
      required this.nama_menu,
      required this.harga,
      required this.deskripsi,
      required this.kategori,
      required this.gambar});

  factory MenuModel.fromJson(Map data) {
    return MenuModel(
        id: data['_id'],
        nama_menu: data['nama_menu'],
        harga: data['harga'],
        deskripsi: data['deskripsi'],
        kategori: data['kategori'],
        gambar: data['gambar']);
  }
}
