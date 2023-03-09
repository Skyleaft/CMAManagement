import 'dart:convert';

import 'package:flutter_guid/flutter_guid.dart';

class Speksifikasi {
  final Guid id;
  final Guid id_mspek;
  final Guid id_barang;
  final String value;
  final String? created_at;
  final String? updated_at;
  final String? deleted_at;

  const Speksifikasi(
      {required this.id,
      required this.id_mspek,
      required this.id_barang,
      required this.value,
      this.created_at,
      this.updated_at,
      this.deleted_at});

  factory Speksifikasi.fromJson(Map<String, dynamic> json) {
    return Speksifikasi(
      id: new Guid(json["id"]),
      id_barang: new Guid(json["id_barang"]),
      id_mspek: new Guid(json["id_mspek"]),
      value: json["value"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
      deleted_at: json["deleted_at"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id.value,
      "id_barang": id_barang,
      "id_mspek": id_mspek,
      "value": value,
      "created_at": created_at,
      "updated_at": updated_at,
      "deleted_at": deleted_at
    };
  }
}

List<Speksifikasi> speksifikasiFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Speksifikasi>.from(
      data.map((item) => Speksifikasi.fromJson(item)));
}

String speksifikasiToJson(Speksifikasi data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
