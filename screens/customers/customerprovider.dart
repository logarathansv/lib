import 'package:flutter/material.dart';
import 'customer_repository.dart';
import '../../models/customer_model/customer_class.dart';

class CustomerProvider with ChangeNotifier {
  final CustomerRepository _repository = CustomerRepository();
  List<Customer> _customers = [];
  bool _isLoading = false;
  String _error = '';

  List<Customer> get customers => _customers;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchCustomers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _customers = await _repository.fetchCustomers();
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
