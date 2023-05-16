import 'dart:convert';
import 'package:cma_management/config/global_config.dart';
import 'package:cma_management/model/BarPembelian.dart';
import 'package:cma_management/model/BarPenjualan.dart';
import 'package:cma_management/model/DashbordData.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:http/http.dart' as http;

class DashboardService {
  static const String dashboardUrl =
      '${GlobalConfig.base_url}/api/DashboardData';

  Future<DashboardData> getDashboards() async {
    final response = await http.get(
      Uri.parse(dashboardUrl),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode == 200) {
      final dynamic dashboardJson = jsonDecode(response.body);
      return DashboardData.fromJson(dashboardJson);
    } else {
      throw Exception('${response.body} Failed to load dashboard');
    }
  }

  Future<List<BarPenjualan>> getBarPenjualan() async {
    final response = await http.get(
      Uri.parse('${dashboardUrl}/barPenjualan'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> dashboardJson = jsonDecode(response.body);
      return dashboardJson.map((json) => BarPenjualan.fromJson(json)).toList();
    } else {
      throw Exception('${response.body} Failed to load dashboard');
    }
  }

  Future<List<BarPembelian>> getBarPembelian() async {
    final response = await http.get(
      Uri.parse('${dashboardUrl}/barPembelian'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> dashboardJson = jsonDecode(response.body);
      return dashboardJson.map((json) => BarPembelian.fromJson(json)).toList();
    } else {
      throw Exception('${response.body} Failed to load dashboard');
    }
  }
}
