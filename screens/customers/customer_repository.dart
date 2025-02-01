import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../models/customer_model/customer_class.dart';

class CustomerRepository {
  final String _baseUrl = 'https://your-backend-api.com/customers';

  Future<List<Customer>> fetchCustomers() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Customer.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load customers');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}
