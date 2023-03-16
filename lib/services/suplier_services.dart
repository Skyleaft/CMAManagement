import 'dart:convert';
import 'package:cma_management/config/global_config.dart';
import 'package:cma_management/model/Suplier.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:http/http.dart' as http;

class SuplierService {
  static const String supliersUrl = '${GlobalConfig.base_url}/api/suplier';

  Future<List<Suplier>> getSupliers() async {
    final response = await http.get(
      Uri.parse(supliersUrl),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> supliersJson = jsonDecode(response.body);
      return supliersJson.map((json) => Suplier.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load supliers');
    }
  }

  Future<Suplier> getSuplier(String id) async {
    final response = await http.get(
      Uri.parse('$supliersUrl/$id'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode == 200) {
      final dynamic suplierJson = jsonDecode(response.body);
      return Suplier.fromJson(suplierJson);
    } else {
      throw Exception('Failed to load suplier');
    }
  }

  Future<Suplier> createSuplier(Suplier suplier) async {
    final response = await http.post(
      Uri.parse(supliersUrl),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
      body: jsonEncode(suplier.toJson()),
    );
    if (response.statusCode == 201) {
      return suplier;
    } else {
      throw Exception('${suplier.toJson()} failed to create suplier');
    }
  }

  Future<Suplier> updateSuplier(String id, Suplier suplier) async {
    final response = await http.put(
      Uri.parse('$supliersUrl/$id'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
      body: jsonEncode(suplier.toJson()),
    );
    if (response.statusCode == 200) {
      return suplier;
    } else {
      throw Exception('Failed to update suplier');
    }
  }

  Future<void> deleteSuplier(String id) async {
    final response = await http.delete(
      Uri.parse('$supliersUrl/$id'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete suplier');
    }
  }
}
