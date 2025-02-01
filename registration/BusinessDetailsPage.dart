import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Use Riverpod
import 'package:sklyit_business/data/business_provider.dart'; // Ensure this includes your provider file
import 'package:sklyit_business/main.dart'; // Import as needed

class BusinessDetailsPage extends ConsumerStatefulWidget {
  @override
  _BusinessDetailsPageState createState() => _BusinessDetailsPageState();
}

class _BusinessDetailsPageState extends ConsumerState<BusinessDetailsPage> {
  String? domain;
  late String clientName = '';
  late String shopName = '';
  late String shopDescription = '';
  late String shopAddress = '';
  late String shopEmail = ''; // Added if you want to capture email
  late String shopContactNumber = '';
  late String shopLocations = ''; // Make it a string for now; could be a list
  late String shopOpeningTime = '';
  late String shopClosingTime = '';
  late String businessMainTags = '';
  late String businessSubTags = '';

  Map<String, String> validationErrors = {};

  bool get _wrongDomain => domain == null;
  bool get _wrongClientName => clientName.trim().isEmpty;
  bool get _wrongBusinessName => shopName.trim().isEmpty;
  bool get _wrongBusinessDescription => shopDescription.trim().isEmpty;
  bool get _wrongBusinessAddress => shopAddress.trim().isEmpty;
  bool get _wrongBusinessContact => shopContactNumber.trim().isEmpty;

  String _domainText = 'Please select a domain';
  String _clientNameText = 'Client Name cannot be empty';
  String _businessNameText = 'Business Name cannot be empty';
  String _businessDescText = 'Business Description cannot be empty';
  String _businessAddressText = 'Business Address cannot be empty';
  String _contactText = 'Contact Number cannot be empty';

  @override
  Widget build(BuildContext context) {
    // Accessing the BusinessNotifier directly with Riverpod
    final businessDataProvider = ref.watch(businessProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Business Details',
                style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30.0),
              _buildDomainDropdown(),
              const SizedBox(height: 20.0),
              _buildTextField(
                label: 'Client Name',
                hint: 'Enter client name',
                onChanged: (value) {
                  clientName = value;
                  //businessDataProvider.updateClientName(value);
                },
                errorKey: _wrongClientName ? 'client_name' : null,
              ),
              const SizedBox(height: 20.0),
              _buildTextField(
                label: 'Business Name',
                hint: 'Enter your business name',
                onChanged: (value) {
                  shopName = value;
                  businessDataProvider.updateShopName(value);
                },
                errorKey: _wrongBusinessName ? 'name' : null,
              ),
              const SizedBox(height: 20.0),
              _buildTextField(
                label: 'Business Description',
                hint: 'Enter business description',
                onChanged: (value) {
                  shopDescription = value;
                  businessDataProvider.updateShopDescription(value);
                },
                errorKey: _wrongBusinessDescription ? 'description' : null,
              ),
              const SizedBox(height: 20.0),
              _buildTextField(
                label: 'Business Address',
                hint: 'Enter business address',
                onChanged: (value) {
                  shopAddress = value;
                  businessDataProvider.updateShopAddress(value);
                },
                errorKey: _wrongBusinessAddress ? 'address' : null,
              ),
              const SizedBox(height: 20.0),
              _buildTextField(
                label: 'Business Contact Number',
                hint: 'Enter contact number',
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  shopContactNumber = value;
                  businessDataProvider.updateBusinessPhone(value);
                },
                errorKey: _wrongBusinessContact ? 'contact' : null,
              ),
              const SizedBox(height: 20.0),
              _buildTextField(
                label: 'Shop Locations',
                hint: 'Enter shop locations',
                onChanged: (value) {
                  shopLocations = value;
                  businessDataProvider.updateShopLocations(value);
                },
              ),
              const SizedBox(height: 20.0),
              _buildTextField(
                label: 'Shop Opening Time',
                hint: 'Enter opening time (e.g., 09:00 AM)',
                onChanged: (value) {
                  shopOpeningTime = value;
                  //businessDataProvider.updateShopOpeningTime(value);
                },
              ),
              const SizedBox(height: 20.0),
              _buildTextField(
                label: 'Shop Closing Time',
                hint: 'Enter closing time (e.g., 09:00 PM)',
                onChanged: (value) {
                  shopClosingTime = value;
                  //businessDataProvider.updateShopClosingTime(value);
                },
              ),
              const SizedBox(height: 20.0),
              _buildTextField(
                label: 'Business Main Tags',
                hint: 'Enter main tags (comma separated)',
                onChanged: (value) {
                  businessMainTags = value;
                  //businessDataProvider.updateBusinessMainTags(value);
                },
              ),
              const SizedBox(height: 20.0),
              _buildTextField(
                label: 'Business Sub Tags',
                hint: 'Enter sub tags (comma separated)',
                onChanged: (value) {
                  businessSubTags = value;
                  //businessDataProvider.updateBusinessSubTags(value);
                },
              ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  backgroundColor: const Color(0xff447def),
                ),
                onPressed: _submitBusinessDetails,
                child: const Text(
                  'Complete Registration',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10.0),

              // developer skip button, need to be removed in the future
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PersonalCareBusinessPage(),
                    ),
                  );
                },
                child: const Text(
                  'Developer Skip',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitBusinessDetails() {
    setState(() {
      validationErrors.clear();

      if (_wrongDomain) validationErrors['domain'] = _domainText;
      if (_wrongClientName) validationErrors['client_name'] = _clientNameText;
      if (_wrongBusinessName) validationErrors['name'] = _businessNameText;
      if (_wrongBusinessDescription)
        validationErrors['description'] = _businessDescText;
      if (_wrongBusinessAddress)
        validationErrors['address'] = _businessAddressText;
      if (_wrongBusinessContact) validationErrors['contact'] = _contactText;
    });

    if (validationErrors.isEmpty) {
      // Proceed to the next page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PersonalCareBusinessPage(),
        ),
      );
    } else {
      // Show errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill in all required fields correctly.')),
      );
    }
  }

  Widget _buildDomainDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Domain',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10.0),
        DropdownButton<String>(
          value: domain,
          hint: const Text('Select Domain'),
          items: <String>[
            'Personal Care',
            'Gym',
            'Electronics',
            'Laundry',
            'Others'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              domain = newValue;
            });
          },
          isExpanded: true,
          underline: const SizedBox(),
        ),
        if (_wrongDomain)
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              _domainText,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    String? hint,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
    String? errorKey,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            errorText: errorKey != null ? validationErrors[errorKey] : null,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
