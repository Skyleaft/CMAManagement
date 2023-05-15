import 'dart:convert';
import 'dart:ffi';
import 'package:cma_management/model/Barang.dart';
import 'package:cma_management/model/Speksifikasi.dart';
import 'package:cma_management/utils/MoneyFormat.dart';
import 'package:cma_management/utils/noti.dart';
import 'package:flutter_guid/flutter_guid.dart';

class DetailPenjualan {
  final Guid id;
  final Guid barangID;
  final Guid penjualanID;
  final int qty;
  final int harga_jual;
  final int? panjang;
  final Barang? barang;
  final String? keterangan;
  final DateTime? created_at;
  final DateTime? updated_at;
  final DateTime? deleted_at;

  const DetailPenjualan(
      {required this.id,
      required this.barangID,
      required this.penjualanID,
      required this.qty,
      required this.harga_jual,
      this.panjang,
      this.barang,
      this.keterangan,
      this.created_at,
      this.updated_at,
      this.deleted_at});

  factory DetailPenjualan.fromJson(Map<String, dynamic> json) {
    return DetailPenjualan(
      id: new Guid(json["id"]),
      barangID: new Guid(json["barangID"]),
      penjualanID: new Guid(json["penjualanID"]),
      qty: json["qty"],
      harga_jual: json["harga_jual"],
      panjang: json["panjang"],
      barang: json["barang"] == null ? null : Barang?.fromJson(json["barang"]),
      keterangan: json["keterangan"],
      created_at: DateTime.tryParse(json["created_at"].toString()),
      updated_at: DateTime.tryParse(json["updated_at"].toString()),
      deleted_at: DateTime.tryParse(json["deleted_at"].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id.value,
      "barangID": barangID.value,
      "penjualanID": penjualanID.value,
      "qty": qty,
      "harga_jual": harga_jual,
      "panjang": panjang,
      "keterangan": keterangan,
      "created_at": created_at?.toUtc().toIso8601String(),
      "updated_at": updated_at?.toUtc().toIso8601String(),
      "deleted_at": deleted_at?.toUtc().toIso8601String(),
    };
  }

  String getIndex(int index, int row) {
    switch (index) {
      case 0:
        return row.toString();
      case 1:
        return barang!.nama_barang;
      case 2:
        return MoneyFormat().rupiah(double.parse(harga_jual.toString()));
      case 3:
        return qty.toString();
      case 4:
        return panjang.toString();
      case 5:
        return MoneyFormat()
            .rupiah(double.parse((harga_jual * panjang!).toString()));
    }
    return '';
  }
}

List<DetailPenjualan> produkFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<DetailPenjualan>.from(
      data.map((item) => DetailPenjualan.fromJson(item)));
}

String produkToJson(DetailPenjualan data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
