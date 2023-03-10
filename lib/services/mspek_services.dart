import 'dart:convert';
import 'package:cma_management/config/global_config.dart';
import 'package:cma_management/model/MSpek.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:http/http.dart' as http;

class MSpekService {
  static const String M_speksUrl = '${GlobalConfig.base_url}/api/M_spek';

  Future<List<MSpek>> getMSpeks() async {
    final response = await http.get(Uri.parse(M_speksUrl));
    if (response.statusCode == 200) {
      final List<dynamic> M_speksJson = jsonDecode(response.body);
      return M_speksJson.map((json) => MSpek.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load M_speks');
    }
  }

  Future<MSpek> getMSpek(String id) async {
    final response = await http.get(Uri.parse('$M_speksUrl/$id'));
    if (response.statusCode == 200) {
      final dynamic M_spekJson = jsonDecode(response.body);
      return MSpek.fromJson(M_spekJson);
    } else {
      throw Exception('Failed to load M_spek');
    }
  }

  Future<MSpek> createMSpek(MSpek M_spek) async {
    final response = await http.post(
      Uri.parse(M_speksUrl),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(M_spek.toJson()),
    );
    if (response.statusCode == 201) {
      final dynamic M_spekJson = jsonDecode(response.body);
      return MSpek.fromJson(M_spekJson);
    } else {
      throw Exception('${M_spek.toJson()} failed to create M_spek');
    }
  }

  Future<MSpek> updateMSpek(String id, MSpek M_spek) async {
    final response = await http.put(
      Uri.parse('$M_speksUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(M_spek.toJson()),
    );
    if (response.statusCode == 200) {
      final dynamic M_spekJson = jsonDecode(response.body);
      return MSpek.fromJson(M_spekJson);
    } else {
      throw Exception('Failed to update M_spek');
    }
  }

  Future<void> deleteMSpek(String id) async {
    final response = await http.delete(Uri.parse('$M_speksUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete M_spek');
    }
  }
}
