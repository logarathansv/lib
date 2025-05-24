import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sklyit_business/screens/chat/chat_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/customer_model/customer_class.dart';
import '../../providers/customer_provider.dart';
import '../../screens/customers/get_customer_details.dart';

class CustomerCard extends ConsumerWidget {
  final Customer customer;
  final storage = FlutterSecureStorage();

  CustomerCard({super.key, required this.customer});

  Future<void> _editCustomer(BuildContext context) async {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddNewCustomerPage(customer: customer),
        transitionDuration: const Duration(milliseconds: 100),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: const Offset(0, 0),
              ).animate(animation),
              child: child,
            ),
          );
        },
      ),
    );
  }

  Future<void> _deleteCustomer(WidgetRef ref) async {
    try {
      final customerService = await ref.read(customerServiceProvider.future);
      await customerService.deleteCustomer(customer.custId!);
      ref.invalidate(getCustomerProvider);
    } catch (error) {
      print('Error deleting customer: $error');
    }
  }

  Future<void> openChat({required String phoneNumber, String? message}) async {
    final encodedMessage = Uri.encodeComponent(message ?? '');
    final uri = Uri.parse("https://wa.me/$phoneNumber?text=$encodedMessage");

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch WhatsApp';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use your color palette
    final Color primaryColor = Color(0xFFF0C445); // #F0C445
    final Color accentColor = Color(0xFF009085); // #009085
    final Color darkColor1 = Color(0xFF2F4858); // #2F4858
    final Color darkColor2 = Color(0xFF006B7C); // #006B7C

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 1.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Name + Edit & Delete icons
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        customer.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: darkColor2,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _editCustomer(context),
                      icon: Icon(Icons.edit, color: darkColor1),
                    ),
                    IconButton(
                      onPressed: () => _deleteCustomer(ref),
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Address
                Text(
                  customer.address,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                // Contact options
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () async {
                        final Uri url = Uri(scheme: 'tel', path: customer.phoneNumber);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          print('Could not launch phone dialer');
                        }
                      },
                      icon: Icon(Icons.call_rounded, color: darkColor2, size: 24),
                      tooltip: 'Call',
                    ),
                    IconButton(
                      onPressed: () async {
                        final uid = await storage.read(key: 'userId');
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              currentUserId: uid!,
                              receiverId: customer.custId!,
                              receiverName: customer.name,
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.chat_outlined, color: darkColor2, size: 24),
                      tooltip: 'Chat',
                    ),
                    IconButton(
                      onPressed: () {
                        openChat(phoneNumber: customer.phoneNumber, message: "Hello ! ${customer.name}");
                      },
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedWhatsapp,
                        color: darkColor2,
                        size: 24,
                      ),
                      tooltip: 'WhatsApp',
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