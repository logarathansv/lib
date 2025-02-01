import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'profile_page.dart';

class DisplayProfile extends StatelessWidget {
  final String name = "John Doe"; // Example data
  final String profilePicture =
      "assets/profile.jpg"; // Example profile picture path
  final String phone = "+1-234-567-890";
  final String email = "johndoe@example.com";
  final List<Map<String, String>> services = [
    {"name": "Service 1", "description": "Description for Service 1"},
    {"name": "Service 2", "description": "Description for Service 2"},
  ];
  final String certificateImage = "assets/gear.png";
  final List<Map<String, String>> availability = [
    {"day": "Monday", "start": "9:00 AM", "end": "5:00 PM"},
    {"day": "Tuesday", "start": "10:00 AM", "end": "4:00 PM"},
    {"day": "Wednesday", "start": "9:30 AM", "end": "5:30 PM"},
    {"day": "Thursday", "start": "9:00 AM", "end": "5:00 PM"},
    {"day": "Friday", "start": "9:00 AM", "end": "5:00 PM"},
    {"day": "Saturday", "start": "Closed", "end": "Closed"},
    {"day": "Sunday", "start": "Closed", "end": "Closed"},
  ];
  final String pricing = "5000 Rs/day";

  DisplayProfile({super.key});
  void _downloadCertificate(BuildContext context) {
    const String fileUrl =
        "https://example.com/certificate.jpg"; // URL to download the certificate
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Downloading..."),
        content: const Text("The certificate is being downloaded."),
        actions: [
          CupertinoDialogAction(
            child: const Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
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
          'Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2f4757),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(profilePicture),
                ),
              ),
              const SizedBox(height: 20),
              // Name
              Center(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontFamily: 'Parkinsans',
                    color: Color(0xFF2F4757),
                    decorationThickness: 0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Contact Details
              const Text(
                'Contact Details',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Parkinsans',
                  color: Color(0xFF028F83),
                  decorationThickness: 0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.phone_outlined, color: Color(0xFF028F83)),
                  const SizedBox(width: 10),
                  GestureDetector(
                    child: Text(
                      phone,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Parkinsans',
                        color: Color(0xFF2F4757),
                        decorationThickness: 0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.mail_outline, color: Color(0xFF028F83)),
                  const SizedBox(width: 10),
                  GestureDetector(
                    child: Text(
                      email,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Parkinsans',
                        color: Color(0xFF2F4757),
                        decorationThickness: 0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Contact Details
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Pricing Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Parkinsans',
                      color: Color(0xFF028F83),
                      decorationThickness: 0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                      pricing,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Parkinsans',
                        color: Colors.black,
                        decorationThickness: 0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Services Section
              const Text(
                'Services Provided',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Parkinsans',
                  color: Color(0xFF028F83),
                  decorationThickness: 0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ...services.map((service) {
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(
                      service['name']!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Parkinsans',
                        color: Color(0xFF2F4757),
                        decorationThickness: 0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(service['description']!),
                  ),
                );
              }),
              const SizedBox(height: 20),
              // Availability Section
              const Text(
                'Availability',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Parkinsans',
                  color: Color(0xFF028F83),
                  decorationThickness: 0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ...availability.map((day) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      day['day']!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Parkinsans',
                        color: Color(0xFF2F4757),
                        decorationThickness: 0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      day['start'] == 'Closed'
                          ? 'Closed'
                          : '${day['start']} - ${day['end']}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Parkinsans',
                        color: Color(0xFF2F4757),
                        decorationThickness: 0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    'Certificate : ',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Parkinsons',
                      color: Color(0xFF028F83),
                      decorationThickness: 0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to Edit Profile Page
                      _downloadCertificate(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // White background
                      side: const BorderSide(
                          color:
                              Colors.transparent), // Border with color #036C7B
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                      elevation: 0, // Optional: Remove shadow
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'View',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Parkinsans',
                            color: Colors.black, // Text color #036C7B
                            fontWeight: FontWeight
                                .normal, // Optional: Make the text bold
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Edit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to Edit Profile Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileSettings()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // White background
                    side: const BorderSide(
                        color: Color(0xFF036C7B)), // Border with color #036C7B
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                    ),
                    elevation: 0, // Optional: Remove shadow
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        color: Color(0xFF036C7B),
                        size: 20,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Parkinsans',
                          color: Color(0xFF036C7B), // Text color #036C7B
                          fontWeight:
                              FontWeight.normal, // Optional: Make the text bold
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
