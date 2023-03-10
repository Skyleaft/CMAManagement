import 'dart:convert';
import 'package:cma_management/config/global_config.dart';
import 'package:cma_management/model/Customer.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:http/http.dart' as http;

class CustomerService {
  static const String customersUrl = '${GlobalConfig.base_url}/api/customer';

  Future<List<Customer>> getCustomers() async {
    final response = await http.get(Uri.parse(customersUrl));
    if (response.statusCode == 200) {
      final List<dynamic> customersJson = jsonDecode(response.body);
      return customersJson.map((json) => Customer.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load customers');
    }
  }

  Future<Customer> getCustomer(String id) async {
    final response = await http.get(Uri.parse('$customersUrl/$id'));
    if (response.statusCode == 200) {
      final dynamic customerJson = jsonDecode(response.body);
      return Customer.fromJson(customerJson);
    } else {
      throw Exception('Failed to load customer');
    }
  }

  Future<Customer> createCustomer(Customer customer) async {
    final response = await http.post(
      Uri.parse(customersUrl),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(customer.toJson()),
    );
    if (response.statusCode == 201) {
      final dynamic customerJson = jsonDecode(response.body);
      return Customer.fromJson(customerJson);
    } else {
      throw Exception('${customer.toJson()} failed to create customer');
    }
  }

  Future<Customer> updateCustomer(String id, Customer customer) async {
    final response = await http.put(
      Uri.parse('$customersUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(customer.toJson()),
    );
    if (response.statusCode == 200) {
      final dynamic customerJson = jsonDecode(response.body);
      return Customer.fromJson(customerJson);
    } else {
      throw Exception('Failed to update customer');
    }
  }

  Future<void> deleteCustomer(String id) async {
    final response = await http.delete(Uri.parse('$customersUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete customer');
    }
  }
}
