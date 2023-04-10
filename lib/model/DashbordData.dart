import 'dart:convert';

import 'package:flutter_guid/flutter_guid.dart';

class DashboardData {
  int? usahaCount;
  int? produkCount;
  int? suplierCount;
  int? customerCount;
  int? barangCount;
  int? stockCount;
  int? pembelianCount;
  int? penjualanCount;

  DashboardData(
      {this.usahaCount,
      this.produkCount,
      this.suplierCount,
      this.customerCount,
      this.barangCount,
      this.stockCount,
      this.pembelianCount,
      this.penjualanCount});

  DashboardData.fromJson(Map<String, dynamic> json) {
    usahaCount = json['usahaCount'];
    produkCount = json['produkCount'];
    suplierCount = json['suplierCount'];
    customerCount = json['customerCount'];
    barangCount = json['barangCount'];
    stockCount = json['stockCount'];
    pembelianCount = json['pembelianCount'];
    penjualanCount = json['penjualanCount'];
  }
}
