import 'dart:convert';

import 'package:flutter_guid/flutter_guid.dart';

class Suplier {
  final Guid id;
  final String nama_suplier;
  final String? alamat;
  final String? no_telp;
  final String? created_at;
  final String? updated_at;
  final String? deleted_at;

  const Suplier(
      {required this.id,
      required this.nama_suplier,
      this.alamat,
      this.no_telp,
      this.created_at,
      this.updated_at,
      this.deleted_at});

  factory Suplier.fromJson(Map<String, dynamic> json) {
    return Suplier(
      id: new Guid(json["id"]),
      nama_suplier: json["nama_suplier"],
      alamat: json["alamat"],
      no_telp: json["no_telp"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
      deleted_at: json["deleted_at"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id.value,
      "nama_suplier": nama_suplier,
      "alamat": alamat,
      "no_telp": no_telp,
      "created_at": created_at,
      "updated_at": updated_at,
      "deleted_at": deleted_at
    };
  }
}

List<Suplier> produkFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Suplier>.from(data.map((item) => Suplier.fromJson(item)));
}

String produkToJson(Suplier data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
