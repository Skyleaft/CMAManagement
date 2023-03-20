import 'dart:convert';
import 'package:flutter_guid/flutter_guid.dart';

class Logs {
  final Guid id;
  final String namaLog;
  final Guid userID;
  final String column;
  final String action;
  final DateTime timestamp;

  const Logs({
    required this.id,
    required this.namaLog,
    required this.userID,
    required this.column,
    required this.action,
    required this.timestamp,
  });

  factory Logs.fromJson(Map<String, dynamic> json) {
    return Logs(
      id: new Guid(json["id"]),
      timestamp: DateTime.parse(json["timestamp"]),
      namaLog: json["namaLog"],
      userID: new Guid(json["userID"]),
      column: json["column"],
      action: json["action"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id.value,
      "timestamp": timestamp.toUtc().toIso8601String(),
      "namaLog": namaLog,
      "userID": userID.value,
      "column": column,
      "action": action,
    };
  }
}

List<Logs> produkFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Logs>.from(data.map((item) => Logs.fromJson(item)));
}

String produkToJson(Logs data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
