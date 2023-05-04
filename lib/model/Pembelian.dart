import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cma_management/model/DetailPembelian.dart';
import 'package:cma_management/model/Suplier.dart';
import 'package:flutter_guid/flutter_guid.dart';

class Pembelian {
  final Guid id;
  final DateTime tanggal;
  final String faktur;
  final Guid suplierID;
  final Suplier? suplier;
  final List<DetailPembelian?>? detailPembelian;
  final String? created_at;
  final String? updated_at;
  final String? deleted_at;

  const Pembelian(
      {required this.id,
      required this.tanggal,
      required this.faktur,
      required this.suplierID,
      this.suplier,
      this.detailPembelian,
      this.created_at,
      this.updated_at,
      this.deleted_at});

  factory Pembelian.fromJson(Map<String, dynamic> json) {
    return Pembelian(
      id: new Guid(json["id"]),
      tanggal: DateTime.parse(json["tanggal"]),
      faktur: json["faktur"],
      suplierID: new Guid(json["suplierID"]),
      suplier:
          json["suplier"] == null ? null : Suplier?.fromJson(json["suplier"]),
      detailPembelian: json["detailPembelian"] == null
          ? null
          : List<DetailPembelian>.from(
              json["detailPembelian"].map((x) => DetailPembelian.fromJson(x))),
      created_at: json["created_at"],
      updated_at: json["updated_at"],
      deleted_at: json["deleted_at"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id.value,
      "tanggal": "${tanggal.toIso8601String()}Z",
      "faktur": faktur,
      "suplierID": suplierID.value,
      "created_at": created_at,
      "updated_at": updated_at,
      "deleted_at": deleted_at
    };
  }
}

List<Pembelian> produkFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Pembelian>.from(data.map((item) => Pembelian.fromJson(item)));
}

String produkToJson(Pembelian data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
