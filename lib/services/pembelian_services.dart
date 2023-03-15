import 'dart:convert';
import 'package:cma_management/config/global_config.dart';
import 'package:cma_management/model/Pembelian.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:http/http.dart' as http;

class PembelianService {
  static const String pembeliansUrl = '${GlobalConfig.base_url}/api/pembelian';

  Future<List<Pembelian>> getPembelians() async {
    final response = await http.get(
      Uri.parse(pembeliansUrl),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> pembeliansJson = jsonDecode(response.body);
      return pembeliansJson.map((json) => Pembelian.fromJson(json)).toList();
    } else {
      throw Exception('${response.body} Failed to load pembelians');
    }
  }

  Future<Pembelian> getPembelian(String id) async {
    final response = await http.get(
      Uri.parse('$pembeliansUrl/$id'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode == 200) {
      final dynamic pembelianJson = jsonDecode(response.body);
      return Pembelian.fromJson(pembelianJson);
    } else {
      throw Exception('${response.body} Failed to load pembelian');
    }
  }

  Future<Pembelian> createPembelian(Pembelian pembelian) async {
    final response = await http.post(
      Uri.parse(pembeliansUrl),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
      body: jsonEncode(pembelian.toJson()),
    );
    if (response.statusCode == 201) {
      final dynamic pembelianJson = jsonDecode(response.body);
      return Pembelian.fromJson(pembelianJson);
    } else {
      throw Exception('${response.body} failed to create pembelian');
    }
  }

  Future<Pembelian> updatePembelian(String id, Pembelian pembelian) async {
    final response = await http.put(
      Uri.parse('$pembeliansUrl/$id'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
      body: jsonEncode(pembelian.toJson()),
    );
    if (response.statusCode == 200) {
      final dynamic pembelianJson = jsonDecode(response.body);
      return Pembelian.fromJson(pembelianJson);
    } else {
      throw Exception('${response.body} Failed to update pembelian');
    }
  }

  Future<void> deletePembelian(String id) async {
    final response = await http.delete(
      Uri.parse('$pembeliansUrl/$id'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('${response.body} Failed to delete pembelian');
    }
  }
}
