import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sklyit_business/models/profile_model/business_details_model.dart';

import '../../providers/profile_provider.dart';
import 'business_profile_edit.dart';

class BusinessProfileViewPage extends ConsumerWidget {
  const BusinessProfileViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late BusinessProfile businessAsync;
    final businessProfileAsync = ref.watch(businessProfileProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff4c345),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft03,
            color: Colors.black,
            size: 24.0,
          ),
        ),
        title: Text(
          'Business Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2f4757),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditBusinessProfilePage(business: businessAsync),
                ),
              );
            },
            icon: Icon(Icons.edit, color: Colors.black),
          ),
        ],
      ),
      body: businessProfileAsync.when(
        data: (business) {
          businessAsync = business;
          return _buildProfilePage(context, business);
        },
        loading: () {
          return Center(child: CircularProgressIndicator());
        },
        error: (error, stackTrace) {
          return Center(child: Text("Error: $error"));
        }
      )
    );
  }

  Widget _buildProfilePage(BuildContext context, BusinessProfile business) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: business.shopImage.isNotEmpty
                      ? NetworkImage(business.shopImage)
                      : AssetImage('assets/default_business_image.png') as ImageProvider,
                ),
                SizedBox(height: 10),
                Text(
                  business.clientName,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  business.domainName,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // Business Information
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildProfileField("Shop Name", business.shopName, HugeIcons.strokeRoundedStore01),
                  _buildProfileField("Description", business.shopDesc, HugeIcons.strokeRoundedText),
                  _buildProfileField("Email", business.shopEmail, HugeIcons.strokeRoundedMail01),
                  _buildProfileField("Mobile", business.shopMobile, HugeIcons.strokeRoundedCall),
                  _buildProfileField("Opening Time", business.shopOpenTime, HugeIcons.strokeRoundedClock01),
                  _buildProfileField("Closing Time", business.shopClosingTime, HugeIcons.strokeRoundedClock01),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // Main Tags
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Main Tags", HugeIcons.strokeRoundedGrid),
                  Wrap(
                    spacing: 8,
                    children: business.businessMainTags
                        .map((tag) => Chip(label: Text("#$tag")))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // Sub Tags
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Sub Tags", HugeIcons.strokeRoundedGrid),
                  Wrap(
                    spacing: 8,
                    children: business.businessSubTags
                        .map((tag) => Chip(label: Text("#$tag")))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // Addresses
          _buildSectionTitle("Addresses", HugeIcons.strokeRoundedAddressBook),
          Column(
            children: business.addresses.map((address) {
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 5,
                margin: EdgeInsets.only(bottom: 16.0),
                child: ListTile(
                  leading: Icon(Icons.location_on, color: Colors.teal, size: 32),
                  title: Text(
                    "${address.street}, ${address.city}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${address.district}, ${address.state} - ${address.pincode}",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ),
              );
            }).toList(),
          ),

        ],
      ),
    );
  }

  Widget _buildProfileField(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 24),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 14, color: Colors.grey)),
                Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 28),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
          ),
        ],
      ),
    );
  }
}