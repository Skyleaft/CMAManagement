import 'dart:convert';
import 'package:cma_management/config/global_config.dart';
import 'package:cma_management/model/Barang.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:http/http.dart' as http;

class BarangService {
  static const String barangsUrl = '${GlobalConfig.base_url}/api/barang';

  Future<List<Barang>> getBarangs() async {
    final response = await http.get(
      Uri.parse(barangsUrl),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> barangsJson = jsonDecode(response.body);
      return barangsJson.map((json) => Barang.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load barangs');
    }
  }

  Future<Barang> getBarang(String id) async {
    final response = await http.get(
      Uri.parse('$barangsUrl/$id'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode == 200) {
      final dynamic barangJson = jsonDecode(response.body);
      return Barang.fromJson(barangJson);
    } else {
      throw Exception('Failed to load barang');
    }
  }

  Future<Barang> createBarang(Barang barang) async {
    final response = await http.post(
      Uri.parse(barangsUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
      body: jsonEncode(barang.toJson()),
    );
    if (response.statusCode == 201) {
      return barang;
    } else {
      throw Exception('${response.body} failed to create barang');
    }
  }

  Future<Barang> updateBarang(String id, Barang barang) async {
    final response = await http.put(
      Uri.parse('$barangsUrl/$id'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
      body: jsonEncode(barang.toJson()),
    );
    if (response.statusCode == 200) {
      return barang;
    } else {
      throw Exception('Failed to update barang');
    }
  }

  Future<void> deleteBarang(String id) async {
    final response = await http.delete(
      Uri.parse('$barangsUrl/$id'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete barang');
    }
  }
}
