import 'dart:convert';

import 'package:flutter_guid/flutter_guid.dart';

class Usaha {
  final Guid id;
  final String nama_usaha;
  final String? keterangan;
  final String? created_at;
  final String? updated_at;
  final String? deleted_at;

  const Usaha(
      {required this.id,
      required this.nama_usaha,
      this.keterangan,
      this.created_at,
      this.updated_at,
      this.deleted_at});

  factory Usaha.fromJson(Map<String, dynamic> json) {
    return Usaha(
      id: new Guid(json["id"]),
      nama_usaha: json["nama_usaha"],
      keterangan: json["keterangan"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
      deleted_at: json["deleted_at"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nama_usaha": nama_usaha,
      "keterangan": keterangan,
      "created_at": created_at,
      "updated_at": updated_at,
      "deleted_at": deleted_at
    };
  }
}

List<Usaha> usahaFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Usaha>.from(data.map((item) => Usaha.fromJson(item)));
}

String usahaToJson(Usaha data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
