import 'dart:convert';
import 'package:cma_management/config/global_config.dart';
import 'package:cma_management/model/Stok.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:http/http.dart' as http;

class StokService {
  static const String stoksUrl = '${GlobalConfig.base_url}/api/Stok';

  Future<List<Stok>> getStoks() async {
    final response = await http.get(
      Uri.parse(stoksUrl),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> stoksJson = jsonDecode(response.body);
      return stoksJson.map((json) => Stok.fromJson(json)).toList();
    } else {
      throw Exception('${response.body} Failed to load stoks');
    }
  }

  Future<Stok> getStok(String id) async {
    final response = await http.get(
      Uri.parse('$stoksUrl/$id'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode == 200) {
      final dynamic stokJson = jsonDecode(response.body);
      return Stok.fromJson(stokJson);
    } else {
      throw Exception('${response.body} Failed to load stok');
    }
  }

  Future<Stok?> getStokByBarang(String id) async {
    final response = await http.get(
      Uri.parse('$stoksUrl/barang?barangID=$id'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode == 200) {
      final dynamic stokJson = jsonDecode(response.body);
      return Stok.fromJson(stokJson);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('${response.body} Failed to load stok');
    }
  }

  Future<Stok> createStok(Stok stok) async {
    final response = await http.post(
      Uri.parse(stoksUrl),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
      body: jsonEncode(stok.toJson()),
    );
    if (response.statusCode == 201) {
      return stok;
    } else {
      throw Exception('${response.body} failed to create stok');
    }
  }

  Future<Stok> addStok(Stok stok) async {
    final response = await http.post(
      Uri.parse('$stoksUrl/add'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
      body: jsonEncode(stok.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return stok;
    } else {
      throw Exception('${response.body} failed to create stok');
    }
  }

  Future<Stok> minStok(Stok stok) async {
    final response = await http.put(
      Uri.parse('$stoksUrl/min'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
      body: jsonEncode(stok.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return stok;
    } else {
      throw Exception('${response.body} failed to create stok');
    }
  }

  Future<Stok> updateStok(String id, Stok stok) async {
    final response = await http.put(
      Uri.parse('$stoksUrl/$id'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
      body: jsonEncode(stok.toJson()),
    );
    if (response.statusCode == 200) {
      return stok;
    } else {
      throw Exception('${response.body} Failed to update stok');
    }
  }

  Future<void> deleteStok(String id) async {
    final response = await http.delete(
      Uri.parse('$stoksUrl/$id'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('${response.body} Failed to delete stok');
    }
  }

  Future<void> deleteStokbyPembelian(String idPembelian) async {
    final response = await http.delete(
      Uri.parse('$stoksUrl/pembelian/$idPembelian'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('${response.body} Failed to delete stok');
    }
  }
}
