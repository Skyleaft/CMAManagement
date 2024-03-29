import 'dart:convert';
import 'package:cma_management/config/global_config.dart';
import 'package:cma_management/model/Produk.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:http/http.dart' as http;

class ProdukService {
  static const String produksUrl = '${GlobalConfig.base_url}/api/produk';

  Future<List<Produk>> getProduks() async {
    final response = await http.get(
      Uri.parse(produksUrl),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> produksJson = jsonDecode(response.body);
      return produksJson.map((json) => Produk.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load produks');
    }
  }

  Future<Produk> getProduk(String id) async {
    final response = await http.get(
      Uri.parse('$produksUrl/$id'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode == 200) {
      final dynamic produkJson = jsonDecode(response.body);
      return Produk.fromJson(produkJson);
    } else {
      throw Exception('Failed to load produk');
    }
  }

  Future<Produk> createProduk(Produk produk) async {
    final response = await http.post(
      Uri.parse(produksUrl),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
      body: jsonEncode(produk.toJson()),
    );
    if (response.statusCode == 201) {
      return produk;
    } else {
      throw Exception('${response.body} failed to create produk');
    }
  }

  Future<Produk> updateProduk(String id, Produk produk) async {
    final response = await http.put(
      Uri.parse('$produksUrl/$id'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
      body: jsonEncode(produk.toJson()),
    );
    if (response.statusCode == 200) {
      return produk;
    } else {
      throw Exception('Failed to update produk');
    }
  }

  Future<void> deleteProduk(String id) async {
    final response = await http.delete(
      Uri.parse('$produksUrl/$id'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete produk');
    }
  }
}
