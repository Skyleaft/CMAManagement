import 'dart:convert';
import 'package:cma_management/config/global_config.dart';
import 'package:cma_management/model/DetailPembelian.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:http/http.dart' as http;

class DetailPembelianService {
  static const String detailPembeliansUrl =
      '${GlobalConfig.base_url}/api/DetPembelian';

  Future<List<DetailPembelian>> getDetailPembelians() async {
    final response = await http.get(
      Uri.parse(detailPembeliansUrl),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> detailPembeliansJson = jsonDecode(response.body);
      return detailPembeliansJson
          .map((json) => DetailPembelian.fromJson(json))
          .toList();
    } else {
      throw Exception('${response.body} Failed to load detailPembelians');
    }
  }

  Future<List<DetailPembelian>> getByPembelian(String idPembelian) async {
    final response = await http.get(
      Uri.parse('${detailPembeliansUrl}/Pembelian?_idPembelian=$idPembelian'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> detailPembeliansJson = jsonDecode(response.body);
      return detailPembeliansJson
          .map((json) => DetailPembelian.fromJson(json))
          .toList();
    } else {
      throw Exception('${response.body} Failed to load detailPembelians');
    }
  }

  Future<DetailPembelian> getDetailPembelian(String id) async {
    final response = await http.get(
      Uri.parse('$detailPembeliansUrl/$id'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode == 200) {
      final dynamic detailPembelianJson = jsonDecode(response.body);
      return DetailPembelian.fromJson(detailPembelianJson);
    } else {
      throw Exception('${response.body} Failed to load detailPembelian');
    }
  }

  Future<DetailPembelian> createDetailPembelian(
      DetailPembelian detailPembelian) async {
    final response = await http.post(
      Uri.parse(detailPembeliansUrl),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
      body: jsonEncode(detailPembelian.toJson()),
    );
    if (response.statusCode == 201) {
      return detailPembelian;
    } else {
      throw Exception('${response.body} failed to create detailPembelian');
    }
  }

  Future<DetailPembelian> updateDetailPembelian(
      String id, DetailPembelian detailPembelian) async {
    final response = await http.put(
      Uri.parse('$detailPembeliansUrl/$id'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
      body: jsonEncode(detailPembelian.toJson()),
    );
    if (response.statusCode == 200) {
      return detailPembelian;
    } else {
      throw Exception('${response.body} Failed to update detailPembelian');
    }
  }

  Future<void> deleteDetailPembelian(String id) async {
    final response = await http.delete(
      Uri.parse('$detailPembeliansUrl/$id'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('${response.body} Failed to delete detailPembelian');
    }
  }
}
