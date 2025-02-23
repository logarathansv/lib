import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sklyit_business/models/profile_model/personal_details_model.dart';

import '../../providers/profile_provider.dart';

class EditPage extends ConsumerStatefulWidget {
  PersonalDetailsModel user;

  EditPage({required this.user});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends ConsumerState<EditPage> {
  final storage = FlutterSecureStorage();
  late TextEditingController nameController;
  late TextEditingController genderController;
  late TextEditingController doorNoController;
  late TextEditingController streetController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController pincodeController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    genderController = TextEditingController(text: widget.user.gender);
    doorNoController = TextEditingController(text: widget.user.addressDoorno);
    streetController = TextEditingController(text: widget.user.addressStreet);
    cityController = TextEditingController(text: widget.user.addressCity);
    stateController = TextEditingController(text: widget.user.addressState);
    pincodeController = TextEditingController(text: widget.user.addressPincode);
  }

  @override
  void dispose() {
    // Dispose controllers to free memory
    nameController.dispose();
    genderController.dispose();
    doorNoController.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();
    super.dispose();
  }

  File? file;

  void _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        file = File(pickedFile.path);
      });
    }
  }



  void _updateProfile(BuildContext context) async {
    final uid = await storage.read(key: 'userId');
    final updatedata = {
      "name" : nameController.text,
      "gender" : genderController.text,
      "addressDoorno": doorNoController.text,
      "addressStreet": streetController.text,
      "addressCity": cityController.text,
      "addressState": stateController.text,
      "addressPincode": pincodeController.text,
      if(file != null) "image": file
    };
    // final updateApi = await UpdateProfileAPIService().updateUserProfile(updatedata).then((_) async => await uploadProfilePicAPIService().uploadPhoto(filePath!));
    final updateApi = await ref.read(fetchProfileAPI).updateProfile(updatedata, file);
    print(updateApi);
    if(updateApi == 'Profile Updated Successfully'){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile Updated !'), backgroundColor: Colors.teal,)
      );
      ref.invalidate(userProfileProvider);
      Navigator.pop(context);
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error Updating Profile !'), backgroundColor: Colors.redAccent,)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.grey.shade200,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: file != null
                          ? FileImage(file!) // Show selected image
                          : (widget.user.imgurl.isNotEmpty
                          ? NetworkImage(widget.user.imgurl)
                          : AssetImage('assets/images/user.png')) as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.grey.shade300,
                          child: Icon(Icons.edit, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              _buildSectionTitle('Basic Information'),
              _buildCard(
                children: [
                  _buildEditableTile('Name', nameController, Icons.person),
                  _buildDisabledTile('Email', widget.user.gmail, Icons.email),
                  _buildDisabledTile('Phone', widget.user.mobileno, Icons.phone),
                  _buildDisabledTile(
                      'WhatsApp', widget.user.wtappNo, HugeIcons.strokeRoundedWhatsapp),
                ],
              ),
              SizedBox(height: 20),
              _buildSectionTitle('Address Details'),
              _buildCard(
                children: [
                  _buildEditableTile(
                      'Gender', genderController, Icons.person_outline),
                  _buildEditableTile(
                      'Door No.', doorNoController, Icons.home_outlined),
                  _buildEditableTile(
                      'Street', streetController, Icons.location_on_outlined),
                  _buildEditableTile(
                      'City', cityController, Icons.location_city_outlined),
                  _buildEditableTile(
                      'State', stateController, Icons.map_outlined),
                  _buildEditableTile(
                      'Pincode', pincodeController, Icons.pin_outlined),
                ],
              ),
              SizedBox(height: 30),
              Center(
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _updateProfile(context),
                      icon: Icon(Icons.update),
                      label: Text('Update Profile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding:
                        EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 4,
                        shadowColor: Colors.amber.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildDisabledTile(String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey, size: 28),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
      ),
      subtitle: Text(
        value,
        style: TextStyle(color: Colors.grey.shade600),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    );
  }

  Widget _buildEditableTile(String title, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 28),
          SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: title,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '$title cannot be empty';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
