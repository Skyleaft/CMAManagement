import 'dart:convert';
import 'package:flutter_guid/flutter_guid.dart';

class Barang {
  final Guid id;
  final Guid produkID;
  final Guid suplierID;
  final String nama_barang;
  final String? created_at;
  final String? updated_at;
  final String? deleted_at;

  const Barang(
      {required this.id,
      required this.produkID,
      required this.suplierID,
      required this.nama_barang,
      this.created_at,
      this.updated_at,
      this.deleted_at});

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      id: new Guid(json["id"]),
      produkID: new Guid(json["produkID"]),
      suplierID: new Guid(json["suplierID"]),
      nama_barang: json["nama_barang"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
      deleted_at: json["deleted_at"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id.value,
      "produkID": produkID.value,
      "suplierID": suplierID.value,
      "nama_barang": nama_barang,
      "created_at": created_at,
      "updated_at": updated_at,
      "deleted_at": deleted_at
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
