import 'dart:convert';
import 'package:cma_management/model/Barang.dart';
import 'package:cma_management/model/Speksifikasi.dart';
import 'package:flutter_guid/flutter_guid.dart';

class Stok {
  final Guid id;
  final Guid barangID;
  final int jumlah;
  final int panjang;
  final DateTime? created_at;
  final DateTime? updated_at;
  final DateTime? deleted_at;

  const Stok(
      {required this.id,
      required this.barangID,
      required this.panjang,
      required this.jumlah,
      this.created_at,
      this.updated_at,
      this.deleted_at});

  factory Stok.fromJson(Map<String, dynamic> json) {
    return Stok(
      id: new Guid(json["id"]),
      barangID: new Guid(json["barangID"]),
      jumlah: json["jumlah"],
      panjang: json["panjang"],
      created_at: DateTime.tryParse(json["created_at"].toString()),
      updated_at: DateTime.tryParse(json["updated_at"].toString()),
      deleted_at: DateTime.tryParse(json["deleted_at"].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id.value,
      "barangID": barangID.value,
      "jumlah": jumlah,
      "panjang": panjang,
      "created_at": created_at?.toUtc().toIso8601String(),
      "updated_at": updated_at?.toUtc().toIso8601String(),
      "deleted_at": deleted_at?.toUtc().toIso8601String(),
    };
  }
}

List<Stok> produkFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Stok>.from(data.map((item) => Stok.fromJson(item)));
}

String produkToJson(Stok data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
