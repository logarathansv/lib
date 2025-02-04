import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/customer_model/customer_class.dart';
import '../../screens/chat/chat_screen.dart';

class CustomerCard extends StatelessWidget {
  final Customer customer;

  const CustomerCard({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75, // 40% of screen width
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Card(
          elevation: 4.0, // Subtle shadow effect
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer Name
                Text(
                  customer.name,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8), // Spacing
                // Customer Address
                Text(
                  customer.address,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12), // Spacing
                // Contact Icons (Row)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Phone Icon
                    IconButton(
                      onPressed: () async {
                        final Uri url =
                            Uri(scheme: 'tel', path: customer.phoneNumber);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          print('Could not launch the phone dialer');
                        }
                      },
                      icon: const Icon(
                        Icons.call_rounded,
                        size: 22,
                        color: Color(0xFF028F83),
                      ),
                    ),
                    // Chat Icon
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.chat_outlined,
                        size: 22,
                        color: Color(0xFF028F83),
                      ),
                    ),
                    // WhatsApp Icon
                    IconButton(
                      onPressed: () {
                        print("WhatsApp Opens");
                      },
                      icon: const HugeIcon(
                        icon: HugeIcons.strokeRoundedWhatsapp,
                        color: Color(0xFF028F83),
                        size: 24.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
