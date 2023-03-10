import 'dart:convert';

import 'package:flutter_guid/flutter_guid.dart';

class Customer {
  final Guid id;
  final String nama_customer;
  final String? alamat;
  final String? no_telp;
  final String? created_at;
  final String? updated_at;
  final String? deleted_at;

  const Customer(
      {required this.id,
      required this.nama_customer,
      this.alamat,
      this.no_telp,
      this.created_at,
      this.updated_at,
      this.deleted_at});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: new Guid(json["id"]),
      nama_customer: json["nama_customer"],
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
      "nama_customer": nama_customer,
      "alamat": alamat,
      "no_telp": no_telp,
      "created_at": created_at,
      "updated_at": updated_at,
      "deleted_at": deleted_at
    };
  }
}

List<Customer> produkFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Customer>.from(data.map((item) => Customer.fromJson(item)));
}

String produkToJson(Customer data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
