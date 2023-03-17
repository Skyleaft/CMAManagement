import 'dart:convert';
import 'package:cma_management/model/Speksifikasi.dart';
import 'package:cma_management/model/Stok.dart';
import 'package:flutter_guid/flutter_guid.dart';

class Barang {
  final Guid id;
  final Guid produkID;
  final Stok? stok;
  final List<Speksifikasi?>? speksifikasi;
  final String nama_barang;
  final DateTime? created_at;
  final DateTime? updated_at;
  final DateTime? deleted_at;

  const Barang(
      {required this.id,
      required this.produkID,
      required this.nama_barang,
      this.stok,
      this.speksifikasi,
      this.created_at,
      this.updated_at,
      this.deleted_at});

  factory Barang.fromJson(Map<String, dynamic> json) {
    Stok? newStok;
    if (json['stok'] == null) {
      newStok = null;
    } else {
      newStok = Stok.fromJson(json['stok']);
    }

    return Barang(
      id: new Guid(json["id"]),
      produkID: new Guid(json["produkID"]),
      nama_barang: json["nama_barang"],
      stok: newStok,
      speksifikasi: List<Speksifikasi?>.from(
          json["speksifikasi"].map((x) => Speksifikasi?.fromJson(x))),
      created_at: DateTime.tryParse(json["created_at"].toString()),
      updated_at: DateTime.tryParse(json["updated_at"].toString()),
      deleted_at: DateTime.tryParse(json["deleted_at"].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id.value,
      "produkID": produkID.value,
      "nama_barang": nama_barang,
      "created_at": created_at?.toUtc().toIso8601String(),
      "updated_at": updated_at?.toUtc().toIso8601String(),
      "deleted_at": deleted_at?.toUtc().toIso8601String(),
    };
  }
}

List<Barang> produkFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Barang>.from(data.map((item) => Barang.fromJson(item)));
}

String produkToJson(Barang data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
