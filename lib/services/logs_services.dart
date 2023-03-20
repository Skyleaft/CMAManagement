import 'dart:convert';
import 'package:cma_management/config/global_config.dart';
import 'package:cma_management/model/Logs.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:http/http.dart' as http;

class LogsService {
  static const String logssUrl = '${GlobalConfig.base_url}/api/Logs';

  Future<List<Logs>> getLogs() async {
    final response = await http.get(
      Uri.parse(logssUrl),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> logssJson = jsonDecode(response.body);
      return logssJson.map((json) => Logs.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load logss');
    }
  }

  Future<Logs> getLog(String id) async {
    final response = await http.get(
      Uri.parse('$logssUrl/$id'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode == 200) {
      final dynamic logsJson = jsonDecode(response.body);
      return Logs.fromJson(logsJson);
    } else {
      throw Exception('Failed to load logs');
    }
  }

  Future<Logs> createLog(Logs logs) async {
    final response = await http.post(
      Uri.parse(logssUrl),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
      body: jsonEncode(logs.toJson()),
    );
    if (response.statusCode == 201) {
      return logs;
    } else {
      throw Exception('${response.body} failed to create logs');
    }
  }

  Future<Logs> updateLog(String id, Logs logs) async {
    final response = await http.put(
      Uri.parse('$logssUrl/$id'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
      body: jsonEncode(logs.toJson()),
    );
    if (response.statusCode == 200) {
      return logs;
    } else {
      throw Exception('Failed to update logs');
    }
  }

  Future<void> deleteLog(String id) async {
    final response = await http.delete(
      Uri.parse('$logssUrl/$id'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': GlobalConfig.apiKey!,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete logs');
    }
  }
}
