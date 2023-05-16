class BarPembelian {
  DateTime? perbulan;
  int? totalPembelian;
  int? totalTransaksi;

  BarPembelian({this.perbulan, this.totalPembelian, this.totalTransaksi});

  BarPembelian.fromJson(Map<String, dynamic> json) {
    perbulan = DateTime.parse(json['perbulan']);
    totalPembelian = json['total_pembelian'];
    totalTransaksi = json['total_transaksi'];
  }
}
