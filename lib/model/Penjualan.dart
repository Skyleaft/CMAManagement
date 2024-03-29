import 'dart:convert';
import 'package:cma_management/model/Customer.dart';
import 'package:cma_management/model/DetailPenjualan.dart';
import 'package:cma_management/model/Suplier.dart';
import 'package:cma_management/services/customer_services.dart';
import 'package:flutter_guid/flutter_guid.dart';

class Penjualan {
  final Guid id;
  final DateTime jatuh_tempo;
  final String no_faktur;
  final DateTime tanggal;
  final Guid customerID;
  final Customer? customer;
  final List<DetailPenjualan?>? detailPenjualan;
  final String? created_at;
  final String? updated_at;
  final String? deleted_at;

  const Penjualan(
      {required this.id,
      required this.jatuh_tempo,
      required this.no_faktur,
      required this.customerID,
      required this.tanggal,
      this.customer,
      this.detailPenjualan,
      this.created_at,
      this.updated_at,
      this.deleted_at});

  factory Penjualan.fromJson(Map<String, dynamic> json) {
    return Penjualan(
      id: new Guid(json["id"]),
      jatuh_tempo: DateTime.parse(json["jatuh_tempo"]),
      no_faktur: json["no_faktur"],
      tanggal: DateTime.parse(json["tanggal"]),
      customerID: new Guid(json["customerID"]),
      customer:
          json["customer"] == null ? null : Customer.fromJson(json["customer"]),
      detailPenjualan: json["detailPenjualan"] == null
          ? null
          : List<DetailPenjualan>.from(
              json["detailPenjualan"].map((x) => DetailPenjualan.fromJson(x))),
      created_at: json["created_at"],
      updated_at: json["updated_at"],
      deleted_at: json["deleted_at"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id.value,
      "jatuh_tempo": "${jatuh_tempo.toIso8601String()}Z",
      "no_faktur": no_faktur,
      "tanggal": "${tanggal.toIso8601String()}Z",
      "customerID": customerID.value,
      "created_at": created_at,
      "updated_at": updated_at,
      "deleted_at": deleted_at
    };
  }
}

List<Penjualan> produkFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Penjualan>.from(data.map((item) => Penjualan.fromJson(item)));
}

String produkToJson(Penjualan data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
