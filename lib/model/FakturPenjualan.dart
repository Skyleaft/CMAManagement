import 'package:flutter_guid/flutter_guid.dart';

class FakturPenjualan {
  Guid id;
  String? faktur;
  String? tanggal;
  String? status;
  int? total;
  int? jumlahBarang;
  String? namaSuplier;

  FakturPenjualan(
      {required this.id,
      this.faktur,
      this.tanggal,
      this.status,
      this.total,
      this.jumlahBarang,
      this.namaSuplier});

  factory FakturPenjualan.fromJson(Map<String, dynamic> json) {
    return FakturPenjualan(
      id: new Guid(json["id"]),
      faktur: json['faktur'],
      tanggal: json['tanggal'],
      status: json['status'],
      total: json['total'],
      jumlahBarang: json['jumlah_barang'],
      namaSuplier: json['nama_suplier'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['faktur'] = this.faktur;
    data['tanggal'] = this.tanggal;
    data['status'] = this.status;
    data['total'] = this.total;
    data['jumlah_barang'] = this.jumlahBarang;
    data['nama_suplier'] = this.namaSuplier;
    return data;
  }
}
