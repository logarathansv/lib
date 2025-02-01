import 'package:flutter/material.dart';

class SupplierTab extends StatelessWidget {
  const SupplierTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10.0),
              Text(
                'Add all your supplier here and save time by easily recording sale/purchase done with them.',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
