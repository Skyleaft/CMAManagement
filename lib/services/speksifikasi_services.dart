import 'dart:convert';
import 'package:cma_management/config/global_config.dart';
import 'package:cma_management/model/Speksifikasi.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:http/http.dart' as http;

class SpeksifikasiService {
  static const String speksifikasisUrl =
      '${GlobalConfig.base_url}/api/speksifikasi';

  Future<List<Speksifikasi>> getSpeksifikasis() async {
    final response = await http.get(
      Uri.parse(speksifikasisUrl),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> speksifikasisJson = jsonDecode(response.body);
      return speksifikasisJson
          .map((json) => Speksifikasi.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load speksifikasis');
    }
  }

  Future<Speksifikasi> getSpeksifikasi(String id) async {
    final response = await http.get(
      Uri.parse('$speksifikasisUrl/$id'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode == 200) {
      final dynamic speksifikasiJson = jsonDecode(response.body);
      return Speksifikasi.fromJson(speksifikasiJson);
    } else {
      throw Exception('Failed to load speksifikasi');
    }
  }

  Future<Speksifikasi> createSpeksifikasi(Speksifikasi speksifikasi) async {
    final response = await http.post(
      Uri.parse(speksifikasisUrl),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
      body: jsonEncode(speksifikasi.toJson()),
    );
    if (response.statusCode == 201) {
      final dynamic speksifikasiJson = jsonDecode(response.body);
      return Speksifikasi.fromJson(speksifikasiJson);
    } else {
      throw Exception('${response.body} failed to create speksifikasi');
    }
  }

  Future<Speksifikasi> updateSpeksifikasi(
      String id, Speksifikasi speksifikasi) async {
    final response = await http.put(
      Uri.parse('$speksifikasisUrl/$id'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
      body: jsonEncode(speksifikasi.toJson()),
    );
    if (response.statusCode == 200) {
      final dynamic speksifikasiJson = jsonDecode(response.body);
      return Speksifikasi.fromJson(speksifikasiJson);
    } else {
      throw Exception('Failed to update speksifikasi');
    }
  }

  Future<void> deleteSpeksifikasi(String id) async {
    final response = await http.delete(
      Uri.parse('$speksifikasisUrl/$id'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete speksifikasi');
    }
  }
}
