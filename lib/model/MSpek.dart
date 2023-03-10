import 'dart:convert';

import 'package:flutter_guid/flutter_guid.dart';

class MSpek {
  final Guid id;
  final String nama_speksifikasi;
  final String? created_at;
  final String? updated_at;
  final String? deleted_at;

  const MSpek(
      {required this.id,
      required this.nama_speksifikasi,
      this.created_at,
      this.updated_at,
      this.deleted_at});

  factory MSpek.fromJson(Map<String, dynamic> json) {
    return MSpek(
      id: new Guid(json["id"]),
      nama_speksifikasi: json["nama_speksifikasi"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
      deleted_at: json["deleted_at"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id.value,
      "nama_m_spek": nama_speksifikasi,
      "created_at": created_at,
      "updated_at": updated_at,
      "deleted_at": deleted_at
    };
  }
}

List<MSpek> m_spekFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<MSpek>.from(data.map((item) => MSpek.fromJson(item)));
}

String m_spekToJson(MSpek data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
