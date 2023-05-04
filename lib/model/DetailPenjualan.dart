import 'dart:convert';
import 'package:cma_management/model/Barang.dart';
import 'package:cma_management/model/Speksifikasi.dart';
import 'package:flutter_guid/flutter_guid.dart';

class DetailPenjualan {
  final Guid id;
  final Guid barangID;
  final Guid penjualanID;
  final int qty;
  final int harga_jual;
  final int? panjang;
  final Barang? barang;
  final String? keterangan;
  final DateTime? created_at;
  final DateTime? updated_at;
  final DateTime? deleted_at;

  const DetailPenjualan(
      {required this.id,
      required this.barangID,
      required this.penjualanID,
      required this.qty,
      required this.harga_jual,
      this.panjang,
      this.barang,
      this.keterangan,
      this.created_at,
      this.updated_at,
      this.deleted_at});

  factory DetailPenjualan.fromJson(Map<String, dynamic> json) {
    return DetailPenjualan(
      id: new Guid(json["id"]),
      barangID: new Guid(json["barangID"]),
      penjualanID: new Guid(json["penjualanID"]),
      qty: json["qty"],
      harga_jual: json["harga_jual"],
      panjang: json["panjang"],
      barang: json["barang"] == null ? null : Barang?.fromJson(json["barang"]),
      keterangan: json["keterangan"],
      created_at: DateTime.tryParse(json["created_at"].toString()),
      updated_at: DateTime.tryParse(json["updated_at"].toString()),
      deleted_at: DateTime.tryParse(json["deleted_at"].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id.value,
      "barangID": barangID.value,
      "penjualanID": penjualanID.value,
      "qty": qty,
      "harga_jual": harga_jual,
      "panjang": panjang,
      "keterangan": keterangan,
      "created_at": created_at?.toUtc().toIso8601String(),
      "updated_at": updated_at?.toUtc().toIso8601String(),
      "deleted_at": deleted_at?.toUtc().toIso8601String(),
    };
  }
}

List<DetailPenjualan> produkFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<DetailPenjualan>.from(
      data.map((item) => DetailPenjualan.fromJson(item)));
}

String produkToJson(DetailPenjualan data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
