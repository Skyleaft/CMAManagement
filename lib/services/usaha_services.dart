import 'dart:convert';
import 'package:cma_management/model/Usaha.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:http/http.dart' as http;

class UsahaService {
  static const String baseUrl = 'https://faktur.cybercode.id';
  //static const String baseUrl = 'http://10.10.10.99:5153';
  static const String usahasUrl = '$baseUrl/api/usaha';

  Future<List<Usaha>> getUsahas() async {
    final response = await http.get(Uri.parse(usahasUrl));
    if (response.statusCode == 200) {
      final List<dynamic> usahasJson = jsonDecode(response.body);
      return usahasJson.map((json) => Usaha.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load usahas');
    }
  }

  Future<Usaha> getUsaha(String id) async {
    final response = await http.get(Uri.parse('$usahasUrl/$id'));
    if (response.statusCode == 200) {
      final dynamic usahaJson = jsonDecode(response.body);
      return Usaha.fromJson(usahaJson);
    } else {
      throw Exception('Failed to load usaha');
    }
  }

  Future<Usaha> createUsaha(Usaha usaha) async {
    final response = await http.post(
      Uri.parse(usahasUrl),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(usaha.toJson()),
    );
    if (response.statusCode == 201) {
      final dynamic usahaJson = jsonDecode(response.body);
      return Usaha.fromJson(usahaJson);
    } else {
      throw Exception('${usaha.toJson()} failed to create usaha');
    }
  }

  Future<Usaha> updateUsaha(String id, Usaha usaha) async {
    final response = await http.put(
      Uri.parse('$usahasUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(usaha.toJson()),
    );
    if (response.statusCode == 200) {
      final dynamic usahaJson = jsonDecode(response.body);
      return Usaha.fromJson(usahaJson);
    } else {
      throw Exception('Failed to update usaha');
    }
  }

  Future<void> deleteUsaha(String id) async {
    final response = await http.delete(Uri.parse('$usahasUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete usaha');
    }
  }
}
