import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GlobalConfig {
  static const String base_url = 'https://faktur.cybercode.id';
  static final String? apiKey = dotenv.env['api_key'];
}
