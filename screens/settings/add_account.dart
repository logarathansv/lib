// lib/add_account.dart
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class AddAccount extends StatefulWidget {
  @override
  _AddAccountState createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _ifscCodeController = TextEditingController();
  String? _selectedCity;

  bool _isValidAccountNumber(String number) {
    return number.length >= 10 && number.length <= 15;
  }

  void _addAccount() {
    // Normally, you would save the account details here
    Navigator.pop(context); // Navigate back to the display page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff4c345),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => {
            Navigator.of(context).pop()
          },
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft03,
            color: Colors.black,
            size: 24.0,
          ),
        ),
        title: Text(
          'Add Account',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2f4757),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _accountNumberController,
                  decoration: InputDecoration(
                    labelText: 'Account Number',
                    suffixIcon: _isValidAccountNumber(_accountNumberController.text)
                        ? Icon(Icons.check, color: Colors.green)
                        : Icon(Icons.clear, color: Colors.red),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {}); // Update the UI when text changes
                  },
                ),
                TextField(
                  controller: _bankNameController,
                  decoration: InputDecoration(labelText: 'Bank Name'),
                ),
                TextField(
                  controller: _ifscCodeController,
                  decoration: InputDecoration(labelText: 'IFSC Code'),
                ),
                DropdownButton<String>(
                  value: _selectedCity,
                  hint: Text('Select Bank City'),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCity = newValue;
                    });
                  },
                  items: <String>['City 1', 'City 2', 'City 3']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addAccount,
                  child: Text('Add Account', style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}