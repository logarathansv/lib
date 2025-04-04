import 'package:flutter/material.dart';

class ShopInfoCard extends StatelessWidget {
  final String followers;
  final String popularity;
  final String shopAddress;
  final String likesCount;

  const ShopInfoCard({
    super.key,
    required this.followers,
    required this.popularity,
    required this.shopAddress,
    required this.likesCount,
  });

  @override
  Widget build(BuildContext context) {
    // Colors for buttons, icons, and labels
    Color iconColorflr = Colors.black;
    Color labelColorflr = Colors.black;
    Color bgColorflr = Colors.grey.shade200;

    // Screen dimensions
    double screenWidth = MediaQuery.of(context).size.width;

    // Dynamic icon and text size
    double iconSize = screenWidth * 0.06; // Adjust to screen width
    double textSize = screenWidth * 0.035;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Followers and Popularity Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoRow(
                  Icons.people, '$followers Followers', iconSize, textSize),
              _buildInfoRow(
                  Icons.star, '$popularity Popularity', iconSize, textSize),
            ],
          ),
          const SizedBox(height: 16),

          // Follow, Like, Rate Section with Circular Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCircularButton(
                  Icons.person_add, "Follow", iconSize, textSize),
              _buildCircularButton(
                  Icons.thumb_up, likesCount, iconSize, textSize),
              _buildCircularButton(
                  Icons.star_border, "Rate", iconSize, textSize),
            ],
          ),
          const SizedBox(height: 16),

          // Skylit Verified
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: iconSize),
              const SizedBox(width: 4),
              Text(
                'SklyIt Verified',
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: textSize),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Call and WhatsApp Buttons with Dynamic Width
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDynamicButton(
                icon: Icons.phone,
                label: 'Call Now',
                color: Colors.blue,
                iconSize: iconSize,
                textSize: textSize,
              ),
              _buildDynamicButton(
                icon: Icons.chat,
                label: 'WhatsApp',
                color: Colors.green,
                iconSize: iconSize,
                textSize: textSize,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Shop Address
          Text(shopAddress, style: TextStyle(fontSize: textSize)),
          const SizedBox(height: 16),

          // Shop Open Status
          Row(
            children: [
              Icon(Icons.circle, color: Colors.green, size: iconSize),
              const SizedBox(width: 4),
              Text('Shop Open Now', style: TextStyle(fontSize: textSize)),
            ],
          ),
        ],
      ),
    );
  }

  // Helper Method for Icon + Text Row
  Widget _buildInfoRow(
      IconData icon, String label, double iconSize, double textSize) {
    return Row(
      children: [
        Icon(icon, size: iconSize),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: textSize)),
      ],
    );
  }

  // Helper Method for Circular Buttons
  Widget _buildCircularButton(
      IconData icon, String label, double iconSize, double textSize) {
    return Column(
      children: [
        Container(
          width: iconSize * 1.8, // Adjust circle size dynamically
          height: iconSize * 1.8,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              icon,
              size: iconSize,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: textSize, color: Colors.black),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Helper Method for Dynamic Buttons (Call and WhatsApp)
  Widget _buildDynamicButton({
    required IconData icon,
    required String label,
    required Color color,
    required double iconSize,
    required double textSize,
  }) {
    return Expanded(
      child: Container(
        height: iconSize * 2, // Dynamic height
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: iconSize, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: textSize,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
