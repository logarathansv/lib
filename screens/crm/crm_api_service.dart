import 'dart:convert';
import 'package:http/http.dart' as http;

class CrmApiService {
  final String baseUrl;
  final String authToken;

  CrmApiService({required this.baseUrl, required this.authToken});

  Future<List<dynamic>> getTopServicesLastMonth() async {
    final response = await http.get(
      Uri.parse('$baseUrl/bs/top-services-count'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load top services');
    }
  }

  Future<List<dynamic>> getBottomServicesLastMonth() async {
    final response = await http.get(
      Uri.parse('$baseUrl/bs/bottom-services-count'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load bottom services');
    }
  }

  Future<List<dynamic>> getTopServicesRevenue() async {
    final response = await http.get(
      Uri.parse('$baseUrl/bs/top-services-revenue'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load top services revenue');
    }
  }

  Future<List<dynamic>> getTopServicesRevenueWeekly() async {
    final response = await http.get(
      Uri.parse('$baseUrl/bs/top-services-revenue-weekly'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load top services revenue weekly');
    }
  }

  Future<List<dynamic>> getTopServicesRevenueYearly() async {
    final response = await http.get(
      Uri.parse('$baseUrl/bs/top-services-revenue-yearly'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load top services revenue yearly');
    }
  }

  Future<List<dynamic>> getNewOldRevenue() async {
    final response = await http.get(
      Uri.parse('$baseUrl/bs/new_old_revenue'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load new old revenue');
    }
  }

  Future<List<dynamic>> getTotalAnalytics() async {
    final response = await http.get(
      Uri.parse('$baseUrl/bs/total-analytics'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load total analytics');
    }
  }

  Future<List<dynamic>> getTopCustomersRevenue() async {
    final response = await http.get(
      Uri.parse('$baseUrl/bs/top-customers-revenue'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load top customers revenue');
    }
  }

  Future<List<dynamic>> getBottomCustomersRevenue() async {
    final response = await http.get(
      Uri.parse('$baseUrl/bs/bottom-customer-revenue'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load top customers revenue');
    }
  }

  //inactive customers
  Future<List<dynamic>> getBottomCustomerCount() async {
    final response = await http.get(
      Uri.parse('$baseUrl/bs/bottom-customer-count'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load top customers revenue');
    }
  }

  //weekly customer count
  Future<List<dynamic>> getWeeklyCustomerCount() async {
    final response = await http.get(
      Uri.parse('$baseUrl/bs/weekly_analytics'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load top customers revenue');
    }
  }

  //monthly customer count
  Future<List<dynamic>> getMonthlyCustomerCount() async {
    final response = await http.get(
      Uri.parse('$baseUrl/bs/monthly_analytics'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load top customers revenue');
    }
  }

  //past services of a particular customer
  Future<List<dynamic>> getPastServices(customerId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/bs/past_services'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
        'Request-Body': '$customerId',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load top customers revenue');
    }
  }
}
