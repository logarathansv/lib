// lib/account_display.dart
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'add_account.dart';

class BankDetails extends StatefulWidget {
  const BankDetails({super.key});

  @override
  _AccountDisplayState createState() => _AccountDisplayState();
}

class _AccountDisplayState extends State<BankDetails> {
  List<Map<String, String>> accounts = [
    {
      'holder': 'John Doe',
      'bank': 'Bank of Example',
      'number': '1234567890123456',
    },
    {
      'holder': 'Jane Smith',
      'bank': 'Sample Bank',
      'number': '6543217890123456',
    },
    {
      'holder': 'Alice Johnson',
      'bank': 'Fictional Bank',
      'number': '1111112222222222',
    },
  ];

  String? primaryAccount;

  void _setAsPrimary(String accountNumber) {
    setState(() {
      primaryAccount = accountNumber;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account set as primary')),
    );
  }

  void _deleteAccount(String accountNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text('Are you sure you want to delete this account?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                setState(() {
                  accounts.removeWhere(
                      (account) => account['number'] == accountNumber);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account deleted')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff4c345),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => {Navigator.of(context).pop()},
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft03,
            color: Colors.black,
            size: 24.0,
          ),
        ),
        title: const Text(
          'Bank Accounts',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2f4757),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: accounts.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      accounts[index]['holder']!,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(accounts[index]['bank']!),
                    const SizedBox(height: 8),
                    Text(
                      '${accounts[index]['number']!.substring(0, 6)}******',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () =>
                              _setAsPrimary(accounts[index]['number']!),
                          icon: const Icon(
                            Icons.star,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Primary',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                primaryAccount == accounts[index]['number']
                                    ? Colors.orange
                                    : Colors.teal,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _deleteAccount(accounts[index]['number']!),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddAccount()),
          );
        },
        backgroundColor: Colors.teal,
        child: Icon(Icons.add),
      ),
    );
  }
}
