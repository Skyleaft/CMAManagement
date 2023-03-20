import 'dart:convert';
import 'package:cma_management/config/global_config.dart';
import 'package:cma_management/model/DetailPenjualan.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:http/http.dart' as http;

class DetailPenjualanService {
  static const String detailPenjualansUrl =
      '${GlobalConfig.base_url}/api/DetPenjualan';

  Future<List<DetailPenjualan>> getDetailPenjualans() async {
    final response = await http.get(
      Uri.parse(detailPenjualansUrl),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> detailPenjualansJson = jsonDecode(response.body);
      return detailPenjualansJson
          .map((json) => DetailPenjualan.fromJson(json))
          .toList();
    } else {
      throw Exception('${response.body} Failed to load detailPenjualans');
    }
  }

  Future<List<DetailPenjualan>> getByPenjualan(String idPenjualan) async {
    final response = await http.get(
      Uri.parse('${detailPenjualansUrl}/Penjualan?_idPenjualan=$idPenjualan'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> detailPenjualansJson = jsonDecode(response.body);
      return detailPenjualansJson
          .map((json) => DetailPenjualan.fromJson(json))
          .toList();
    } else {
      throw Exception('${response.body} Failed to load detailPenjualans');
    }
  }

  Future<DetailPenjualan> getDetailPenjualan(String id) async {
    final response = await http.get(
      Uri.parse('$detailPenjualansUrl/$id'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode == 200) {
      final dynamic detailPenjualanJson = jsonDecode(response.body);
      return DetailPenjualan.fromJson(detailPenjualanJson);
    } else {
      throw Exception('${response.body} Failed to load detailPenjualan');
    }
  }

  Future<DetailPenjualan> createDetailPenjualan(
      DetailPenjualan detailPenjualan) async {
    final response = await http.post(
      Uri.parse(detailPenjualansUrl),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
      body: jsonEncode(detailPenjualan.toJson()),
    );
    if (response.statusCode == 201) {
      return detailPenjualan;
    } else {
      throw Exception('${response.body} failed to create detailPenjualan');
    }
  }

  Future<DetailPenjualan> updateDetailPenjualan(
      String id, DetailPenjualan detailPenjualan) async {
    final response = await http.put(
      Uri.parse('$detailPenjualansUrl/$id'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
      body: jsonEncode(detailPenjualan.toJson()),
    );
    if (response.statusCode == 200) {
      return detailPenjualan;
    } else {
      throw Exception('${response.body} Failed to update detailPenjualan');
    }
  }

  Future<void> deleteDetailPenjualan(String id) async {
    final response = await http.delete(
      Uri.parse('$detailPenjualansUrl/$id'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('${response.body} Failed to delete detailPenjualan');
    }
  }
}
