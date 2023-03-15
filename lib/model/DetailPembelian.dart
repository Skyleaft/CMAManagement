import 'dart:convert';
import 'package:cma_management/model/Barang.dart';
import 'package:cma_management/model/Speksifikasi.dart';
import 'package:flutter_guid/flutter_guid.dart';

class DetailPembelian {
  final Guid id;
  final Guid barangID;
  final Guid pembelianID;
  final int qty;
  final int harga_beli;
  final Barang? barang;
  final DateTime? created_at;
  final DateTime? updated_at;
  final DateTime? deleted_at;

  const DetailPembelian(
      {required this.id,
      required this.barangID,
      required this.pembelianID,
      required this.qty,
      required this.harga_beli,
      this.barang,
      this.created_at,
      this.updated_at,
      this.deleted_at});

  factory DetailPembelian.fromJson(Map<String, dynamic> json) {
    return DetailPembelian(
      id: new Guid(json["id"]),
      barangID: new Guid(json["barangID"]),
      pembelianID: new Guid(json["pembelianID"]),
      qty: json["qty"],
      harga_beli: json["harga_beli"],
      barang: Barang?.fromJson(json["barang"]),
      created_at: DateTime.tryParse(json["created_at"].toString()),
      updated_at: DateTime.tryParse(json["updated_at"].toString()),
      deleted_at: DateTime.tryParse(json["deleted_at"].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id.value,
      "barangID": barangID.value,
      "pembelianID": pembelianID.value,
      "qty": qty,
      "harga_beli": harga_beli,
      "created_at": created_at?.toUtc().toIso8601String(),
      "updated_at": updated_at?.toUtc().toIso8601String(),
      "deleted_at": deleted_at?.toUtc().toIso8601String(),
    };
  }
}

List<DetailPembelian> produkFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<DetailPembelian>.from(
      data.map((item) => DetailPembelian.fromJson(item)));
}

String produkToJson(DetailPembelian data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
