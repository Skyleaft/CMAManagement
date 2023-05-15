import 'dart:convert';
import 'package:cma_management/config/global_config.dart';
import 'package:cma_management/model/FakturPenjualan.dart';
import 'package:cma_management/model/Penjualan.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:http/http.dart' as http;

class PenjualanService {
  static const String penjualansUrl = '${GlobalConfig.base_url}/api/penjualan';

  Future<List<Penjualan>> getPenjualans() async {
    final response = await http.get(
      Uri.parse(penjualansUrl),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> penjualansJson = jsonDecode(response.body);
      return penjualansJson.map((json) => Penjualan.fromJson(json)).toList();
    } else {
      throw Exception('${response.body} Failed to load penjualans');
    }
  }

  Future<Penjualan> getPenjualan(String id) async {
    final response = await http.get(
      Uri.parse('$penjualansUrl/$id'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode == 200) {
      final dynamic penjualanJson = jsonDecode(response.body);
      return Penjualan.fromJson(penjualanJson);
    } else {
      throw Exception('${response.body} Failed to load penjualan');
    }
  }

  Future<Penjualan?> getLatestPenjualan() async {
    final response = await http.get(
      Uri.parse('$penjualansUrl/latest'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode == 200) {
      final dynamic penjualanJson = jsonDecode(response.body);
      return Penjualan.fromJson(penjualanJson);
    } else if (response.statusCode == 204) {
      return null;
    } else {
      throw Exception('${response.body} Failed to load penjualan');
    }
  }

  Future<List<FakturPenjualan?>> getFakturPenjualans() async {
    final response = await http.get(
      Uri.parse('$penjualansUrl/faktur'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> penjualansJson = jsonDecode(response.body);
      return penjualansJson
          .map((json) => FakturPenjualan.fromJson(json))
          .toList();
    } else {
      throw Exception('${response.body} Failed to load penjualan');
    }
  }

  Future<FakturPenjualan?> getFakturPenjualan(String id) async {
    final response = await http.get(
      Uri.parse('$penjualansUrl/faktur/${id}'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode == 200) {
      final dynamic penjualanJson = jsonDecode(response.body);
      return FakturPenjualan.fromJson(penjualanJson);
    } else if (response.statusCode == 204) {
      return null;
    } else {
      throw Exception('${response.body} Failed to load penjualan');
    }
  }

  Future<Penjualan> createPenjualan(Penjualan penjualan) async {
    final response = await http.post(
      Uri.parse(penjualansUrl),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
      body: jsonEncode(penjualan.toJson()),
    );
    if (response.statusCode == 201) {
      return penjualan;
    } else {
      throw Exception('${response.body} failed to create penjualan');
    }
  }

  Future<Penjualan> updatePenjualan(String id, Penjualan penjualan) async {
    final response = await http.put(
      Uri.parse('$penjualansUrl/$id'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
      body: jsonEncode(penjualan.toJson()),
    );
    if (response.statusCode == 200) {
      return penjualan;
    } else {
      throw Exception('${response.body} Failed to update penjualan');
    }
  }

  Future<void> deletePenjualan(String id) async {
    final response = await http.delete(
      Uri.parse('$penjualansUrl/$id'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('${response.body} Failed to delete penjualan');
    }
  }
}
