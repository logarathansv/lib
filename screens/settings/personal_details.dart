import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sklyit_business/models/profile_model/personal_details_model.dart';

import '../../providers/profile_provider.dart';
import 'personal_details_edit.dart';

class ProfilePage extends ConsumerStatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late String avatarUrl;

  @override
  void initState() {
    super.initState();
    avatarUrl = 'assets/images/user.png'; // Default image
  }

  void _navigateToEditPage(PersonalDetailsModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPage(user : user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userdetailsAsync = ref.watch(userProfileProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff4c345),
        leading: IconButton(
          onPressed: ()  {Navigator.of(context).pop(); },
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft03,
            color: Colors.black,
            size: 24.0,
          ),
        ),
        title: Text(
          'Personal Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2f4757),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              userdetailsAsync.when(
                  data: (user) {
                    return (user.imgurl.isNotEmpty) ?
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 75,
                              backgroundImage: NetworkImage(user.imgurl),
                              backgroundColor: Colors.white,
                            ),
                          ],
                        ),
                      )
                        : _buildAvatarSection(avatarUrl);
                  },
                  error: (error, stackTrace) {
                    return Text('Error: $error');
                  },
                  loading: () {
                    return CircularProgressIndicator();
                  }
              )
              ,
              SizedBox(height: 20),
              userdetailsAsync.when(
                  data: (user) {
                    return _buildProfileDetails(user);
                  },
                  error: (error, stackTrace) {
                    return Text('Error: $error');
                  },
                  loading: () {
                    return CircularProgressIndicator();
                  }
              )
              ,
              SizedBox(height: 20),
              Center(
                  child: userdetailsAsync.when(
                      data: (user) {
                        return ElevatedButton.icon(
                          onPressed: () => _navigateToEditPage(user),
                          icon: Icon(Icons.edit, color: Colors.white),
                          label: Text('Edit Profile', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            shadowColor: Colors.blue.withOpacity(0.4),
                            elevation: 6,
                          ),
                        );
                      },
                      error: (error, stackTrace) {
                        return Text('Error: $error');
                      },
                      loading: () {
                        return CircularProgressIndicator();
                      }
                  )

              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection(String url) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 75,
            backgroundImage: AssetImage(url),
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetails(PersonalDetailsModel user) {
    return Card(
      elevation: 6,
      shadowColor: Colors.grey.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildProfileItem(
              icon: HugeIcons.strokeRoundedUser,
              title: 'Name',
              value: user.name,
            ),
            Divider(height: 20, color: Colors.grey.shade300),
            _buildProfileItem(
              icon: HugeIcons.strokeRoundedMail01,
              title: 'Email',
              value: user.gmail,
            ),
            Divider(height: 20, color: Colors.grey.shade300),
            _buildProfileItem(
              icon: HugeIcons.strokeRoundedAiPhone01,
              title: 'Phone',
              value: user.mobileno,
            ),
            Divider(height: 20, color: Colors.grey.shade300),
            _buildProfileItem(
              icon: HugeIcons.strokeRoundedWhatsapp,
              title: 'WhatsApp',
              value: user.wtappNo,
            ),
            Divider(height: 20, color: Colors.grey.shade300),
            _buildProfileItem(
              icon: Icons.person_outline,
              title: 'Gender',
              value: user.gender,
            ),
            Divider(height: 20, color: Colors.grey.shade300),
            _buildProfileItem(
              icon: Icons.location_on,
              title: 'Address',
              value:
              "${user.addressDoorno}, ${user.addressStreet},\n${user.addressCity}, ${user.addressState} - ${user.addressPincode}",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem({required IconData icon, required String title, required String value}) {
    return ListTile(
      leading: Icon(icon, size: 30, color: Colors.blueAccent),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
      ),
    );
  }
}
