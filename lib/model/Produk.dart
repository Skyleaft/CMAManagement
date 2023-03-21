import 'dart:convert';

import 'package:cma_management/model/Usaha.dart';
import 'package:flutter_guid/flutter_guid.dart';

class Produk {
  final Guid id;
  final Guid usahaID;
  final String nama_produk;
  final String? keterangan;
  final Usaha? usaha;
  final String? created_at;
  final String? updated_at;
  final String? deleted_at;

  const Produk(
      {required this.id,
      required this.usahaID,
      required this.nama_produk,
      this.keterangan,
      this.usaha,
      this.created_at,
      this.updated_at,
      this.deleted_at});

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: new Guid(json["id"]),
      usahaID: new Guid(json["usahaID"]),
      nama_produk: json["nama_produk"],
      keterangan: json["keterangan"],
      usaha: json["usaha"] == null ? null : Usaha.fromJson(json["usaha"]),
      created_at: json["created_at"],
      updated_at: json["updated_at"],
      deleted_at: json["deleted_at"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id.value,
      "usahaID": usahaID.value,
      "nama_produk": nama_produk,
      "keterangan": keterangan,
      "created_at": created_at,
      "updated_at": updated_at,
      "deleted_at": deleted_at
    };
  }
}

List<Produk> produkFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Produk>.from(data.map((item) => Produk.fromJson(item)));
}

String produkToJson(Produk data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
