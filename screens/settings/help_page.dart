import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff4c345),
        leading: IconButton(
          onPressed: ()  {Navigator.of(context).pop();},
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft03,
            color: Colors.black,
            size: 24.0,
          ),
        ),
        title: Text(
          'Help & Contact',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2f4757),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Assistance Icon
              Icon(
                Icons.help_outline,
                size: 80.0,
                color: Colors.blue,
              ),
              SizedBox(height: 20.0),
              // Heading
              Text(
                'Need Assistance?',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 30.0),
              // Contact Information Section
              Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    // Email with Icon
                    Row(
                      children: [
                        Icon(
                          Icons.email,
                          color: Colors.blue,
                          size: 24.0,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          'Email: loga@sklyit.app',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    // Mobile Number with Icon
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          color: Colors.blue,
                          size: 24.0,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          'Mobile: 8825624302',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
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
}
