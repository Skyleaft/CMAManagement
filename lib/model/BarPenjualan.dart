class BarPenjualan {
  DateTime? perbulan;
  int? totalPenjualan;
  int? totalTransaksi;

  BarPenjualan({this.perbulan, this.totalPenjualan, this.totalTransaksi});

  BarPenjualan.fromJson(Map<String, dynamic> json) {
    perbulan = DateTime.parse(json['perbulan']);
    totalPenjualan = json['total_penjualan'];
    totalTransaksi = json['total_transaksi'];
  }
}
